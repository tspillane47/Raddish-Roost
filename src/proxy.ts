import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { DEFAULT_BRAND_NAME } from "@/lib/brand";
import { GUIDE_SECTIONS } from "@/lib/content/sections";
import { SAMPLE_PROPERTIES } from "@/lib/content/sample-catalog";
import { guideSectionFromPath, slugToReject } from "@/lib/routing/property-path";
import { guideRedirectRequest } from "@/lib/routing/section-redirect";
import { getSupabaseEnv } from "@/lib/supabase/env";
import { propertySlugSchema } from "@/lib/validation/slug";

const sampleSlugs = () => new Set(SAMPLE_PROPERTIES.map((property) => property.slug));

async function publishedSlugs(): Promise<Set<string>> {
  const env = getSupabaseEnv();
  if (!env) return sampleSlugs();

  try {
    const response = await fetch(
      `${env.url}/rest/v1/properties?select=slug&status=eq.published`,
      {
        headers: {
          apikey: env.key,
          Authorization: `Bearer ${env.key}`,
          Accept: "application/json",
        },
        cache: "no-store",
      },
    );
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

function notFoundResponse() {
  const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#263F35" />
  <meta name="robots" content="noindex, nofollow" />
  <title>Page not found · ${DEFAULT_BRAND_NAME}</title>
</head>
<body style="margin:0;background:#F7F4ED;color:#262626;font-family:Georgia,serif">
  <main style="max-width:36rem;margin:0 auto;padding:6rem 1.25rem">
    <h1 style="margin:0;font-weight:400;font-size:2.5rem;color:#263F35">We couldn't find that page</h1>
    <p style="font-family:Inter,sans-serif;font-size:1.125rem;line-height:1.6">The stay or page you asked for is not on this site.</p>
    <p><a href="/" style="color:#263F35;font-family:Inter,sans-serif">Back to all stays</a></p>
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
  if (!propertySlugSchema.safeParse(target.section).success) return true;

  const env = getSupabaseEnv();
  if (!env) return !GUIDE_SECTIONS.some((section) => section.slug === target.section);

  try {
    const url = new URL(`${env.url}/rest/v1/guidebook_sections`);
    url.searchParams.set("select", "slug,properties!inner(slug)");
    url.searchParams.set("slug", `eq.${target.section}`);
    url.searchParams.set("is_visible", "eq.true");
    url.searchParams.set("published_at", "not.is.null");
    url.searchParams.set("properties.slug", `eq.${target.property}`);
    url.searchParams.set("properties.status", "eq.published");
    const response = await fetch(url, {
      headers: {
        apikey: env.key,
        Authorization: `Bearer ${env.key}`,
        Accept: "application/json",
      },
      cache: "no-store",
    });
    if (!response.ok) return false;
    const rows: unknown = await response.json();
    return Array.isArray(rows) && rows.length === 0;
  } catch {
    return false;
  }
}

export async function proxy(request: NextRequest) {
  const pathname = request.nextUrl.pathname;
  const rejected = slugToReject(pathname, await publishedSlugs());
  if (rejected) return notFoundResponse();

  const forward = guideRedirectRequest(pathname);
  if (forward) {
    const destination = `/${forward.property}/guide/${forward.section}`;
    if (destination !== pathname && !(await guideSectionMissing(destination))) {
      const url = request.nextUrl.clone();
      url.pathname = destination;
      return NextResponse.redirect(url, 308);
    }
  }

  if (await guideSectionMissing(pathname)) return notFoundResponse();
  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|robots.txt).*)"],
};
