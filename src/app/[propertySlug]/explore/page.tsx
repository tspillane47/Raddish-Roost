import { Suspense } from "react";
import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getSiteConfig } from "@/sites";
import { withSiteUrl } from "@/sites/site-url";

type ExploreParams = { params: Promise<{ propertySlug: string }> };

export async function generateMetadata({ params }: ExploreParams): Promise<Metadata> {
  const { propertySlug } = await params;
  return withSiteUrl(getSiteConfig(), `/${propertySlug}/guide/things-to-do`, {
    title: "Things to Do",
    robots: { index: false, follow: false },
  });
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
