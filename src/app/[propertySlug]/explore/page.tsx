import { Suspense } from "react";
import type { Metadata } from "next";
import { redirect } from "next/navigation";

type ExploreParams = { params: Promise<{ propertySlug: string }> };

export async function generateMetadata(): Promise<Metadata> {
  return {
    title: "Things to Do",
    robots: { index: false, follow: false },
  };
}

export default function ExplorePage({ params }: ExploreParams) {
  return (
    <Suspense fallback={null}>
      <ExploreRedirect params={params} />
    </Suspense>
  );
}

async function ExploreRedirect({ params }: ExploreParams) {
  const { propertySlug } = await params;
  redirect(`/${propertySlug}/guide/things-to-do`);
  return null;
}
