import Image from "next/image";
import Link from "next/link";
import type { ReactNode } from "react";
import { DuffelBagIcon, KeyholeIcon, VintageKeyIcon } from "@/components/dad/heist-icons";
import { SectionThemedHeading } from "@/components/site/themed-heading";
import { Essentials } from "@/components/property/essentials";
import { PropertyHero } from "@/components/property/property-hero";
import { PropertyLookAround } from "@/components/property/property-look";
import { WeatherCard } from "@/components/property/weather-card";
import { brandLogo } from "@/lib/content/brand-art";
import { getPropertyPhotos, photosForSection, photoSets } from "@/lib/content/property-photos";
import { Tx } from "@/lib/i18n/locale-context";
import type { WeatherSnapshot } from "@/lib/content/weather";
import { getSiteConfig } from "@/sites";
import type { PropertyGuide } from "@/types/content";

const THUMBNAIL_SECTIONS = new Set(["getting-here", "the-house", "house-guide", "amenities"]);
const FOREST = "#263F35";

function sectionIcon(slug: string, dad: boolean): ReactNode {
  if (!dad) return null;
  if (slug === "check-in-checkout" || slug === "check-in") {
    return <VintageKeyIcon className="size-5 shrink-0 text-forest" />;
  }
  if (slug === "things-to-do") return <DuffelBagIcon className="size-5 shrink-0 text-forest" />;
  if (slug === "contact" || slug === "getting-here") {
    return <KeyholeIcon className="size-5 shrink-0 text-forest" />;
  }
  return null;
}

export function PropertyHome({
  property,
  weather = null,
}: {
  property: PropertyGuide;
  weather?: WeatherSnapshot | null;
}) {
  const gallery = getPropertyPhotos(property.slug);
  const site = getSiteConfig();
  const accent = brandLogo(property.slug)?.accent ?? (site.key === "dad" ? site.colors.forest : FOREST);

  return (
    <article className="pb-16">
      <PropertyHero property={property} heroPhotos={gallery.heroPhotos} photos={gallery.photos} weather={weather} />
      <div className="mx-auto w-full max-w-6xl px-5">
        {property.welcomeMessage ? (
          <section className="mt-12" aria-labelledby="welcome-note">
            <h2 id="welcome-note" className="sr-only">
              <Tx k="welcomeLabel" />
            </h2>
            <p className="max-w-2xl text-lg leading-8">{property.welcomeMessage}</p>
          </section>
        ) : null}
        {weather ? (
          <div className="mt-8 w-full max-w-[640px]">
            <WeatherCard weather={weather} />
          </div>
        ) : null}
        <div className="mt-12">
          <Essentials property={property} />
        </div>
        <section id="guidebook" aria-labelledby="guidebook-heading" className="mt-16 scroll-mt-[var(--site-header)]">
          <h2 id="guidebook-heading" className="font-heading text-3xl text-forest">
            <Tx k="guidebook" />
          </h2>
          <div className="mt-4 h-px w-16" style={{ backgroundColor: accent }} aria-hidden="true" />
          {property.sections.length === 0 ? (
            <p role="status" className="mt-6 text-base leading-7">
              <Tx k="guidebookEmpty" />
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
                      href={`/${property.slug}/guide/${section.slug}`}
                      className="flex min-h-24 items-stretch gap-4 rounded-2xl bg-beige/50 p-4 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
                    >
                      {thumb ? (
                        <span className="relative size-20 shrink-0 overflow-hidden rounded-xl">
                          <Image src={thumb.src} alt="" fill sizes="80px" className="object-cover" />
                        </span>
                      ) : null}
                      <span className="min-w-0">
                        <SectionThemedHeading
                          as="h3"
                          sectionSlug={section.slug}
                          fallback={section.title}
                          className="font-heading text-2xl text-charcoal"
                          icon={sectionIcon(section.slug, site.key === "dad")}
                        />
                        {section.summary ? (
                          <p className="mt-2 line-clamp-3 text-base leading-7 text-muted-foreground">{section.summary}</p>
                        ) : null}
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          )}
          {property.guestArea === "florida" ? (
            <Link
              href={`/${property.slug}/guide/sanibel-101`}
              className="mt-4 flex min-h-24 items-center rounded-2xl border border-beige px-4 py-4 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              <span>
                <h3 className="font-heading text-2xl text-charcoal">
                  <Tx k="sanibel101" />
                </h3>
                <p className="mt-2 text-base leading-7 text-muted-foreground">
                  <Tx k="sanibel101Blurb" />
                </p>
              </span>
            </Link>
          ) : (
            <Link
              href={`/${property.slug}/guide/vermont-101`}
              className="mt-4 flex min-h-24 items-center rounded-2xl border border-beige px-4 py-4 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              <span>
                <h3 className="font-heading text-2xl text-charcoal">
                  <Tx k="vermont101" />
                </h3>
                <p className="mt-2 text-base leading-7 text-muted-foreground">
                  <Tx k="vermont101Blurb" />
                </p>
              </span>
            </Link>
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
      <p className="sr-only">
        <Tx k="loadingStay" />
      </p>
      <div className="h-[45svh] max-h-[480px] min-h-40 bg-beige/80" />
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
