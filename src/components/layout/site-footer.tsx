import Link from "next/link";
import type { Locale } from "@/lib/i18n/locale";
import { t } from "@/lib/i18n/translate";

export function SiteFooter({
  brandName,
  footerBlurb,
  properties,
  year,
  locale = "en",
}: {
  brandName: string;
  footerBlurb?: string;
  properties: { slug: string; name: string }[];
  year: number;
  locale?: Locale;
}) {
  return (
    <footer className="mt-auto border-t border-beige bg-beige/40">
      <div className="mx-auto grid w-full max-w-6xl gap-8 px-5 py-12 sm:grid-cols-2">
        <div>
          <p className="font-heading text-2xl text-forest">{brandName}</p>
          <p className="mt-3 max-w-sm text-base leading-7 text-muted-foreground">
            {footerBlurb ?? t(locale, "footerBlurb")}
          </p>
        </div>
        <nav aria-label={t(locale, "footerNav")} className="grid gap-2 sm:justify-items-end">
          {properties.map((property) => (
            <Link
              key={property.slug}
              href={`/${property.slug}`}
              className="inline-flex min-h-11 items-center text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              {property.name}
            </Link>
          ))}
          <Link
            href="/contact"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            {t(locale, "contact")}
          </Link>
          <Link
            href="/privacy"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            {t(locale, "privacy")}
          </Link>
          <Link
            href="/terms"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            {t(locale, "terms")}
          </Link>
        </nav>
        <p className="text-sm text-muted-foreground sm:col-span-2">
          © {year} {brandName}
        </p>
      </div>
    </footer>
  );
}
