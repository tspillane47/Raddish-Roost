import Image from "next/image";
import Link from "next/link";
import type { ReactNode } from "react";
import { PineIcon, ShellIcon } from "@/components/dad/region-icons";
import { PhotoPlaceholder } from "@/components/property/photo-placeholder";
import type { PropertySummary } from "@/types/content";
import type { SiteConfig } from "@/sites/types";

export function DadHome({
  site,
  properties,
}: {
  site: SiteConfig;
  properties: PropertySummary[];
}) {
  const vermont = properties.filter((property) => property.guestArea !== "florida");
  const sanibel = properties.filter((property) => property.guestArea === "florida");
  const badge = `${properties.length} Vacation Homes · ${vermont.length} in Vermont · ${sanibel.length} on Sanibel Island`;

  return (
    <>
      <section className="bg-forest px-5 pb-10 pt-12 text-center text-cream md:pb-14 md:pt-16">
        <p className="font-[family-name:var(--font-dad-italic)] text-xl italic md:text-2xl">The</p>
        <h1 className="mt-1 font-[family-name:var(--font-dad-display)] text-[clamp(2.4rem,8vw,5.5rem)] leading-[0.92] tracking-tight">
          Far <span className="text-terracotta">&amp;</span> Familiar
        </h1>
        <p className="mt-3 text-[0.78rem] font-semibold uppercase tracking-[0.42em] text-cream/90">
          Collection
        </p>
        <p className="mx-auto mt-5 max-w-xl font-[family-name:var(--font-dad-italic)] text-xl italic text-cream/95 md:text-2xl">
          {site.tagline}
        </p>
        <div className="mt-6 flex items-center justify-center gap-4 text-cream/90">
          <PineIcon className="size-5" />
          <span className="h-5 w-px bg-cream/40" aria-hidden="true" />
          <ShellIcon className="size-5 text-terracotta" />
        </div>
      </section>

      <div className="bg-charcoal">
        <Image
          src={site.hero.src}
          alt={site.hero.alt}
          width={site.hero.width}
          height={site.hero.height}
          preload
          fetchPriority="high"
          sizes="100vw"
          className="aspect-[2/1] w-full object-cover object-center md:aspect-[1774/443]"
        />
      </div>

      <div className="mx-auto -mt-5 w-fit max-w-[calc(100%-2.5rem)] rounded-full border border-beige bg-cream px-5 py-2.5 text-center shadow-sm">
        <p className="text-[0.7rem] font-semibold uppercase tracking-[0.14em] text-forest md:text-xs">
          {badge}
        </p>
      </div>

      <div id="our-stays" className="mx-auto w-full max-w-6xl scroll-mt-24 px-5 pb-20 pt-12 md:pt-16">
        <h2 className="font-[family-name:var(--font-dad-display)] text-4xl text-forest md:text-5xl">
          {site.collectionHeading}
        </h2>
        <p className="mt-3 max-w-2xl font-[family-name:var(--font-dad-italic)] text-lg italic text-muted-foreground">
          {site.collectionBody}
        </p>

        <StayGroup
          id="vermont"
          title="Vermont"
          icon={<PineIcon className="size-5 text-forest" />}
          properties={vermont}
        />
        <StayGroup
          id="sanibel"
          title="Sanibel Island"
          icon={<ShellIcon className="size-5 text-terracotta" />}
          properties={sanibel}
        />
      </div>
    </>
  );
}

function StayGroup({
  id,
  title,
  icon,
  properties,
}: {
  id: string;
  title: string;
  icon: ReactNode;
  properties: PropertySummary[];
}) {
  return (
    <section id={id} aria-labelledby={`${id}-heading`} className="mt-14 scroll-mt-24">
      <div className="mb-6 flex items-center gap-3">
        {icon}
        <h3 id={`${id}-heading`} className="text-sm font-semibold uppercase tracking-[0.22em] text-forest">
          {title}
        </h3>
      </div>
      {properties.length === 0 ? (
        <p className="rounded-xl bg-beige/60 px-5 py-8 text-base leading-7">Homes coming soon.</p>
      ) : (
        <ul className="grid list-none gap-8 p-0 sm:grid-cols-2 lg:grid-cols-3">
          {properties.map((property) => (
            <li key={property.slug}>
              <DadStayCard property={property} />
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

function DadStayCard({ property }: { property: PropertySummary }) {
  const florida = property.guestArea === "florida";
  const town = property.locality?.trim() || (florida ? "Sanibel Island" : "Vermont");

  return (
    <article className="group flex h-full flex-col overflow-hidden rounded-xl border border-beige bg-card">
      <Link
        href={`/${property.slug}`}
        className="block overflow-hidden bg-beige focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-forest"
      >
        {property.heroImageUrl ? (
          <Image
            src={property.heroImageUrl}
            alt={property.heroImageAlt}
            width={1200}
            height={900}
            className="aspect-[4/3] w-full object-cover motion-safe:transition-transform motion-safe:duration-300 motion-safe:group-hover:scale-[1.03]"
            sizes="(max-width: 768px) calc(100vw - 2.5rem), 22rem"
          />
        ) : (
          <PhotoPlaceholder name={property.name} tone="forest" />
        )}
      </Link>
      <div className="flex flex-1 flex-col gap-3 p-5">
        <h4 className="font-[family-name:var(--font-dad-display)] text-2xl leading-tight text-forest">
          <Link href={`/${property.slug}`} className="focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest">
            {property.name}
          </Link>
        </h4>
        <p className="flex items-center gap-2 font-[family-name:var(--font-dad-italic)] text-base italic text-muted-foreground">
          {florida ? <ShellIcon className="size-4 text-terracotta" /> : <PineIcon className="size-4 text-forest" />}
          <span>{town}</span>
        </p>
        <Link
          href={`/${property.slug}`}
          className="mt-auto inline-flex min-h-11 items-center gap-2 text-sm font-semibold uppercase tracking-[0.16em] text-terracotta focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          aria-label={`Open guidebook for ${property.name}`}
        >
          Guidebook
          <span aria-hidden="true">→</span>
        </Link>
      </div>
    </article>
  );
}
