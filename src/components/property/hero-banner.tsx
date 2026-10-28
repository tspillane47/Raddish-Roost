"use client";

import Image from "next/image";
import { useRef, useState } from "react";
import { PhotoViewer } from "@/components/property/property-gallery";
import { photoObjectPosition } from "@/lib/content/photo-focus";
import type { PropertyPhoto } from "@/lib/content/property-photos";

export function HeroBanner({ photos, gallery }: { photos: PropertyPhoto[]; gallery: PropertyPhoto[] }) {
  const scrollerRef = useRef<HTMLDivElement>(null);
  const [active, setActive] = useState(0);
  const [viewer, setViewer] = useState<number | null>(null);
  if (photos.length === 0) return null;

  const columns = photos.length >= 3 ? "md:grid-cols-3" : photos.length === 2 ? "md:grid-cols-2" : "md:grid-cols-1";

  function onScroll() {
    const scroller = scrollerRef.current;
    if (!scroller || scroller.clientWidth === 0) return;
    const next = Math.round(scroller.scrollLeft / scroller.clientWidth);
    setActive(Math.min(photos.length - 1, Math.max(0, next)));
  }

  function showSlide(index: number) {
    const scroller = scrollerRef.current;
    if (!scroller) return;
    scroller.scrollTo({ left: index * scroller.clientWidth, behavior: "smooth" });
    setActive(index);
  }

  function openPhoto(photo: PropertyPhoto) {
    const index = gallery.findIndex((item) => item.file === photo.file);
    setViewer(index >= 0 ? index : 0);
  }

  return (
    <>
      <div className="relative h-[45vh] max-h-[480px]">
        <div
          ref={scrollerRef}
          aria-label="Stay photos"
          className={`flex h-full snap-x snap-mandatory overflow-x-auto [scrollbar-width:none] md:grid md:snap-none md:gap-[5px] md:overflow-hidden [&::-webkit-scrollbar]:hidden ${columns}`}
          onScroll={onScroll}
        >
          {photos.map((photo) => (
            <button
              key={photo.file}
              type="button"
              className="relative h-full min-w-full shrink-0 snap-start focus-visible:outline-2 focus-visible:outline-offset-[-4px] focus-visible:outline-cream md:min-w-0"
              onClick={() => openPhoto(photo)}
            >
              <Image
                src={photo.src}
                alt={photo.alt}
                fill
                preload
                sizes="(max-width: 768px) 100vw, 34vw"
                className="object-cover"
                style={{ objectPosition: photoObjectPosition(photo.focus) }}
              />
            </button>
          ))}
        </div>
        {photos.length > 1 ? (
          <div className="absolute inset-x-0 bottom-[4.75rem] z-10 flex justify-center gap-2 md:hidden">
            {photos.map((photo, index) => (
              <button
                key={photo.file}
                type="button"
                aria-label={`Show photo ${index + 1} of ${photos.length}`}
                aria-current={index === active ? "true" : undefined}
                className={`size-2.5 rounded-full shadow-[0_0_0_1px_rgb(38_38_38/0.45)] ${
                  index === active ? "bg-cream" : "bg-cream/55"
                }`}
                onClick={() => showSlide(index)}
              />
            ))}
          </div>
        ) : null}
      </div>
      <PhotoViewer photos={gallery} index={viewer} onIndexChange={setViewer} />
    </>
  );
}
