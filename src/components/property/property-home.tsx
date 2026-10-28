import Image from "next/image";
import Link from "next/link";
import { Essentials } from "@/components/property/essentials";
import { PropertyHero } from "@/components/property/property-hero";
import { PropertyLookAround } from "@/components/property/property-look";
import { brandLogo } from "@/lib/content/brand-art";
import { getPropertyPhotos, photosForSection, photoSets } from "@/lib/content/property-photos";
import type { PropertyGuide } from "@/types/content";

const THUMBNAIL_SECTIONS = new Set(["getting-here", "house-guide", "amenities"]);
const FOREST = "#263F35";

export function PropertyHome({ property }: { property: PropertyGuide }) {
  const gallery = getPropertyPhotos(property.slug);
  const accent = brandLogo(property.slug)?.accent ?? FOREST;

  return (
    <article className="pb-16">
      <PropertyHero property={property} heroPhotos={gallery.heroPhotos} photos={gallery.photos} />
      <div className="mx-auto w-full max-w-6xl px-5">
        {property.welcomeMessage ? (
          <section className="mt-12" aria-label="Welcome">
            <p className="max-w-2xl text-lg leading-8">{property.welcomeMessage}</p>
          </section>
        ) : null}
        <div className="mt-12">
          <Essentials property={property} />
        </div>
        <section id="guidebook" aria-labelledby="guidebook-heading" className="mt-16 scroll-mt-28">
          <h2 id="guidebook-heading" className="font-heading text-3xl text-forest">
            Guidebook
          </h2>
          <div className="mt-4 h-px w-16" style={{ backgroundColor: accent }} aria-hidden="true" />
          {property.sections.length === 0 ? (
            <p role="status" className="mt-6 text-base leading-7">
              Guidebook sections have not been added yet.
            </p>
          ) : (
            <ul className="mt-6 grid list-none gap-4 p-0 sm:grid-cols-2">
              {property.sections.map((section) => {
                const thumb = THUMBNAIL_SECTIONS.has(section.slug)
                  ? (photosForSection(property.slug, section.slug)[0] ?? null)
                  : null;
                return (
                  <li key={section.slug}>
                    <Link
                      href={
                        section.slug === "local-recommendations"
                          ? `/${property.slug}/explore`
                          : `/${property.slug}/guide/${section.slug}`
                      }
                      className="flex min-h-24 items-stretch gap-4 rounded-2xl bg-beige/50 p-4 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
                    >
                      {thumb ? (
                        <span className="relative size-20 shrink-0 overflow-hidden rounded-xl">
                          <Image src={thumb.src} alt="" fill sizes="80px" className="object-cover" />
                        </span>
                      ) : null}
                      <span className="min-w-0">
                        <h3 className="font-heading text-2xl text-charcoal">{section.title}</h3>
                        {section.summary ? (
                          <p className="mt-2 line-clamp-3 text-sm leading-6 text-muted-foreground">{section.summary}</p>
                        ) : null}
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          )}
        </section>
        <PropertyLookAround photos={gallery.photos} sets={photoSets(property.slug)} accent={accent} />
      </div>
    </article>
  );
}

export function PropertyHomeFallback() {
  return (
    <div aria-busy="true" aria-live="polite">
      <p className="sr-only">Loading this stay</p>
      <div className="h-[45vh] max-h-[480px] bg-beige/80" />
      <div className="mx-auto w-full max-w-6xl px-5">
        <div className="-mt-14 size-28 rounded-full bg-beige" />
        <div className="mt-6 h-12 w-2/3 rounded bg-beige" />
        <div className="mt-10 grid gap-3 sm:grid-cols-2">
          {["a", "b", "c", "d"].map((key) => (
            <div key={key} className="h-24 rounded-2xl bg-beige/80" />
          ))}
        </div>
      </div>
    </div>
  );
}
