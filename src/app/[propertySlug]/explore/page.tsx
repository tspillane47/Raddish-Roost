import { Suspense } from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { getPropertyGuide } from "@/lib/data/properties";

type ExploreParams = { params: Promise<{ propertySlug: string }> };

export async function generateMetadata({ params }: ExploreParams): Promise<Metadata> {
  const { propertySlug } = await params;
  const result = await getPropertyGuide(propertySlug);
  return {
    title: result.ok ? `Explore · ${result.property.name}` : "Explore",
    robots: { index: false, follow: false },
  };
}

export default function ExplorePage({ params }: ExploreParams) {
  return (
    <Suspense fallback={null}>
      <ExploreContent params={params} />
    </Suspense>
  );
}

async function ExploreContent({ params }: ExploreParams) {
  const { propertySlug } = await params;
  const result = await getPropertyGuide(propertySlug);
  if (!result.ok) {
    if (result.error === "not_found") notFound();
    return (
      <div className="mx-auto w-full max-w-3xl px-5 py-20">
        <h1 className="font-heading text-4xl text-forest">Explore couldn&apos;t be loaded</h1>
        <p role="alert" className="mt-4 text-lg leading-8">
          Please try again in a moment.
        </p>
      </div>
    );
  }

  return (
    <article className="mx-auto w-full max-w-3xl px-5 py-10">
      <p>
        <Link
          href={`/${result.property.slug}`}
          className="inline-flex min-h-11 items-center text-sm text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to {result.property.name}
        </Link>
      </p>
      <h1 className="mt-4 font-heading text-4xl text-charcoal md:text-5xl">Explore</h1>
      <p role="status" className="mt-6 text-lg leading-8">
        Local recommendations for {result.property.name} have not been added yet.
      </p>
    </article>
  );
}
