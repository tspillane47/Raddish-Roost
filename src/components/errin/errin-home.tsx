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
            className="relative mx-auto w-full md:w-[var(--errin-hero-width)]"
            style={{
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
              // Phones stay a tall crop: house on the left, open sky for the title.
              // md+ follows the photo ratio so the porch and stairs stay in frame.
              style={{ aspectRatio: `${site.hero.width} / ${site.hero.height}` }}
              className="block h-[min(62svh,32rem)] w-full object-cover object-[42%_0%] sm:h-[min(58svh,30rem)] sm:object-[38%_0%] md:h-auto md:max-h-[85svh] md:w-full md:object-contain md:object-center"
            />
            <div
              className="pointer-events-none absolute inset-x-0 top-0 h-[46%] bg-[linear-gradient(180deg,rgb(250_249_246_/_0.55)_0%,rgb(250_249_246_/_0.18)_55%,transparent_100%)] md:h-[42%]"
              aria-hidden="true"
            />
            <div className="pointer-events-none absolute top-[5%] right-[4%] left-[40%] z-10 text-center sm:left-[36%] md:top-[8%] md:right-[7%] md:left-[48%]">
              <h1 className="font-[family-name:var(--font-errin-display,var(--font-display))] text-[clamp(1.35rem,4vw,2.35rem)] leading-[0.95] tracking-tight text-[var(--charcoal)]">
                {site.name}
              </h1>
              <p className="mt-1 text-[0.55rem] font-medium uppercase tracking-[0.16em] text-[var(--muted-foreground)] sm:mt-1.5 sm:text-[0.6rem] md:text-[0.68rem] md:tracking-[0.2em]">
                <Tx k="errinHeroPlaces" />
              </p>
            </div>
          </div>
        ) : (
          <div className="flex h-[min(62svh,34rem)] w-full items-start justify-center bg-[var(--beige)] px-5 pt-10 md:pt-14">
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

      <div className="mx-auto w-full max-w-6xl px-5 pt-8 md:pt-10">
        <p className="max-w-2xl text-base leading-7 text-[var(--muted-foreground)] md:text-lg">
          {site.tagline}
        </p>
        <p className="mt-3 text-sm leading-6 tracking-wide text-[var(--muted-foreground)]">
          <Tx k="errinHostedBy" />
        </p>
        <div className="mt-8 h-px w-full bg-[var(--beige)]" aria-hidden="true" />
      </div>

      <section
        id="where-staying"
        aria-labelledby="where-staying-heading"
        className="mx-auto w-full max-w-6xl scroll-mt-24 px-5 pb-20 pt-12 md:pb-28 md:pt-16"
      >
        <p className="text-[0.7rem] font-medium uppercase tracking-[0.28em] text-[var(--muted-foreground)]">
          <Tx k="staysLabel" />
        </p>
        <h2
          id="where-staying-heading"
          className="mt-3 font-[family-name:var(--font-errin-display,var(--font-display))] text-3xl tracking-tight text-[var(--charcoal)] md:text-4xl"
        >
          {site.collectionHeading}
        </h2>
        <p className="mt-4 max-w-2xl text-base leading-7 text-[var(--muted-foreground)]">{site.collectionBody}</p>

        {properties.length === 0 ? (
          <p role="status" className="mt-12 border border-[var(--beige)] px-5 py-10 text-base leading-7">
            {site.comingSoonBody}
          </p>
        ) : (
          <ul className="mt-12 grid list-none gap-12 p-0 md:grid-cols-3 md:gap-8">
            {properties.map((property) => (
              <li key={property.slug} className="min-w-0">
                <ErrinStayCard property={property} />
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}

function ErrinStayCard({ property }: { property: PropertySummary }) {
  const gallery = getPropertyPhotos(property.slug);
  const photo = gallery.cardPhoto ?? gallery.heroPhotos[0] ?? null;
  const town = property.locality?.trim() || "Vermont";

  return (
    <article className="group flex h-full min-w-0 flex-col">
      <Link
        href={`/${property.slug}`}
        className="block overflow-hidden bg-[var(--beige)] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--forest)]"
      >
        {photo ? (
          <Image
            src={photo.src}
            alt={photo.alt}
            width={photo.width}
            height={photo.height}
            className="aspect-[4/3] w-full object-cover motion-safe:transition-transform motion-safe:duration-500 motion-safe:group-hover:scale-[1.02]"
            sizes="(max-width: 768px) calc(100vw - 2.5rem), 22rem"
          />
        ) : (
          <ErrinPhotoPlaceholder name={property.name} />
        )}
      </Link>
      <div className="mt-5 flex min-w-0 flex-1 flex-col gap-2">
        <h3 className="font-[family-name:var(--font-errin-display,var(--font-display))] text-2xl leading-snug tracking-tight text-[var(--charcoal)]">
          <Link
            href={`/${property.slug}`}
            className="focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--forest)]"
          >
            {property.name}
          </Link>
        </h3>
        <p className="text-[0.7rem] font-medium uppercase tracking-[0.22em] text-[var(--muted-foreground)]">{town}</p>
        {property.tagline ? (
          <p className="text-base leading-7 text-[var(--muted-foreground)]">{property.tagline}</p>
        ) : null}
        <Link
          href={`/${property.slug}`}
          className="mt-auto inline-flex min-h-11 items-center gap-3 pt-2 text-sm tracking-wide text-[var(--forest)] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--forest)]"
        >
          <span className="border-b border-[var(--forest)]/40 pb-0.5">
            <Tx k="exploreStay" />
          </span>
          <span aria-hidden="true">→</span>
        </Link>
      </div>
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
