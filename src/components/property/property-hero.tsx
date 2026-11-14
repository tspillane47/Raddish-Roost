"use client";

import Image from "next/image";
import Link from "next/link";
import { BookNow } from "@/components/property/book-now";
import { MinStayNote } from "@/components/property/good-to-know";
import { HeroBanner } from "@/components/property/hero-banner";
import { brandLogo } from "@/lib/content/brand-art";
import type { PropertyPhoto } from "@/lib/content/property-photos";
import type { WeatherSnapshot } from "@/lib/content/weather";
import { useTranslate } from "@/lib/i18n/locale-context";
import { isMarkedSample } from "@/lib/data/map-content";
import { useSiteConfig } from "@/sites/site-context";
import type { PropertyGuide } from "@/types/content";

const FOREST = "#263F35";

export function PropertyHero({
  property,
  heroPhotos,
  photos,
  weather = null,
}: {
  property: PropertyGuide;
  heroPhotos: PropertyPhoto[];
  photos: PropertyPhoto[];
  weather?: WeatherSnapshot | null;
}) {
  const { t, tf } = useTranslate();
  const site = useSiteConfig();
  const logo = brandLogo(property.slug);
  const accent =
    logo?.accent ?? (site.key === "roost" ? FOREST : site.colors.forest);
  const sample =
    isMarkedSample(property.welcomeMessage) ||
    isMarkedSample(property.description) ||
    isMarkedSample(property.tagline);
  const remote =
    heroPhotos.length === 0 && property.heroImageUrl
      ? { src: property.heroImageUrl, alt: property.heroImageAlt }
      : null;

  return (
    <header>
      <div className="relative">
        {heroPhotos.length > 0 ? (
          <HeroBanner
            photos={heroPhotos}
            gallery={photos}
            weather={weather}
            frameClassName={
              site.key === "errin"
                ? "relative h-[16svh] max-h-32 min-h-24 md:h-[45svh] md:max-h-[480px] md:min-h-40"
                : undefined
            }
          />
        ) : remote ? (
          <div
            className={
              site.key === "errin"
                ? "relative h-[16svh] max-h-32 min-h-24 overflow-hidden md:h-[45svh] md:max-h-[480px] md:min-h-40"
                : "relative h-[45svh] max-h-[480px] min-h-40 overflow-hidden"
            }
          >
            <Image
              src={remote.src}
              alt={remote.alt}
              fill
              preload
              fetchPriority="high"
              decoding="sync"
              sizes="100vw"
              className="object-cover"
            />
          </div>
        ) : site.key === "errin" ? (
          <div className="flex h-[16svh] max-h-32 min-h-24 items-end bg-[var(--beige)] px-5 pb-6 md:h-[45svh] md:max-h-[480px] md:min-h-40 md:pb-8">
            <p className="mx-auto w-full max-w-6xl text-[0.7rem] font-medium uppercase tracking-[0.24em] text-[var(--muted-foreground)]">
              {t("photoSoon")}
            </p>
          </div>
        ) : (
          <div
            className="h-[45svh] max-h-[480px] min-h-40"
            style={{ background: `linear-gradient(165deg, ${accent} 0%, #F7F4ED 58%)` }}
          />
        )}
        <Link
          href="/"
          className={
            site.key === "errin"
              ? "absolute top-4 left-4 z-10 inline-flex min-h-11 items-center border border-[var(--beige)] bg-[var(--cream)] px-4 text-base text-[var(--forest)] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--forest)]"
              : "absolute top-4 left-4 z-10 inline-flex min-h-11 items-center rounded-full bg-cream/95 px-4 text-base text-forest shadow-sm focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          }
        >
          {t("allStays")}
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
                alt={tf("logoFor", { name: property.name })}
                fill
                sizes="9rem"
                className="object-cover"
                preload={heroPhotos.length === 0 && !remote}
                fetchPriority={heroPhotos.length === 0 && !remote ? "high" : "low"}
                loading={heroPhotos.length === 0 && !remote ? undefined : "lazy"}
              />
            </div>
          </div>
        ) : null}
        <div className={`${logo ? "mt-5" : site.key === "errin" ? "mt-4 md:mt-8" : "mt-8"} text-center md:text-left`}>
          {sample ? (
            <p className="mb-3">
              <span className="rounded-full bg-beige px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
                {t("sample")}
              </span>
            </p>
          ) : null}
          <h1
            className={`font-heading leading-tight break-words text-charcoal ${
              site.key === "errin" ? "text-3xl md:text-5xl" : "text-4xl md:text-5xl"
            }`}
          >
            {property.name}
          </h1>
          {property.tagline ? (
            <p
              className={`mx-auto max-w-2xl text-forest md:mx-0 ${
                site.key === "errin" ? "mt-2 text-base leading-6 md:mt-3 md:text-lg md:leading-8" : "mt-3 text-lg leading-8"
              }`}
            >
              {property.tagline}
            </p>
          ) : null}
          {site.key === "dad" ? <MinStayNote propertySlug={property.slug} /> : null}
          {site.key === "errin" ? (
            <div className="max-md:hidden">
              <BookNow propertySlug={property.slug} bookings={property.bookings} accent={accent} />
            </div>
          ) : (
            <BookNow propertySlug={property.slug} bookings={property.bookings} accent={accent} />
          )}
        </div>
      </div>
    </header>
  );
}
