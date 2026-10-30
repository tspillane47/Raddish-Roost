import { Suspense } from "react";
import { connection } from "next/server";
import { SiteFooter } from "@/components/layout/site-footer";
import { SiteHeader } from "@/components/layout/site-header";
import { DEFAULT_BRAND_NAME } from "@/lib/brand";
import { getBrandName, getPublishedProperties } from "@/lib/data/properties";

export function SiteChrome({ children }: { children: React.ReactNode }) {
  return (
    <>
      <a
        href="#main"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:bg-forest focus:px-4 focus:py-3 focus:text-cream"
      >
        Skip to content
      </a>
      <Suspense fallback={<SiteHeader brandName={DEFAULT_BRAND_NAME} />}>
        <HeaderSlot />
      </Suspense>
      <main id="main" className="w-full min-w-0 flex-1">
        {children}
      </main>
      <Suspense
        fallback={<SiteFooter brandName={DEFAULT_BRAND_NAME} properties={[]} year={2026} />}
      >
        <FooterSlot />
      </Suspense>
    </>
  );
}

async function HeaderSlot() {
  const brandName = await getBrandName();
  return <SiteHeader brandName={brandName} />;
}

async function FooterSlot() {
  await connection();
  const [brandName, properties] = await Promise.all([getBrandName(), getPublishedProperties()]);
  return (
    <SiteFooter
      brandName={brandName}
      properties={properties.ok ? properties.data.map(({ slug, name }) => ({ slug, name })) : []}
      year={new Date().getUTCFullYear()}
    />
  );
}
