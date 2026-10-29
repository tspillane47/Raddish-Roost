"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";
import { PhotoViewer } from "@/components/property/property-gallery";
import { photoObjectPosition } from "@/lib/content/photo-focus";
import type { PropertyPhoto } from "@/lib/content/property-photos";

export function HeroBanner({ photos, gallery }: { photos: PropertyPhoto[]; gallery: PropertyPhoto[] }) {
  const scrollerRef = useRef<HTMLDivElement>(null);
  const frame = useRef(0);
  const [active, setActive] = useState(0);
  const [viewer, setViewer] = useState<number | null>(null);
  const [slidesReady, setSlidesReady] = useState(false);
  const columns = photos.length >= 3 ? "md:grid-cols-3" : photos.length === 2 ? "md:grid-cols-2" : "md:grid-cols-1";

  useEffect(() => {
    const id = window.setTimeout(() => setSlidesReady(true), 8000);
    return () => {
      window.clearTimeout(id);
      if (frame.current) cancelAnimationFrame(frame.current);
    };
  }, []);

  if (photos.length === 0) return null;

  function onScroll() {
    if (frame.current) return;
    frame.current = requestAnimationFrame(() => {
      frame.current = 0;
      const scroller = scrollerRef.current;
      if (!scroller || scroller.clientWidth === 0) return;
      const next = Math.round(scroller.scrollLeft / scroller.clientWidth);
      setActive(Math.min(photos.length - 1, Math.max(0, next)));
    });
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
      <div className="relative h-[45svh] max-h-[480px] min-h-40">
        <div
          ref={scrollerRef}
          aria-label="Stay photos"
          className={`flex h-full w-full min-w-0 snap-x snap-mandatory overflow-x-auto overscroll-x-contain [scrollbar-width:none] md:grid md:snap-none md:gap-[5px] md:overflow-hidden [&::-webkit-scrollbar]:hidden ${columns}`}
          onScroll={onScroll}
        >
          {photos.map((photo, index) =>
            index === 0 || slidesReady ? (
              <button
                key={photo.file}
                type="button"
                className="relative h-full min-w-full shrink-0 snap-start bg-beige focus-visible:outline-2 focus-visible:outline-offset-[-4px] focus-visible:outline-cream md:min-w-0"
                onClick={() => openPhoto(photo)}
              >
                <Image
                  src={photo.src}
                  alt={photo.alt}
                  fill
                  preload={index === 0}
                  quality={index === 0 ? 60 : 75}
                  fetchPriority={index === 0 ? "high" : "low"}
                  decoding={index === 0 ? "sync" : "async"}
                  sizes="(max-width: 768px) 100vw, 34vw"
                  className="object-cover"
                  style={{ objectPosition: photoObjectPosition(photo.focus) }}
                  onLoad={index === 0 ? () => setSlidesReady(true) : undefined}
                />
              </button>
            ) : (
              <div key={photo.file} className="h-full min-w-full shrink-0 bg-beige md:min-w-0" aria-hidden="true" />
            ),
          )}
        </div>
        {photos.length > 1 ? (
          <div className="absolute inset-x-0 bottom-16 z-10 flex justify-center md:hidden">
            {photos.map((photo, index) => (
              <button
                key={photo.file}
                type="button"
                aria-label={`Show photo ${index + 1} of ${photos.length}`}
                aria-current={index === active ? "true" : undefined}
                className="inline-flex size-11 items-center justify-center"
                onClick={() => showSlide(index)}
              >
                <span
                  className={`size-2.5 rounded-full shadow-[0_0_0_1px_rgb(38_38_38/0.45)] ${
                    index === active ? "bg-cream" : "bg-cream/55"
                  }`}
                />
              </button>
            ))}
          </div>
        ) : null}
      </div>
      <PhotoViewer photos={gallery} index={viewer} onIndexChange={setViewer} />
    </>
  );
}
