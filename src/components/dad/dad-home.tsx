import Image from "next/image";
import Link from "next/link";
import type { ReactNode } from "react";
import { PineIcon, ShellIcon } from "@/components/dad/region-icons";
import { PhotoPlaceholder } from "@/components/property/photo-placeholder";
import { getPropertyPhotos, photoObjectPosition } from "@/lib/content/property-photos";
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
  const badge = `${properties.length} Vacation Homes · ${vermont.length} Vermont · ${sanibel.length} Sanibel`;

  return (
    <>
      <section className="relative z-10 bg-forest px-5 pb-10 pt-10 text-center text-cream md:pb-12 md:pt-14">
        <div className="mx-auto w-full max-w-3xl">
          <p className="font-[family-name:var(--font-dad-italic)] text-lg italic tracking-[0.08em] text-cream/85 md:text-xl">
            Welcome to
          </p>
          <h1 className="mt-2 font-[family-name:var(--font-dad-display)] text-[clamp(2.4rem,8vw,5.25rem)] leading-[0.95] tracking-tight uppercase">
            The Getaway <span className="text-terracotta">Club</span>
          </h1>
          <div
            className="mx-auto mt-5 h-1.5 w-24 rounded-sm bg-mustard"
            aria-hidden="true"
          />
          <p className="mx-auto mt-5 max-w-xl font-[family-name:var(--font-dad-italic)] text-xl italic text-cream/95 md:text-2xl">
            {site.tagline}
          </p>
          <div className="mt-6 flex items-center justify-center gap-4 text-cream/90">
            <PineIcon className="size-5 shrink-0" />
            <span className="h-5 w-px bg-cream/40" aria-hidden="true" />
            <ShellIcon className="size-5 shrink-0 text-terracotta" />
          </div>
        </div>
      </section>

      <div className="relative z-0 bg-charcoal">
        <Image
          src={site.hero.src}
          alt={site.hero.alt}
          width={site.hero.width}
          height={site.hero.height}
          preload
          fetchPriority="high"
          sizes="100vw"
          className="block h-auto w-full"
        />
      </div>

      <div className="mx-auto w-full max-w-6xl px-5 pt-6 md:pt-8">
        <p className="mx-auto w-fit max-w-full rounded-full border border-beige bg-cream px-4 py-2.5 text-center text-[0.65rem] font-semibold uppercase leading-snug tracking-[0.1em] text-forest shadow-sm whitespace-normal sm:px-5 sm:text-[0.7rem] sm:tracking-[0.12em] md:text-xs">
          {badge}
        </p>
      </div>

      <div id="our-stays" className="mx-auto w-full max-w-6xl scroll-mt-24 px-5 pb-20 pt-10 md:pt-14">
        <h2 className="font-[family-name:var(--font-dad-display)] text-3xl text-forest sm:text-4xl md:text-5xl">
          {site.collectionHeading}
        </h2>
        <p className="mt-3 max-w-2xl font-[family-name:var(--font-dad-italic)] text-base italic leading-7 text-muted-foreground sm:text-lg">
          {site.collectionBody}
        </p>

        <StayGroup
          id="vermont"
          title="Vermont"
          icon={<PineIcon className="size-5 shrink-0 text-forest" />}
          properties={vermont}
        />
        <StayGroup
          id="sanibel"
          title="Sanibel Island"
          icon={<ShellIcon className="size-5 shrink-0 text-terracotta" />}
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
        <ul className="grid list-none gap-6 p-0 sm:grid-cols-2 sm:gap-8 lg:grid-cols-3 xl:grid-cols-4">
          {properties.map((property) => (
            <li key={property.slug} className="min-w-0">
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
  const gallery = getPropertyPhotos(property.slug);
  const cardPhoto = gallery.cardPhoto ?? gallery.heroPhotos[1] ?? gallery.heroPhotos[0] ?? null;
  const cardImage = cardPhoto
    ? { src: cardPhoto.src, alt: cardPhoto.alt, width: cardPhoto.width, height: cardPhoto.height, focus: cardPhoto.focus }
    : property.heroImageUrl
      ? { src: property.heroImageUrl, alt: property.heroImageAlt, width: 1200, height: 900, focus: "center" as const }
      : null;

  return (
    <article className="group flex h-full min-w-0 flex-col overflow-hidden rounded-xl border border-beige bg-card">
      <Link
        href={`/${property.slug}`}
        className="block overflow-hidden bg-beige focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-forest"
      >
        {cardImage ? (
          <Image
            src={cardImage.src}
            alt={cardImage.alt}
            width={cardImage.width}
            height={cardImage.height}
            className="aspect-[4/3] w-full object-cover motion-safe:transition-transform motion-safe:duration-300 motion-safe:group-hover:scale-[1.03]"
            style={{ objectPosition: photoObjectPosition(cardImage.focus) }}
            sizes="(max-width: 640px) calc(100vw - 2.5rem), (max-width: 1280px) 45vw, 22rem"
          />
        ) : (
          <PhotoPlaceholder name={property.name} tone="forest" />
        )}
      </Link>
      <div className="flex min-w-0 flex-1 flex-col gap-3 p-5">
        <h4 className="font-[family-name:var(--font-dad-display)] text-xl leading-snug break-words text-forest sm:text-2xl">
          <Link
            href={`/${property.slug}`}
            className="focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            {property.name}
          </Link>
        </h4>
        <p className="flex min-w-0 items-center gap-2 font-[family-name:var(--font-dad-italic)] text-base italic text-muted-foreground">
          {florida ? <ShellIcon className="size-4 shrink-0 text-terracotta" /> : <PineIcon className="size-4 shrink-0 text-forest" />}
          <span className="min-w-0 break-words">{town}</span>
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
