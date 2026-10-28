import Image from "next/image";
import Link from "next/link";
import { Essentials } from "@/components/property/essentials";
import { PhotoPlaceholder } from "@/components/property/photo-placeholder";
import { placeholderTone } from "@/lib/content/sections";
import { isMarkedSample } from "@/lib/data/map-content";
import type { PropertyGuide } from "@/types/content";

export function PropertyHome({ property }: { property: PropertyGuide }) {
  const sample =
    isMarkedSample(property.welcomeMessage) ||
    isMarkedSample(property.description) ||
    isMarkedSample(property.tagline);

  return (
    <article className="mx-auto w-full max-w-3xl px-5 py-10">
      <p>
        <Link
          href="/"
          className="inline-flex min-h-11 items-center text-sm text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          All stays
        </Link>
      </p>
      <div className="relative mt-4 overflow-hidden rounded-xl">
        {property.heroImageUrl ? (
          <Image
            src={property.heroImageUrl}
            alt={property.heroImageAlt}
            width={1600}
            height={900}
            preload
            className="aspect-[16/9] w-full object-cover"
            sizes="(max-width: 768px) 100vw, 48rem"
          />
        ) : (
          <PhotoPlaceholder
            name={property.name}
            tone={placeholderTone(property.slug)}
            className="aspect-[16/9]"
          />
        )}
      </div>
      <header className="mt-8">
        <div className="flex items-start justify-between gap-3">
          <h1 className="font-heading text-4xl leading-tight text-charcoal md:text-5xl">
            {property.name}
          </h1>
          {sample ? (
            <span className="mt-2 shrink-0 rounded-full border border-forest px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
              Sample
            </span>
          ) : null}
        </div>
        <p className="mt-4 font-heading text-2xl text-forest">{property.welcomeTitle}</p>
        <p className="mt-4 text-lg leading-8">{property.welcomeMessage}</p>
      </header>
      <div className="mt-12">
        <Essentials property={property} />
      </div>
      <section aria-labelledby="guidebook-heading" className="mt-14">
        <h2 id="guidebook-heading" className="font-heading text-3xl text-forest">
          Guidebook
        </h2>
        <div className="mt-4 h-px w-16 bg-terracotta" aria-hidden="true" />
        {property.sections.length === 0 ? (
          <p role="status" className="mt-6 text-base leading-7">
            Guidebook sections have not been added yet.
          </p>
        ) : (
          <ul className="mt-6 grid list-none gap-4 p-0 sm:grid-cols-2">
            {property.sections.map((section) => (
              <li key={section.slug} className="rounded-xl border border-beige p-5">
                <h3 className="font-heading text-2xl text-charcoal">{section.title}</h3>
                {section.summary ? (
                  <p className="mt-2 text-sm leading-6 text-muted-foreground">{section.summary}</p>
                ) : null}
              </li>
            ))}
          </ul>
        )}
      </section>
    </article>
  );
}

export function PropertyHomeFallback() {
  return (
    <div aria-busy="true" aria-live="polite" className="mx-auto w-full max-w-3xl px-5 py-10">
      <p className="sr-only">Loading this stay</p>
      <div className="h-8 w-24 rounded bg-beige" />
      <div className="mt-4 aspect-[16/9] rounded-xl bg-beige/80" />
      <div className="mt-8 h-12 w-2/3 rounded bg-beige" />
      <div className="mt-8 grid gap-3 sm:grid-cols-2">
        {["a", "b", "c", "d"].map((key) => (
          <div key={key} className="h-24 rounded-xl bg-beige/80" />
        ))}
      </div>
    </div>
  );
}
