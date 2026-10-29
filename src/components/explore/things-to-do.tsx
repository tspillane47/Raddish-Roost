"use client";

import Image from "next/image";
import { useState } from "react";
import { SectionIcon } from "@/components/explore/section-icon";
import { seasonLabel, THING_SECTIONS, type ThingToDo } from "@/lib/content/things-to-do";

export function ThingsToDo({ places, accent = "#263F35" }: { places: ThingToDo[]; accent?: string }) {
  const sections = THING_SECTIONS.filter((section) => places.some((place) => place.section === section.id));
  const [active, setActive] = useState(sections[0]?.id ?? "eat");
  const current = sections.some((section) => section.id === active) ? active : sections[0]?.id;
  const shown = places.filter((place) => place.section === current);

  if (sections.length === 0 || !current) {
    return (
      <p role="status" className="mt-6 text-lg leading-8">
        Things to do have not been added yet.
      </p>
    );
  }

  return (
    <div className="mt-6">
      <div className="sticky top-0 z-30 -mx-5 border-b border-beige bg-cream/95 px-5 backdrop-blur-sm">
        <div
          role="tablist"
          aria-label="Things to do"
          className="flex gap-2 overflow-x-auto py-3 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
        >
          {sections.map((section) => {
            const selected = section.id === current;
            return (
              <button
                key={section.id}
                type="button"
                role="tab"
                id={`things-tab-${section.id}`}
                aria-selected={selected}
                aria-controls={`things-panel-${section.id}`}
                className={`inline-flex min-h-11 shrink-0 items-center gap-2 rounded-full px-4 text-sm whitespace-nowrap focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest ${
                  selected ? "bg-forest text-cream" : "bg-beige/80 text-charcoal"
                }`}
                onClick={() => setActive(section.id)}
              >
                <SectionIcon id={section.id} className="size-4" />
                {section.label}
              </button>
            );
          })}
        </div>
      </div>
      <ul
        id={`things-panel-${current}`}
        role="tabpanel"
        aria-labelledby={`things-tab-${current}`}
        className="mt-4 grid list-none gap-4 p-0"
      >
        {shown.map((place) => (
          <li key={place.id}>
            <ThingCard place={place} accent={accent} />
          </li>
        ))}
      </ul>
    </div>
  );
}

function ThingCard({ place, accent }: { place: ThingToDo; accent: string }) {
  const season = seasonLabel(place.season);
  return (
    <article className="flex gap-4 rounded-2xl bg-beige/50 p-4">
      <div className="relative flex size-16 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-sage/40 text-forest">
        {place.photo ? (
          <Image src={place.photo.src} alt={place.photo.alt} fill sizes="64px" className="object-cover" />
        ) : (
          <SectionIcon id={place.section} />
        )}
      </div>
      <div className="min-w-0">
        <h2 className="font-heading text-2xl leading-tight break-words text-charcoal">{place.name}</h2>
        {place.town ? <p className="mt-1 text-sm text-forest">{place.town}</p> : null}
        {place.description ? <p className="mt-2 text-base leading-7">{place.description}</p> : null}
        {place.tip ? (
          <p
            className="mt-3 rounded-lg px-3 py-2 text-sm leading-6"
            style={{
              color: accent,
              backgroundColor: `${accent}18`,
              boxShadow: `inset 3px 0 0 ${accent}`,
            }}
          >
            <span className="font-semibold">Host tip: </span>
            {place.tip}
          </p>
        ) : null}
        {place.photo?.credit ? (
          <p className="mt-2 text-xs leading-5 text-muted-foreground">
            <a
              href={place.photo.credit.url}
              target="_blank"
              rel="noopener noreferrer"
              className="underline-offset-2 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
            >
              Photo: {place.photo.credit.author}, {place.photo.credit.license}
            </a>
          </p>
        ) : null}
        {season ? (
          <p className="mt-2">
            <span className="rounded-full bg-cream px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
              {season}
            </span>
          </p>
        ) : null}
        <p className="mt-3">
          <a
            href={place.directionsUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-sm text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
          >
            Get Directions
          </a>
        </p>
      </div>
    </article>
  );
}
