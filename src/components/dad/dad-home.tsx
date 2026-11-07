import Image from "next/image";
import Link from "next/link";
import type { ReactNode } from "react";
import { DuffelBagIcon, KeyholeIcon } from "@/components/dad/heist-icons";
import { PineIcon, ShellIcon } from "@/components/dad/region-icons";
import { PhotoPlaceholder } from "@/components/property/photo-placeholder";
import { isPetFriendlyStay } from "@/lib/content/stay-glance";
import { getPropertyPhotos, photoObjectPosition } from "@/lib/content/property-photos";
import { Tx } from "@/lib/i18n/locale-context";
import type { PropertySummary } from "@/types/content";
import { DAD_GETAWAY_HERO_FOCUS } from "@/sites/dad-hero";
import { resolveDadHero } from "@/sites/resolve-dad-hero";
import type { ComingSoonStay, SiteConfig } from "@/sites/types";

export function DadHome({
  site,
  properties,
}: {
  site: SiteConfig;
  properties: PropertySummary[];
}) {
  const vermont = properties.filter((property) => property.guestArea !== "florida");
  const sanibel = properties.filter((property) => property.guestArea === "florida");
  const badge = `${properties.length} Hideouts · Vermont · Sanibel`;
  const staysLabel = site.labels?.en?.ourStays;
  const hero = resolveDadHero(site.hero);
  const usingGetawayArt = hero.src.includes("hero-getaway");

  return (
    <>
      {/* Real type sits above the artwork. The getaway art has no baked-in title. */}
      <section className="relative z-10 bg-forest px-5 pb-10 pt-10 text-center text-cream md:pb-12 md:pt-14">
        <div className="mx-auto w-full max-w-3xl">
          <p className="font-[family-name:var(--font-dad-typewriter)] text-xs uppercase tracking-[0.28em] text-cream/80 md:text-sm">
            Welcome to
          </p>
          <h1 className="mt-3 font-[family-name:var(--font-dad-display)] text-[clamp(2.4rem,8vw,5.25rem)] leading-[0.95] tracking-tight uppercase">
            The Getaway <span className="text-mustard">Club</span>
          </h1>
          <div className="mx-auto mt-5 h-1.5 w-24 rounded-sm bg-terracotta" aria-hidden="true" />
          <p className="mx-auto mt-5 max-w-xl font-[family-name:var(--font-dad-typewriter)] text-lg leading-8 text-cream/95 md:text-xl">
            {site.tagline}
          </p>
          <div className="mt-6 flex items-center justify-center gap-4 text-cream/90">
            <KeyholeIcon className="size-5 shrink-0" />
            <span className="h-5 w-px bg-cream/40" aria-hidden="true" />
            <PineIcon className="size-5 shrink-0" />
            <span className="h-5 w-px bg-cream/40" aria-hidden="true" />
            <ShellIcon className="size-5 shrink-0 text-sage" />
          </div>
        </div>
      </section>

      <div className="relative z-0 w-full overflow-hidden bg-charcoal">
        <Image
          src={hero.src}
          alt={hero.alt}
          width={hero.width}
          height={hero.height}
          preload
          fetchPriority="high"
          sizes="100vw"
          className="block h-auto w-full object-cover object-center"
          style={usingGetawayArt ? { objectPosition: DAD_GETAWAY_HERO_FOCUS } : undefined}
        />
      </div>

      <div className="mx-auto w-full max-w-6xl px-5 pt-6 md:pt-8">
        <p className="mx-auto w-fit max-w-full border border-dashed border-terracotta/70 bg-beige/80 px-4 py-2.5 text-center font-[family-name:var(--font-dad-typewriter)] text-[0.7rem] uppercase leading-snug tracking-[0.14em] text-forest shadow-sm sm:px-5 sm:text-xs">
          {badge}
        </p>
      </div>

      <div id="our-stays" className="mx-auto w-full max-w-6xl scroll-mt-24 px-5 pb-20 pt-10 md:pt-14">
        <div className="flex items-start gap-3">
          <DuffelBagIcon className="mt-1 size-7 shrink-0 text-forest" />
          <div>
            <h2 className="font-[family-name:var(--font-dad-display)] text-3xl text-forest sm:text-4xl md:text-5xl">
              {staysLabel?.themed ?? site.collectionHeading}
            </h2>
            {staysLabel ? (
              <p className="mt-1 font-[family-name:var(--font-dad-typewriter)] text-sm tracking-wide text-muted-foreground">
                {staysLabel.plain}
              </p>
            ) : null}
            <p className="mt-3 max-w-2xl text-base leading-7 text-muted-foreground sm:text-lg">
              {site.collectionBody}
            </p>
          </div>
        </div>

        <StayGroup
          id="vermont"
          title="Vermont"
          icon={<PineIcon className="size-5 shrink-0 text-forest" />}
          properties={vermont}
          comingSoon={site.comingSoon ?? []}
        />
        <StayGroup
          id="sanibel"
          title="Sanibel Island"
          icon={<ShellIcon className="size-5 shrink-0 text-sage" />}
          properties={sanibel}
          beach
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
  beach = false,
  comingSoon = [],
}: {
  id: string;
  title: string;
  icon: ReactNode;
  properties: PropertySummary[];
  beach?: boolean;
  comingSoon?: ComingSoonStay[];
}) {
  const empty = properties.length === 0 && comingSoon.length === 0;

  return (
    <section id={id} aria-labelledby={`${id}-heading`} className="mt-14 scroll-mt-24">
      <div className="mb-6 flex items-center gap-3">
        {icon}
        <h3
          id={`${id}-heading`}
          className="font-[family-name:var(--font-dad-typewriter)] text-sm font-semibold uppercase tracking-[0.22em] text-forest"
        >
          {title}
        </h3>
      </div>
      {empty ? (
        <p className="rounded-sm bg-beige/60 px-5 py-8 text-base leading-7">Hideouts coming soon.</p>
      ) : (
        <>
          <ul className="grid list-none gap-6 p-0 sm:grid-cols-2 sm:gap-8 lg:grid-cols-3 xl:grid-cols-4">
            {properties.map((property) => (
              <li key={property.slug} className="min-w-0">
                <DadStayCard property={property} beach={beach} />
              </li>
            ))}
            {comingSoon.map((stay) => (
              <li key={stay.id} className="min-w-0">
                <DadComingSoonCard stay={stay} />
              </li>
            ))}
          </ul>
          {comingSoon.length > 0 ? (
            <p className="mt-5 font-[family-name:var(--font-dad-typewriter)] text-sm tracking-wide text-muted-foreground">
              <Tx k="comingSoonWaterburyNote" />
            </p>
          ) : null}
        </>
      )}
    </section>
  );
}

function DadStayCard({ property, beach }: { property: PropertySummary; beach: boolean }) {
  const florida = property.guestArea === "florida" || beach;
  const town = property.locality?.trim() || (florida ? "Sanibel Island" : "Vermont");
  const gallery = getPropertyPhotos(property.slug);
  const cardPhoto = gallery.cardPhoto ?? gallery.heroPhotos[1] ?? gallery.heroPhotos[0] ?? null;
  const cardImage = cardPhoto
    ? { src: cardPhoto.src, alt: cardPhoto.alt, width: cardPhoto.width, height: cardPhoto.height, focus: cardPhoto.focus }
    : property.heroImageUrl
      ? { src: property.heroImageUrl, alt: property.heroImageAlt, width: 1200, height: 900, focus: "center" as const }
      : null;
  const stamp = florida ? "BEACH HIDEOUT" : "HIDEOUT";

  return (
    <article className="group relative flex h-full min-w-0 flex-col rounded-sm border border-beige bg-beige shadow-[2px_3px_0_rgba(26,26,26,0.08)]">
      <div className="pointer-events-none absolute top-4 right-2 z-10 rotate-[-8deg] border-2 border-terracotta bg-cream/95 px-2 py-1 font-[family-name:var(--font-dad-typewriter)] text-[0.65rem] font-bold tracking-[0.12em] text-terracotta shadow-sm motion-reduce:rotate-0">
        {stamp}
      </div>
      <Link
        href={`/${property.slug}`}
        className="relative m-3 mb-0 block overflow-hidden rounded-sm bg-cream shadow-[1px_2px_0_rgba(26,26,26,0.12)] focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-forest"
      >
        <span
          className="pointer-events-none absolute -top-1 left-1/2 z-10 size-3 -translate-x-1/2 rounded-full bg-charcoal/70 shadow-sm"
          aria-hidden="true"
        />
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
      <div className="flex min-w-0 flex-1 flex-col gap-2 p-4 pt-3">
        <h4 className="font-[family-name:var(--font-dad-display)] text-xl leading-snug break-words text-forest sm:text-2xl">
          <Link
            href={`/${property.slug}`}
            className="focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            {property.name}
          </Link>
        </h4>
        <p className="font-[family-name:var(--font-dad-typewriter)] text-sm tracking-wide text-muted-foreground">
          {town}
        </p>
        {isPetFriendlyStay(property.slug) ? (
          <p className="w-fit border border-forest/30 bg-cream px-2 py-0.5 font-[family-name:var(--font-dad-typewriter)] text-[0.65rem] font-semibold uppercase tracking-[0.14em] text-forest">
            <Tx k="petFriendly" />
          </p>
        ) : null}
        <Link
          href={`/${property.slug}`}
          className="mt-auto inline-flex min-h-11 items-center gap-2 font-[family-name:var(--font-dad-typewriter)] text-sm font-semibold uppercase tracking-[0.12em] text-terracotta focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          aria-label={`Open guidebook for ${property.name}`}
        >
          Open file
          <span aria-hidden="true">→</span>
        </Link>
      </div>
    </article>
  );
}

function DadComingSoonCard({ stay }: { stay: ComingSoonStay }) {
  return (
    <article className="relative flex h-full min-w-0 flex-col rounded-sm border border-beige bg-beige shadow-[2px_3px_0_rgba(26,26,26,0.08)]">
      <div
        aria-hidden="true"
        className="pointer-events-none absolute top-4 right-2 z-10 rotate-[-8deg] border-2 border-terracotta bg-cream/95 px-2 py-1 font-[family-name:var(--font-dad-typewriter)] text-[0.65rem] font-bold tracking-[0.12em] text-terracotta shadow-sm motion-reduce:rotate-0"
      >
        <Tx k="comingSoonStamp" />
      </div>
      <div className="relative m-3 mb-0 overflow-hidden rounded-sm bg-cream shadow-[1px_2px_0_rgba(26,26,26,0.12)]">
        <span
          className="pointer-events-none absolute -top-1 left-1/2 z-10 size-3 -translate-x-1/2 rounded-full bg-charcoal/70 shadow-sm"
          aria-hidden="true"
        />
        {stay.photoSrc ? (
          <Image
            src={stay.photoSrc}
            alt=""
            width={1200}
            height={900}
            className="aspect-[4/3] w-full object-cover"
            sizes="(max-width: 640px) calc(100vw - 2.5rem), (max-width: 1280px) 45vw, 22rem"
          />
        ) : (
          <ComingSoonPlaceholder kind={stay.placeholder} />
        )}
      </div>
      <div className="flex min-w-0 flex-1 flex-col gap-2 p-4 pt-3">
        <h4 className="font-[family-name:var(--font-dad-display)] text-xl leading-snug break-words text-forest sm:text-2xl">
          {stay.name}
        </h4>
        <p className="font-[family-name:var(--font-dad-typewriter)] text-sm tracking-wide text-muted-foreground">
          {stay.locality}
        </p>
        <p className="font-[family-name:var(--font-dad-typewriter)] text-sm font-semibold tracking-wide text-terracotta">
          <Tx k="openingYear" />
        </p>
      </div>
    </article>
  );
}

/** Manila photo slot with a light silhouette. Swap in photoSrc on the stay when ready. */
function ComingSoonPlaceholder({ kind }: { kind: ComingSoonStay["placeholder"] }) {
  return (
    <div
      className="relative flex aspect-[4/3] items-end justify-center overflow-hidden bg-[#E6D7B8]"
      aria-hidden="true"
    >
      <div
        className="absolute inset-0 opacity-40"
        style={{
          backgroundImage:
            "radial-gradient(circle at 20% 15%, rgba(232,220,200,0.9), transparent 42%), radial-gradient(circle at 80% 20%, rgba(212,196,168,0.85), transparent 45%)",
        }}
      />
      {kind === "cabin" ? <CabinSilhouette /> : <MountainSilhouette />}
    </div>
  );
}

function MountainSilhouette() {
  return (
    <svg
      viewBox="0 0 320 180"
      className="relative mb-3 h-[58%] w-[88%] text-forest/35"
      fill="currentColor"
      role="presentation"
    >
      <path d="M28 156 L108 54 L148 102 L188 70 L292 156 Z" />
      <path className="text-sage/45" fill="currentColor" d="M70 156 L148 78 L210 128 L248 104 L300 156 Z" />
      <rect x="0" y="156" width="320" height="24" className="text-beige/80" fill="currentColor" />
    </svg>
  );
}

function CabinSilhouette() {
  return (
    <svg
      viewBox="0 0 320 180"
      className="relative mb-2 h-[62%] w-[78%] text-forest/40"
      fill="currentColor"
      role="presentation"
    >
      <path d="M70 118 L160 48 L250 118 Z" />
      <rect x="92" y="118" width="136" height="52" />
      <rect x="146" y="132" width="28" height="38" className="text-cream/70" fill="currentColor" />
      <rect x="112" y="132" width="22" height="18" className="text-cream/55" fill="currentColor" />
      <rect x="186" y="132" width="22" height="18" className="text-cream/55" fill="currentColor" />
      <rect x="0" y="168" width="320" height="12" className="text-beige/80" fill="currentColor" />
    </svg>
  );
}
