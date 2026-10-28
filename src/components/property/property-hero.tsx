import Image from "next/image";
import Link from "next/link";
import { brandLogo } from "@/lib/content/brand-art";
import type { PropertyPhoto } from "@/lib/content/property-photos";
import { isMarkedSample } from "@/lib/data/map-content";
import type { PropertyGuide } from "@/types/content";

const FOREST = "#263F35";

export function PropertyHero({ property, hero }: { property: PropertyGuide; hero: PropertyPhoto | null }) {
  const logo = brandLogo(property.slug);
  const accent = logo?.accent ?? FOREST;
  const sample =
    isMarkedSample(property.welcomeMessage) ||
    isMarkedSample(property.description) ||
    isMarkedSample(property.tagline);
  const photo = hero
    ? { src: hero.src, alt: hero.alt, width: hero.width, height: hero.height }
    : property.heroImageUrl
      ? { src: property.heroImageUrl, alt: property.heroImageAlt, width: 1600, height: 900 }
      : null;

  return (
    <header>
      <div className="relative h-[58vh] overflow-hidden md:h-[65vh]">
        {photo ? (
          <Image
            src={photo.src}
            alt={photo.alt}
            fill
            preload
            sizes="100vw"
            className="object-cover"
            style={{ objectPosition: "center 42%" }}
          />
        ) : (
          <div
            className="absolute inset-0"
            style={{
              background: `linear-gradient(165deg, ${accent} 0%, #F7F4ED 58%)`,
            }}
          />
        )}
        {photo ? (
          <div
            className="pointer-events-none absolute inset-x-0 bottom-0 h-2/5 bg-gradient-to-t from-charcoal/55 via-charcoal/15 to-transparent"
            aria-hidden="true"
          />
        ) : null}
        <Link
          href="/"
          className="absolute top-4 left-4 z-10 inline-flex min-h-11 items-center rounded-full bg-cream/95 px-4 text-sm text-forest shadow-sm focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          All stays
        </Link>
      </div>
      <div className="mx-auto w-full max-w-6xl px-5">
        {logo ? (
          <div className="-mt-14 flex justify-center md:-mt-[4.5rem] md:justify-start">
            <div
              className="relative size-28 overflow-hidden rounded-full bg-cream md:size-36"
              style={{
                boxShadow: `0 0 0 4px #F7F4ED, 0 0 0 6px ${accent}, 0 12px 28px rgb(38 38 38 / 0.16)`,
              }}
            >
              <Image
                src={logo.src}
                alt={logo.alt}
                fill
                sizes="9rem"
                className="object-cover"
                preload={!photo}
              />
            </div>
          </div>
        ) : null}
        <div className={`${logo ? "mt-5" : "mt-8"} text-center md:text-left`}>
          {sample ? (
            <p className="mb-3">
              <span className="rounded-full bg-beige px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
                Sample
              </span>
            </p>
          ) : null}
          <h1 className="font-heading text-4xl leading-tight text-charcoal md:text-5xl">{property.name}</h1>
          {property.tagline ? (
            <p className="mx-auto mt-3 max-w-2xl text-lg leading-8 text-forest md:mx-0">{property.tagline}</p>
          ) : null}
        </div>
      </div>
    </header>
  );
}
