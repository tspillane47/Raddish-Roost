import { Suspense } from "react";
import { PreviewBanner } from "@/components/layout/preview-banner";
import { PropertyCardFallback, PropertyCardGrid } from "@/components/homepage/property-card";
import { getPublishedProperties } from "@/lib/data/properties";

export default function HomePage() {
  return (
    <>
      <Suspense fallback={null}>
        <PreviewSlot />
      </Suspense>
      <div className="mx-auto w-full max-w-6xl px-5 py-14 md:py-20">
        <p className="text-sm tracking-[0.14em] text-forest uppercase">Vermont</p>
        <h1 className="mt-4 max-w-3xl font-heading text-4xl leading-tight text-charcoal md:text-6xl">
          Welcome to Vermont.
          <span className="block">Make Yourself at Home.</span>
        </h1>
        <p className="mt-5 max-w-xl text-lg leading-8">
          Everything you need for a wonderful stay, all in one place.
        </p>
        <div className="mt-6 h-px w-16 bg-terracotta" aria-hidden="true" />
        <h2 id="where-staying" className="mt-14 font-heading text-3xl text-forest md:text-4xl">
          Where are you staying?
        </h2>
        <div className="mt-8">
          <Suspense fallback={<PropertyCardFallback />}>
            <PropertyList />
          </Suspense>
        </div>
        <section aria-labelledby="collection-heading" className="mt-20 border-t border-beige pt-12">
          <h2
            id="collection-heading"
            className="max-w-3xl font-heading text-3xl leading-tight text-charcoal md:text-4xl"
          >
            Three unique Vermont stays. One thoughtfully curated experience.
          </h2>
          <p className="mt-4 max-w-2xl text-lg leading-8">
            The Raddish Roost, The Shallot Chalet, and The Onion Ranch each have a guidebook for the
            stay itself: arrival, the house, and the places worth your time nearby.
          </p>
        </section>
      </div>
    </>
  );
}

async function PreviewSlot() {
  const result = await getPublishedProperties();
  if (!result.ok || result.source !== "preview") return null;
  return <PreviewBanner />;
}

async function PropertyList() {
  const result = await getPublishedProperties();
  if (!result.ok) {
    return (
      <p role="alert" className="rounded-xl bg-beige/70 px-5 py-8 text-base leading-7">
        The guidebook couldn&apos;t be loaded. Please try again in a moment.
      </p>
    );
  }
  return <PropertyCardGrid properties={result.data} />;
}
