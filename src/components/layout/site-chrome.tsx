import { Suspense } from "react";
import { connection } from "next/server";
import { SiteFooter } from "@/components/layout/site-footer";
import { SiteHeader } from "@/components/layout/site-header";
import { t } from "@/lib/i18n/translate";
import { getLocale } from "@/lib/i18n/get-locale";
import { getBrandName, getPublishedProperties } from "@/lib/data/properties";
import { getSiteConfig } from "@/sites";

export function SiteChrome({ children }: { children: React.ReactNode }) {
  const site = getSiteConfig();
  return (
    <>
      <a
        href="#main"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:bg-forest focus:px-4 focus:py-3 focus:text-cream"
      >
        <SkipLink />
      </a>
      <Suspense fallback={<SiteHeader brandName={site.name} />}>
        <HeaderSlot />
      </Suspense>
      <main id="main" className="w-full min-w-0 flex-1">
        {children}
      </main>
      <Suspense
        fallback={
          <SiteFooter
            brandName={site.name}
            footerBlurb={site.key === "roost" ? undefined : site.footerBlurb}
            properties={[]}
            year={2026}
            locale="en"
          />
        }
      >
        <FooterSlot />
      </Suspense>
    </>
  );
}

async function SkipLink() {
  const locale = await getLocale();
  return t(locale, "skipToContent");
}

async function HeaderSlot() {
  const brandName = await getBrandName();
  return <SiteHeader brandName={brandName} />;
}

async function FooterSlot() {
  await connection();
  const locale = await getLocale();
  const site = getSiteConfig();
  const [brandName, properties] = await Promise.all([getBrandName(), getPublishedProperties()]);
  return (
    <SiteFooter
      brandName={brandName}
      footerBlurb={site.key === "roost" ? undefined : site.footerBlurb}
      properties={properties.ok ? properties.data.map(({ slug, name }) => ({ slug, name })) : []}
      year={new Date().getUTCFullYear()}
      locale={locale}
    />
  );
}
