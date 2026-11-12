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
          <>
            <Image
              src={site.hero.src}
              alt={site.hero.alt}
              width={site.hero.width}
              height={site.hero.height}
              preload
              fetchPriority="high"
              sizes="100vw"
              className="block h-[min(68svh,36rem)] w-full object-cover object-[18%_42%] sm:object-[22%_44%] md:h-[min(62svh,34rem)] md:object-[26%_46%]"
            />
            {/* House sits left; darken the left so white type stays AA-readable. */}
            <div
              className="pointer-events-none absolute inset-0 bg-[linear-gradient(95deg,rgb(14_14_14_/_0.72)_0%,rgb(20_20_20_/_0.42)_38%,transparent_72%)]"
              aria-hidden="true"
            />
            <div className="pointer-events-none absolute inset-0">
              <div className="mx-auto flex h-full w-full max-w-6xl items-end px-5 pb-10 sm:pb-12 md:items-center md:pb-0 md:pl-6 lg:pl-10">
                <div className="max-w-[16rem] sm:max-w-[20rem] md:max-w-lg">
                  <p className="text-[0.65rem] font-medium uppercase tracking-[0.28em] text-white md:text-[0.7rem]">
                    <Tx k="errinHeroPlaces" />
                  </p>
                  <h1 className="mt-2 font-[family-name:var(--font-errin-display,var(--font-display))] text-[clamp(2.1rem,7.5vw,4.25rem)] leading-[0.95] tracking-tight text-white md:mt-3">
                    {site.name}
                  </h1>
                </div>
              </div>
            </div>
          </>
        ) : (
          <div className="flex h-[min(62svh,34rem)] w-full items-end bg-[var(--beige)] px-5 pb-12 md:pb-16">
            <div className="mx-auto w-full max-w-6xl">
              <p className="text-[0.7rem] font-medium uppercase tracking-[0.28em] text-[var(--muted-foreground)]">
                <Tx k="errinHeroPlaces" />
              </p>
              <h1 className="mt-4 max-w-3xl font-[family-name:var(--font-errin-display,var(--font-display))] text-[clamp(2.75rem,8vw,5.5rem)] leading-[0.95] tracking-tight text-[var(--charcoal)]">
                {site.name}
              </h1>
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
