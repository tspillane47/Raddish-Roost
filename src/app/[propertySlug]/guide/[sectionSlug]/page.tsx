import { Suspense } from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { PreviewBanner } from "@/components/layout/preview-banner";
import { SectionFallback, SectionView } from "@/components/guidebook/section-view";
import { getGuideSection } from "@/lib/data/properties";

type SectionParams = { params: Promise<{ propertySlug: string; sectionSlug: string }> };

export async function generateMetadata({ params }: SectionParams): Promise<Metadata> {
  const { propertySlug, sectionSlug } = await params;
  const result = await getGuideSection(propertySlug, sectionSlug);
  return {
    title: result.ok ? `${result.section.title} · ${result.section.propertyName}` : "Guide",
    robots: { index: false, follow: false },
  };
}

export default function GuideSectionPage({ params }: SectionParams) {
  return (
    <Suspense fallback={<SectionFallback />}>
      <SectionContent params={params} />
    </Suspense>
  );
}

async function SectionContent({ params }: SectionParams) {
  const { propertySlug, sectionSlug } = await params;
  const result = await getGuideSection(propertySlug, sectionSlug);

  if (!result.ok) {
    if (result.error === "not_found") notFound();
    return (
      <div className="mx-auto w-full max-w-3xl px-5 py-20">
        <h1 className="font-heading text-4xl text-forest">This section couldn&apos;t be loaded</h1>
        <p role="alert" className="mt-4 text-lg leading-8">
          Please try again in a moment.
        </p>
      </div>
    );
  }

  return (
    <>
      {result.source === "preview" ? <PreviewBanner /> : null}
      <SectionView section={result.section} />
    </>
  );
}
