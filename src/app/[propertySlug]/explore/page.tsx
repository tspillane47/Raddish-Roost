import { Suspense } from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ThingsToDo } from "@/components/explore/things-to-do";
import { brandLogo } from "@/lib/content/brand-art";
import { getThingsToDo } from "@/lib/data/things-to-do";

type ExploreParams = { params: Promise<{ propertySlug: string }> };

export async function generateMetadata({ params }: ExploreParams): Promise<Metadata> {
  const { propertySlug } = await params;
  const result = await getThingsToDo(propertySlug);
  return {
    title: result.ok ? `Things to Do · ${result.propertyName}` : "Things to Do",
    robots: { index: false, follow: false },
  };
}

export default function ExplorePage({ params }: ExploreParams) {
  return (
    <Suspense fallback={<ThingsFallback />}>
      <ExploreContent params={params} />
    </Suspense>
  );
}

async function ExploreContent({ params }: ExploreParams) {
  const { propertySlug } = await params;
  const result = await getThingsToDo(propertySlug);
  if (!result.ok) {
    if (result.error === "not_found") notFound();
    return (
      <div className="mx-auto w-full max-w-3xl px-5 py-20">
        <h1 className="font-heading text-4xl text-forest">Things to Do couldn&apos;t be loaded</h1>
        <p role="alert" className="mt-4 text-lg leading-8">
          Please try again in a moment.
        </p>
      </div>
    );
  }

  return (
    <article className="mx-auto w-full max-w-3xl px-5 pt-8 pb-28 md:pb-16">
      <p>
        <Link
          href={`/${result.propertySlug}`}
          className="inline-flex min-h-11 items-center text-sm text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to {result.propertyName}
        </Link>
      </p>
      <h1 className="mt-4 font-heading text-4xl text-charcoal md:text-5xl">Things to Do</h1>
      <ThingsToDo places={result.places} accent={brandLogo(result.propertySlug)?.accent ?? "#263F35"} />
    </article>
  );
}

function ThingsFallback() {
  return (
    <div aria-busy="true" aria-live="polite" className="mx-auto w-full max-w-3xl px-5 py-10">
      <p className="sr-only">Loading things to do</p>
      <div className="h-8 w-40 rounded bg-beige" />
      <div className="mt-6 h-12 w-2/3 rounded bg-beige" />
      <div className="mt-6 flex gap-2">
        <div className="h-11 w-24 rounded-full bg-beige" />
        <div className="h-11 w-24 rounded-full bg-beige" />
      </div>
    </div>
  );
}
