import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { LOCALE_COOKIE, LOCALE_HEADER, requestLocale, type Locale } from "@/lib/i18n/locale";
import { t } from "@/lib/i18n/translate";
import { GUIDE_SECTIONS, isExtraGuidePage } from "@/lib/content/sections";
import { SAMPLE_PROPERTIES } from "@/lib/content/sample-catalog";
import { guideSectionFromPath, slugToReject } from "@/lib/routing/property-path";
import { guideRedirectRequest } from "@/lib/routing/section-redirect";
import { getSiteKey, guideSectionRequest, publishedSlugsRequest } from "@/lib/site";
import { getSupabaseEnv } from "@/lib/supabase/env";
import { propertySlugSchema } from "@/lib/validation/slug";
import { getSiteConfig } from "@/sites";

const sampleSlugs = () =>
  getSiteKey() === "roost" ? new Set(SAMPLE_PROPERTIES.map((property) => property.slug)) : new Set<string>();

async function publishedSlugs(): Promise<Set<string>> {
  const env = getSupabaseEnv();
  if (!env) return sampleSlugs();

  try {
    const response = await fetch(publishedSlugsRequest(env.url, getSiteKey()), {
      headers: {
        apikey: env.key,
        Authorization: `Bearer ${env.key}`,
        Accept: "application/json",
      },
      cache: "no-store",
    });
    if (!response.ok) return sampleSlugs();
    const rows: unknown = await response.json();
    if (!Array.isArray(rows)) return sampleSlugs();
    return new Set(
      rows.flatMap((row) =>
        row && typeof row === "object" && "slug" in row && typeof row.slug === "string"
          ? [row.slug]
          : [],
      ),
    );
  } catch {
    return sampleSlugs();
  }
}

function localeFor(request: NextRequest): Locale {
  return requestLocale(request.cookies.get(LOCALE_COOKIE)?.value, request.headers.get("accept-language"));
}

function rememberLocale(request: NextRequest, response: NextResponse, locale: Locale): NextResponse {
  // Keep the cookie attributes aligned with setLocale() so client and proxy
  // writes replace the same cookie instead of stacking duplicates.
  if (request.cookies.get(LOCALE_COOKIE)?.value !== locale) {
    response.cookies.set(LOCALE_COOKIE, locale, {
      path: "/",
      maxAge: 60 * 60 * 24 * 365,
      sameSite: "lax",
    });
  }
  return response;
}

function continueWithLocale(request: NextRequest, locale: Locale): NextResponse {
  const headers = new Headers(request.headers);
  headers.set(LOCALE_HEADER, locale);
  return rememberLocale(request, NextResponse.next({ request: { headers } }), locale);
}

function notFoundResponse(locale: Locale) {
  const site = getSiteConfig();
  const html = `<!doctype html>
<html lang="${locale}">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="${site.colors.forest}" />
  <meta name="robots" content="noindex, nofollow" />
  <title>${t(locale, "pageMissingTitle")} · ${site.name}</title>
</head>
<body style="margin:0;background:${site.colors.cream};color:${site.colors.charcoal};font-family:Georgia,serif">
  <main style="max-width:36rem;margin:0 auto;padding:6rem 1.25rem">
    <h1 style="margin:0;font-weight:400;font-size:2.5rem;color:${site.colors.forest}">${t(locale, "pageMissingTitle")}</h1>
    <p style="font-family:Inter,sans-serif;font-size:1.125rem;line-height:1.6">${t(locale, "pageMissingBody")}</p>
    <p><a href="/" style="color:${site.colors.forest};font-family:Inter,sans-serif">${t(locale, "backToStays")}</a></p>
  </main>
</body>
</html>`;

  return new NextResponse(html, {
    status: 404,
    headers: {
      "content-type": "text/html; charset=utf-8",
      "x-robots-tag": "noindex, nofollow",
    },
  });
}

async function guideSectionMissing(pathname: string): Promise<boolean> {
  const target = guideSectionFromPath(pathname);
  if (!target) return false;
  if (isExtraGuidePage(target.section)) return false;
  if (!propertySlugSchema.safeParse(target.section).success) return true;

  const env = getSupabaseEnv();
  if (!env) return !GUIDE_SECTIONS.some((section) => section.slug === target.section);

  try {
    const response = await fetch(
      guideSectionRequest(env.url, getSiteKey(), target.property, target.section),
      {
        headers: {
          apikey: env.key,
          Authorization: `Bearer ${env.key}`,
          Accept: "application/json",
        },
        cache: "no-store",
      },
    );
    if (!response.ok) return false;
    const rows: unknown = await response.json();
    return Array.isArray(rows) && rows.length === 0;
  } catch {
    return false;
  }
}

export async function proxy(request: NextRequest) {
  const locale = localeFor(request);
  const pathname = request.nextUrl.pathname;
  const rejected = slugToReject(pathname, await publishedSlugs());
  if (rejected) return rememberLocale(request, notFoundResponse(locale), locale);

  const forward = guideRedirectRequest(pathname);
  if (forward) {
    const destination = `/${forward.property}/guide/${forward.section}`;
    if (destination !== pathname && !(await guideSectionMissing(destination))) {
      const url = request.nextUrl.clone();
      url.pathname = destination;
      return rememberLocale(request, NextResponse.redirect(url, 308), locale);
    }
  }

  if (await guideSectionMissing(pathname)) return rememberLocale(request, notFoundResponse(locale), locale);
  return continueWithLocale(request, locale);
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|robots.txt).*)"],
};
