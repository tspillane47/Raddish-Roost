import Image from "next/image";
import Link from "next/link";
import { getPropertyPhotos } from "@/lib/content/property-photos";
import { Tx } from "@/lib/i18n/locale-context";
import { errinHeroFileExists } from "@/sites/resolve-errin-hero";
import type { SiteConfig } from "@/sites/types";
import type { PropertySummary } from "@/types/content";

export function ErrinHome({
  site,
  properties,
}: {
  site: SiteConfig;
  properties: PropertySummary[];
}) {
  const hasHero = errinHeroFileExists(site.hero);

  return (
    <div className="bg-[var(--cream)] text-[var(--charcoal)]">
      <section className="relative w-full overflow-hidden">
        {hasHero ? (
          <div
            className="relative mx-auto w-[var(--errin-hero-phone)] md:w-[var(--errin-hero-width)]"
            style={{
              ["--errin-hero-phone" as string]: `min(100%, calc(40svh * ${site.hero.width} / ${site.hero.height}))`,
              ["--errin-hero-width" as string]: `min(100%, 1800px, calc(85svh * ${site.hero.width} / ${site.hero.height}))`,
            }}
          >
            <Image
              src={site.hero.src}
              alt={site.hero.alt}
              width={site.hero.width}
              height={site.hero.height}
              preload
              fetchPriority="high"
              sizes="(max-width: 767px) 100vw, min(100vw, 1800px)"
              // Under md the frame follows the photo, capped at 40svh, so the house stays whole.
              // md+ keeps the wide frame with the title in the open sky.
              style={{ aspectRatio: `${site.hero.width} / ${site.hero.height}` }}
              className="block h-auto w-full max-h-[40svh] object-contain object-center md:max-h-[85svh]"
            />
            <div
              className="pointer-events-none absolute inset-x-0 top-0 hidden h-[42%] bg-[linear-gradient(180deg,rgb(250_249_246_/_0.55)_0%,rgb(250_249_246_/_0.18)_55%,transparent_100%)] md:block"
              aria-hidden="true"
            />
            <div className="px-5 pt-3 pb-1 text-center md:pointer-events-none md:absolute md:top-[8%] md:right-[7%] md:left-[48%] md:z-10 md:px-0 md:pt-0 md:pb-0">
              <h1 className="font-[family-name:var(--font-errin-display,var(--font-display))] text-[1.65rem] leading-[0.95] tracking-tight text-[var(--charcoal)] md:text-[clamp(1.35rem,4vw,2.35rem)]">
                {site.name}
              </h1>
              <p className="mt-1 text-[0.62rem] font-medium uppercase tracking-[0.14em] text-[var(--muted-foreground)] md:text-[0.68rem] md:tracking-[0.2em]">
                <Tx k="errinHeroPlaces" />
              </p>
            </div>
          </div>
        ) : (
          <div className="flex w-full items-center justify-center bg-[var(--beige)] px-5 py-8 md:h-[min(62svh,34rem)] md:items-start md:pt-14">
            <div className="w-full max-w-3xl text-center">
              <h1 className="font-[family-name:var(--font-errin-display,var(--font-display))] text-[clamp(2.75rem,8vw,5.5rem)] leading-[0.95] tracking-tight text-[var(--charcoal)]">
                {site.name}
              </h1>
              <p className="mt-3 text-[0.7rem] font-medium uppercase tracking-[0.28em] text-[var(--muted-foreground)]">
                <Tx k="errinHeroPlaces" />
              </p>
            </div>
          </div>
        )}
      </section>

      <section
        id="where-staying"
        aria-labelledby="where-staying-heading"
        className="mx-auto w-full max-w-6xl scroll-mt-24 px-5 pt-4 pb-2 md:pt-5 md:pb-4"
      >
        <p className="hidden text-[0.7rem] font-medium uppercase tracking-[0.28em] text-[var(--muted-foreground)] md:block">
          <Tx k="staysLabel" />
        </p>
        <h2
          id="where-staying-heading"
          className="font-[family-name:var(--font-errin-display,var(--font-display))] text-[2.15rem] leading-[0.95] tracking-tight text-[var(--charcoal)] md:mt-2 md:text-4xl"
        >
          {site.collectionHeading}
        </h2>
        <p className="mt-2 text-sm leading-5 text-[var(--muted-foreground)] md:mt-2 md:max-w-2xl md:text-base md:leading-7">
          <span className="md:hidden">
            <Tx k="errinTapGuide" />
          </span>
          <span className="hidden md:inline">{site.collectionBody}</span>
        </p>

        {properties.length === 0 ? (
          <p role="status" className="mt-6 border border-[var(--beige)] px-5 py-8 text-base leading-7 md:mt-10">
            {site.comingSoonBody}
          </p>
        ) : (
          <ul className="mt-3 grid list-none gap-2 p-0 md:mt-5 md:grid-cols-3 md:gap-8">
            {properties.map((property) => (
              <li key={property.slug} className="min-w-0">
                <ErrinStayCard property={property} />
              </li>
            ))}
          </ul>
        )}
      </section>

      <div className="mx-auto w-full max-w-6xl px-5 pt-5 pb-16 md:pt-8 md:pb-28">
        <div className="h-px w-full bg-[var(--beige)]" aria-hidden="true" />
        <p className="mt-6 max-w-2xl text-base leading-7 text-[var(--muted-foreground)] md:text-lg">
          {site.tagline}
        </p>
        <p className="mt-3 text-sm leading-6 tracking-wide text-[var(--muted-foreground)]">
          <Tx k="errinHostedBy" />
        </p>
      </div>
    </div>
  );
}

function ErrinStayCard({ property }: { property: PropertySummary }) {
  const gallery = getPropertyPhotos(property.slug);
  const photo = gallery.cardPhoto ?? gallery.heroPhotos[0] ?? null;
  const town = property.locality?.trim() || "Vermont";

  return (
    <article className="group min-w-0">
      <Link
        href={`/${property.slug}`}
        className="flex min-h-16 items-center gap-3 border border-[var(--beige)] bg-[var(--cream)] px-2 py-2 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--forest)] md:h-full md:flex-col md:items-stretch md:gap-0 md:border-0 md:bg-transparent md:p-0"
      >
        {photo ? (
          <span className="relative size-14 shrink-0 overflow-hidden bg-[var(--beige)] md:aspect-[4/3] md:size-auto md:w-full">
            <Image
              src={photo.src}
              alt=""
              fill
              sizes="(max-width: 767px) 56px, 22rem"
              className="object-cover motion-safe:md:transition-transform motion-safe:md:duration-500 motion-safe:md:group-hover:scale-[1.02]"
            />
          </span>
        ) : (
          <>
            <span
              className="flex size-14 shrink-0 items-center justify-center bg-[var(--beige)] font-[family-name:var(--font-errin-display,var(--font-display))] text-lg text-[var(--charcoal)] md:hidden"
              aria-hidden="true"
            >
              {property.name.slice(0, 1)}
            </span>
            <span className="hidden md:block">
              <ErrinPhotoPlaceholder name={property.name} />
            </span>
          </>
        )}
        <span className="flex min-w-0 flex-1 items-center gap-3 md:mt-5 md:flex-col md:items-start md:gap-2">
          <span className="min-w-0 flex-1">
            <h3 className="font-[family-name:var(--font-errin-display,var(--font-display))] text-lg leading-tight tracking-tight text-[var(--charcoal)] md:text-2xl md:leading-snug">
              {property.name}
            </h3>
            <p className="mt-0.5 text-[0.65rem] font-medium uppercase tracking-[0.16em] text-[var(--muted-foreground)] md:mt-2 md:text-[0.7rem] md:tracking-[0.22em]">
              {town}
            </p>
            {property.tagline ? (
              <p className="mt-2 hidden text-base leading-7 text-[var(--muted-foreground)] md:block">{property.tagline}</p>
            ) : null}
          </span>
          <span className="inline-flex shrink-0 items-center gap-3 text-sm tracking-wide text-[var(--forest)] md:mt-auto md:min-h-11 md:pt-2">
            <span className="hidden border-b border-[var(--forest)]/40 pb-0.5 md:inline">
              <Tx k="exploreStay" />
            </span>
            <span aria-hidden="true">→</span>
          </span>
        </span>
      </Link>
    </article>
  );
}

/** Calm stone panel until photos land in public/images/properties/<slug>/. */
export function ErrinPhotoPlaceholder({ name }: { name: string }) {
  return (
    <div className="flex aspect-[4/3] flex-col justify-between bg-[var(--beige)] px-5 py-5">
      <p className="max-w-[12rem] font-[family-name:var(--font-errin-display,var(--font-display))] text-xl leading-snug tracking-tight text-[var(--charcoal)]">
        {name}
      </p>
      <p className="text-[0.65rem] font-medium uppercase tracking-[0.24em] text-[var(--muted-foreground)]">
        <Tx k="photoSoon" />
      </p>
    </div>
  );
}
