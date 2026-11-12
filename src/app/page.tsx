import { Suspense } from "react";
import { CollectionHero } from "@/components/homepage/collection-hero";
import { ComingSoon } from "@/components/homepage/coming-soon";
import { WelcomeLodge } from "@/components/homepage/welcome-lodge";
import { PropertyCardFallback, PropertyCardGrid } from "@/components/homepage/property-card";
import { DadHome } from "@/components/dad/dad-home";
import { ErrinHome } from "@/components/errin/errin-home";
import { PreviewBanner } from "@/components/layout/preview-banner";
import { Tx } from "@/lib/i18n/locale-context";
import { orderLikeArtwork } from "@/lib/content/brand-art";
import { getPublishedProperties } from "@/lib/data/properties";
import { getSiteConfig } from "@/sites";

export default function HomePage() {
  const site = getSiteConfig();
  if (site.key === "dad") {
    return (
      <Suspense fallback={<DadHome site={site} properties={[]} />}>
        <DadHomeSlot />
      </Suspense>
    );
  }
  if (site.key === "errin") {
    return <ErrinHome site={site} />;
  }

  return (
    <>
      <Suspense fallback={null}>
        <PreviewSlot />
      </Suspense>
      <CollectionHero hero={site.hero} />
      <WelcomeLodge
        placeName={site.welcome.placeName}
        background={site.welcome.background}
        ink={site.welcome.ink}
        showSeasonIcons={site.welcome.showSeasonIcons}
        useLodgeFonts={site.welcome.useLodgeFonts}
      />
      <Suspense fallback={<HomeBodyFallback />}>
        <HomeBody />
      </Suspense>
    </>
  );
}

async function DadHomeSlot() {
  const site = getSiteConfig();
  const result = await getPublishedProperties();
  if (!result.ok) {
    return (
      <div className="mx-auto w-full max-w-6xl px-5 py-16">
        <p role="alert" className="rounded-xl bg-beige/70 px-5 py-8 text-base leading-7">
          <Tx k="guidebookFailed" />
        </p>
      </div>
    );
  }
  if (result.data.length === 0) {
    return (
      <>
        <DadHome site={site} properties={[]} />
        <ComingSoon title={site.comingSoonTitle} body={site.comingSoonBody} />
      </>
    );
  }
  return <DadHome site={site} properties={orderLikeArtwork(result.data, site.artworkOrder)} />;
}

function HomeBodyFallback() {
  return (
    <div className="mx-auto w-full max-w-6xl px-5 pb-16 pt-10 md:pb-20 md:pt-14">
      <h2 id="where-staying" className="font-heading text-3xl text-forest md:text-4xl">
        <Tx k="whereStaying" />
      </h2>
      <div className="mt-8">
        <PropertyCardFallback />
      </div>
    </div>
  );
}

async function PreviewSlot() {
  const result = await getPublishedProperties();
  if (!result.ok || result.source !== "preview") return null;
  return <PreviewBanner />;
}

async function HomeBody() {
  const site = getSiteConfig();
  const result = await getPublishedProperties();

  if (!result.ok) {
    return (
      <div className="mx-auto w-full max-w-6xl px-5 pb-16 pt-10">
        <p role="alert" className="rounded-xl bg-beige/70 px-5 py-8 text-base leading-7">
          <Tx k="guidebookFailed" />
        </p>
      </div>
    );
  }

  if (result.data.length === 0) {
    return <ComingSoon title={site.comingSoonTitle} body={site.comingSoonBody} />;
  }

  return (
    <div className="mx-auto w-full max-w-6xl px-5 pb-16 pt-10 md:pb-20 md:pt-14">
      <h2 id="where-staying" className="font-heading text-3xl text-forest md:text-4xl">
        <Tx k="whereStaying" />
      </h2>
      <div className="mt-8">
        <PropertyCardGrid properties={orderLikeArtwork(result.data, site.artworkOrder)} />
      </div>
      <section aria-labelledby="collection-heading" className="mt-20 border-t border-beige pt-12">
        <h2
          id="collection-heading"
          className="max-w-3xl font-heading text-3xl leading-tight text-charcoal md:text-4xl"
        >
          <Tx k="collectionHeading" />
        </h2>
        <p className="mt-4 max-w-2xl text-lg leading-8">
          <Tx k="collectionBody" />
        </p>
      </section>
    </div>
  );
}
