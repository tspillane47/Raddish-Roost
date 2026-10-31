import { Suspense } from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { PreviewBanner } from "@/components/layout/preview-banner";
import { PropertyHome, PropertyHomeFallback } from "@/components/property/property-home";
import type { PropertyGuide } from "@/types/content";
import { weatherPreviewScene, withWeatherPreview, type WeatherSnapshot } from "@/lib/content/weather";
import { getPropertyGuide } from "@/lib/data/properties";
import { getStayWeather } from "@/lib/weather/forecast";

type PropertyParams = {
  params: Promise<{ propertySlug: string }>;
  searchParams: Promise<{ weather?: string | string[] }>;
};

export async function generateMetadata({ params }: PropertyParams): Promise<Metadata> {
  const { propertySlug } = await params;
  const result = await getPropertyGuide(propertySlug);
  return {
    title: result.ok ? result.property.name : "Stay",
    robots: { index: false, follow: false },
  };
}

export default function PropertyPage({ params, searchParams }: PropertyParams) {
  return (
    <Suspense fallback={<PropertyHomeFallback />}>
      <PropertyContent params={params} searchParams={searchParams} />
    </Suspense>
  );
}

async function PropertyContent({
  params,
  searchParams,
}: PropertyParams) {
  const { propertySlug } = await params;
  const preview =
    process.env.NODE_ENV === "development" ? weatherPreviewScene((await searchParams).weather) : null;
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

  const weather = withWeatherPreview(await loadWeather(result.property), preview);

  return (
    <>
      {result.source === "preview" ? <PreviewBanner /> : null}
      <PropertyHome property={result.property} weather={weather} />
    </>
  );
}

async function loadWeather(property: PropertyGuide): Promise<WeatherSnapshot | null> {
  const latitude = property.weatherLatitude;
  const longitude = property.weatherLongitude;
  if (latitude === null || longitude === null) return null;
  try {
    return await getStayWeather(latitude, longitude);
  } catch (error) {
    console.error("[guidebook] weather:", error instanceof Error ? error.message : "unavailable");
    return null;
  }
}

