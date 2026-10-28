import { Suspense } from "react";
import { notFound } from "next/navigation";
import { PreviewBanner } from "@/components/layout/preview-banner";
import { PropertyHome, PropertyHomeFallback } from "@/components/property/property-home";
import { getPropertyGuide } from "@/lib/data/properties";

export default function PropertyPage({ params }: { params: Promise<{ propertySlug: string }> }) {
  return (
    <Suspense fallback={<PropertyHomeFallback />}>
      <PropertyContent params={params} />
    </Suspense>
  );
}

async function PropertyContent({ params }: { params: Promise<{ propertySlug: string }> }) {
  const { propertySlug } = await params;
  const result = await getPropertyGuide(propertySlug);

  if (!result.ok) {
    if (result.error === "not_found") notFound();
    return (
      <div className="mx-auto w-full max-w-3xl px-5 py-20">
        <h1 className="font-heading text-4xl text-forest">This stay couldn&apos;t be loaded</h1>
        <p role="alert" className="mt-4 text-lg leading-8">
          Please try again in a moment.
        </p>
      </div>
    );
  }

  return (
    <>
      {result.source === "preview" ? <PreviewBanner /> : null}
      <PropertyHome property={result.property} />
    </>
  );
}

