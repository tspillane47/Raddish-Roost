import Image from "next/image";
import Link from "next/link";
import { PhotoPlaceholder } from "@/components/property/photo-placeholder";
import { buttonVariants } from "@/components/ui/button";
import { placeholderTone } from "@/lib/content/sections";
import { isMarkedSample } from "@/lib/data/map-content";
import { cn } from "@/lib/utils";
import type { PropertySummary } from "@/types/content";

export function PropertyCard({ property }: { property: PropertySummary }) {
  const sample = isMarkedSample(property.tagline) || isMarkedSample(property.description);

  return (
    <article className="flex h-full flex-col overflow-hidden rounded-xl border border-beige bg-card">
      <div className="relative">
        {property.heroImageUrl ? (
          <Image
            src={property.heroImageUrl}
            alt={property.heroImageAlt}
            width={1200}
            height={900}
            className="aspect-[4/3] w-full object-cover"
            sizes="(max-width: 768px) 100vw, 33vw"
          />
        ) : (
          <PhotoPlaceholder name={property.name} tone={placeholderTone(property.slug)} />
        )}
      </div>
      <div className="flex flex-1 flex-col gap-4 p-6">
        <div className="flex items-start justify-between gap-3">
          <h3 className="font-heading text-3xl leading-tight text-forest">{property.name}</h3>
          {sample ? (
            <span className="mt-1 shrink-0 rounded-full border border-forest px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
              Sample
            </span>
          ) : null}
        </div>
        {property.tagline ? <p className="text-base leading-7">{property.tagline}</p> : null}
        <Link
          href={`/${property.slug}`}
          className={cn(buttonVariants({ size: "guest" }), "mt-auto w-full")}
        >
          Explore Your Stay
        </Link>
      </div>
    </article>
  );
}

export function PropertyCardGrid({ properties }: { properties: PropertySummary[] }) {
  if (properties.length === 0) {
    return (
      <p role="status" className="rounded-xl bg-beige/70 px-5 py-8 text-base leading-7">
        The guidebook has no published homes yet.
      </p>
    );
  }

  return (
    <ul className="grid list-none gap-10 p-0 md:grid-cols-3">
      {properties.map((property) => (
        <li key={property.slug}>
          <PropertyCard property={property} />
        </li>
      ))}
    </ul>
  );
}

export function PropertyCardFallback() {
  return (
    <div aria-busy="true" aria-live="polite">
      <p className="sr-only">Loading properties</p>
      <div className="grid gap-10 md:grid-cols-3">
        {["one", "two", "three"].map((key) => (
          <div key={key} className="h-[28rem] rounded-xl bg-beige/80" />
        ))}
      </div>
    </div>
  );
}
