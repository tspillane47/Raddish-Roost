import { Suspense } from "react";
import { PropertyDock } from "@/components/property/property-dock";
import { PropertyTools } from "@/components/property/property-tools";
import { getPropertyGuide } from "@/lib/data/properties";
import { propertySlugSchema } from "@/lib/validation/slug";

export default function PropertyLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ propertySlug: string }>;
}) {
  return (
    <Suspense fallback={children}>
      <PropertyFrame params={params}>{children}</PropertyFrame>
    </Suspense>
  );
}

async function PropertyFrame({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ propertySlug: string }>;
}) {
  const { propertySlug } = await params;
  if (!propertySlugSchema.safeParse(propertySlug).success) return children;

  const result = await getPropertyGuide(propertySlug);
  if (!result.ok && result.error === "not_found") return children;

  const slug = result.ok ? result.property.slug : propertySlug;
  return (
    <>
      <PropertyTools slug={slug} />
      {children}
      <PropertyDock slug={slug} />
    </>
  );
}
