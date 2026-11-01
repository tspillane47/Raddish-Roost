"use client";

import Image from "next/image";
import { useState } from "react";
import { PhotoViewer, type GalleryPhoto } from "@/components/property/property-gallery";
import { useTranslate } from "@/lib/i18n/locale-context";
import type { MessageKey } from "@/lib/i18n/messages";

export type LookSet = {
  id: string;
  label: string;
  photos: GalleryPhoto[];
};

export function photoFrame(count: number, index: number): "wide" | "pair" {
  if (count <= 1) return "wide";
  if (count === 2) return "pair";
  if (index === 0) return "wide";
  const restCount = count - 1;
  const restIndex = index - 1;
  if (restIndex === restCount - 1 && restCount % 2 === 1) return "wide";
  return "pair";
}

export function PropertyLookAround({
  photos,
  sets,
  accent,
}: {
  photos: GalleryPhoto[];
  sets: LookSet[];
  accent: string;
}) {
  const [index, setIndex] = useState<number | null>(null);
  const { t, tf } = useTranslate();
  if (photos.length === 0) return null;

  const shown = sets.reduce((count, set) => count + set.photos.length, 0);
  const frames = sets.length > 0 ? sets : [{ id: "photos", label: "", photos: photos.slice(0, 9) }];

  function openPhoto(src: string) {
    const next = photos.findIndex((photo) => photo.src === src);
    setIndex(next >= 0 ? next : 0);
  }

  return (
    <section aria-labelledby="look-around-heading" className="mt-16">
      <h2 id="look-around-heading" className="font-heading text-3xl text-forest">
        {t("lookAround")}
      </h2>
      <div className="mt-8 grid gap-12">
        {frames.map((set) => (
          <div key={set.id}>
            {set.label ? (
              <h3 className="text-xs font-medium tracking-[0.16em] uppercase" style={{ color: accent }}>
                {setTitle(set.id, set.label, t)}
              </h3>
            ) : null}
            <ul className={`${set.label ? "mt-4" : ""} grid list-none grid-cols-2 gap-3 p-0 md:gap-4`}>
              {set.photos.map((photo, photoIndex) => {
                const wide = photoFrame(set.photos.length, photoIndex) === "wide";
                return (
                  <li key={photo.src} className={wide ? "col-span-2" : undefined}>
                    <button
                      type="button"
                      className={`relative block w-full overflow-hidden rounded-2xl focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest ${
                        wide ? "aspect-[3/2] md:aspect-[2/1]" : "aspect-[4/3]"
                      }`}
                      onClick={() => openPhoto(photo.src)}
                    >
                      <Image
                        src={photo.src}
                        alt={photo.alt}
                        fill
                        sizes={
                          wide
                            ? "(max-width: 768px) calc(100vw - 2.5rem), 72rem"
                            : "(max-width: 768px) calc(50vw - 1.6rem), 36rem"
                        }
                        className="object-cover"
                        fetchPriority="low"
                      />
                    </button>
                  </li>
                );
              })}
            </ul>
          </div>
        ))}
      </div>
      {photos.length > shown ? (
        <button
          type="button"
          className="mt-10 inline-flex min-h-12 w-full items-center justify-center rounded-full bg-forest px-6 text-base font-medium text-cream focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest md:w-auto"
          onClick={() => setIndex(0)}
        >
          {photos.length === 1 ? tf("seeAllPhoto", { count: photos.length }) : tf("seeAllPhotos", { count: photos.length })}
        </button>
      ) : null}
      <PhotoViewer photos={photos} index={index} onIndexChange={setIndex} />
    </section>
  );
}

const SET_KEYS: Record<string, MessageKey> = {
  living: "livingSpaces",
  "kitchen-dining": "kitchenDining",
  bedrooms: "bedrooms",
  "bath-laundry": "bathLaundry",
  outside: "outsideTown",
};

function setTitle(id: string, label: string, translate: (key: MessageKey) => string) {
  const key = SET_KEYS[id];
  return key ? translate(key) : label;
}
