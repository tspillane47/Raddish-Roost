"use client";

import { useRef } from "react";
import { trackBookingClick } from "@/lib/analytics/booking-click";
import type { BookingLink } from "@/lib/content/booking-links";

const CREAM = "#F7F4ED";

export function BookNow({
  propertySlug,
  bookings,
  accent,
}: {
  propertySlug: string;
  bookings: BookingLink[];
  accent: string;
}) {
  const dialogRef = useRef<HTMLDialogElement>(null);
  if (bookings.length === 0) return null;

  return (
    <>
      <button
        type="button"
        className="mt-5 inline-flex min-h-12 items-center justify-center rounded-full px-7 text-base font-semibold shadow-sm focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        style={{ backgroundColor: accent, color: CREAM }}
        aria-haspopup="dialog"
        onClick={() => openDialog(dialogRef.current)}
      >
        Book Now
      </button>
      <dialog
        ref={dialogRef}
        aria-labelledby="book-your-stay"
        className="m-0 h-dvh max-h-none w-full max-w-none overscroll-none border-0 bg-transparent p-0 backdrop:bg-charcoal/45"
        onClick={(event) => {
          const target = event.target;
          if (!(target instanceof HTMLElement)) return;
          if (target === event.currentTarget || target.dataset.dismiss === "true") {
            dialogRef.current?.close();
          }
        }}
      >
        <div data-dismiss="true" className="flex h-full items-end justify-center md:items-center">
          <div className="relative max-h-[85dvh] w-full overflow-y-auto rounded-t-3xl bg-cream pr-[max(1.25rem,env(safe-area-inset-right))] pl-[max(1.25rem,env(safe-area-inset-left))] pt-6 text-left shadow-xl md:max-w-md md:rounded-3xl md:p-6">
            <div className="flex items-start justify-between gap-4">
              <h2 id="book-your-stay" className="font-heading text-3xl text-charcoal">
                Book Your Stay
              </h2>
              <button
                type="button"
                className="inline-flex min-h-11 shrink-0 items-center rounded-full px-4 text-base text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
                onClick={() => dialogRef.current?.close()}
              >
                Close
              </button>
            </div>
            <div className="mt-5 pb-[max(1.5rem,env(safe-area-inset-bottom))] md:pb-0">
              <BookingChoices propertySlug={propertySlug} bookings={bookings} />
            </div>
          </div>
        </div>
      </dialog>
    </>
  );
}

export function BookingChoices({
  propertySlug,
  bookings,
}: {
  propertySlug: string;
  bookings: BookingLink[];
}) {
  if (bookings.length === 0) return null;

  return (
    <ul className="grid list-none gap-3 p-0">
      {bookings.map((booking) => (
        <li key={booking.channel}>
          <a
            href={booking.url}
            target="_blank"
            rel="noopener noreferrer"
            className="flex min-h-16 flex-col justify-center rounded-2xl border border-beige bg-cream px-5 py-4 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest hover:bg-beige/60"
            onClick={() => trackBookingClick(propertySlug, booking.channel)}
          >
            <span className="font-heading text-2xl text-charcoal">{booking.name}</span>
            <span className="mt-1 text-base leading-7 text-muted-foreground">{booking.detail}</span>
          </a>
        </li>
      ))}
    </ul>
  );
}

function openDialog(dialog: HTMLDialogElement | null) {
  if (!dialog || dialog.open) return;
  try {
    dialog.showModal();
  } catch {
    dialog.setAttribute("open", "");
  }
}
