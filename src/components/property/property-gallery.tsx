"use client";

import Image from "next/image";
import { useEffect, useId, useRef, useState } from "react";

export type GalleryPhoto = {
  src: string;
  alt: string;
  width: number;
  height: number;
};

export function PropertyGallery({ photos, heading = "Photos" }: { photos: GalleryPhoto[]; heading?: string }) {
  const [index, setIndex] = useState<number | null>(null);
  const dialogRef = useRef<HTMLDialogElement>(null);
  const closeRef = useRef<HTMLButtonElement>(null);
  const touchStart = useRef<{ x: number; y: number } | null>(null);
  const titleId = useId();
  const headingId = useId();
  const open = index !== null;
  const photo = index === null ? null : photos[index];

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog || !open) return;
    if (!dialog.open) {
      try {
        dialog.showModal();
      } catch {
        dialog.setAttribute("open", "");
      }
    }
    closeRef.current?.focus();
    return () => {
      if (dialog.open && typeof dialog.close === "function") dialog.close();
    };
  }, [open]);

  function step(delta: number) {
    setIndex((current) => {
      if (current === null || photos.length < 2) return current;
      return (current + delta + photos.length) % photos.length;
    });
  }

  function onPointerDown(event: React.PointerEvent<HTMLDivElement>) {
    if (event.pointerType === "mouse") return;
    touchStart.current = { x: event.clientX, y: event.clientY };
    try {
      event.currentTarget.setPointerCapture(event.pointerId);
    } catch {
      // Pointer capture is unavailable in some test browsers.
    }
  }

  function onPointerUp(event: React.PointerEvent<HTMLDivElement>) {
    const start = touchStart.current;
    touchStart.current = null;
    if (!start) return;
    const dx = event.clientX - start.x;
    const dy = event.clientY - start.y;
    if (Math.abs(dx) < 48 || Math.abs(dx) < Math.abs(dy)) return;
    step(dx < 0 ? 1 : -1);
  }

  if (photos.length === 0) return null;

  return (
    <section aria-labelledby={headingId}>
      <h2 id={headingId} className="font-heading text-3xl text-forest">
        {heading}
      </h2>
      <ul className="mt-4 grid list-none grid-cols-2 gap-3 p-0 sm:grid-cols-3">
        {photos.map((item, itemIndex) => (
          <li key={item.src}>
            <button
              type="button"
              className="relative block aspect-[4/3] w-full overflow-hidden rounded-xl focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
              onClick={() => setIndex(itemIndex)}
            >
              <Image
                src={item.src}
                alt={item.alt}
                fill
                sizes="(max-width: 640px) 50vw, 16rem"
                className="object-cover"
              />
            </button>
          </li>
        ))}
      </ul>
      {open && photo ? (
        <dialog
          ref={dialogRef}
          aria-labelledby={titleId}
          className="photo-viewer z-[60] flex flex-col overflow-hidden"
          onClose={() => setIndex(null)}
          onKeyDown={(event) => {
            if (event.key === "ArrowRight") {
              event.preventDefault();
              step(1);
            }
            if (event.key === "ArrowLeft") {
              event.preventDefault();
              step(-1);
            }
          }}
        >
          <div className="flex items-center justify-between gap-3 px-4 pt-[max(0.75rem,env(safe-area-inset-top))] pb-3">
            <p aria-live="polite" className="text-sm text-cream">
              {index + 1} of {photos.length}
            </p>
            <button
              ref={closeRef}
              type="button"
              className="inline-flex min-h-12 items-center rounded-full bg-cream px-5 text-base font-medium text-charcoal focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-cream"
              onClick={() => setIndex(null)}
            >
              Close
            </button>
          </div>
          <h2 id={titleId} className="sr-only">
            {photo.alt}
          </h2>
          <div
            className="relative min-h-0 flex-1 touch-none"
            onPointerDown={onPointerDown}
            onPointerUp={onPointerUp}
          >
            <Image
              src={photo.src}
              alt={photo.alt}
              fill
              sizes="100vw"
              className="object-contain"
              preload
            />
          </div>
          {photos.length > 1 ? (
            <div className="flex gap-3 px-4 pt-3 pb-[max(0.75rem,env(safe-area-inset-bottom))]">
              <button
                type="button"
                className="inline-flex min-h-12 flex-1 items-center justify-center rounded-full border border-cream text-base font-medium text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-cream"
                onClick={() => step(-1)}
              >
                Previous
              </button>
              <button
                type="button"
                className="inline-flex min-h-12 flex-1 items-center justify-center rounded-full border border-cream text-base font-medium text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-cream"
                onClick={() => step(1)}
              >
                Next
              </button>
            </div>
          ) : null}
        </dialog>
      ) : null}
    </section>
  );
}
