"use client";

import { useRef } from "react";
import { LuggageTagIcon } from "@/components/dad/heist-icons";
import { trackBookingClick } from "@/lib/analytics/booking-click";
import type { BookingChannel, BookingLink } from "@/lib/content/booking-links";
import { useLocale, useTranslate } from "@/lib/i18n/locale-context";
import type { MessageKey } from "@/lib/i18n/messages";
import { siteLabel } from "@/sites/labels";
import { useSiteConfig } from "@/sites/site-context";

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
  const { t } = useTranslate();
  const locale = useLocale();
  const site = useSiteConfig();
  const bookLabel = siteLabel(site, "bookNow", locale);
  const stayAgain = siteLabel(site, "stayAgain", locale);
  if (bookings.length === 0) return null;
  const rounded = site.key === "dad" ? "rounded-sm" : "rounded-full";

  return (
    <>
      <button
        type="button"
        className={`mt-5 inline-flex min-h-12 flex-col items-center justify-center ${rounded} px-7 text-base font-semibold shadow-sm focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest`}
        style={{ backgroundColor: accent, color: CREAM }}
        aria-haspopup="dialog"
        onClick={() => openDialog(dialogRef.current)}
      >
        <span className="inline-flex items-center gap-2">
          {site.key === "dad" ? <LuggageTagIcon className="size-4 shrink-0" /> : null}
          {bookLabel?.themed ?? t("bookNow")}
        </span>
        {bookLabel ? (
          <span className="mt-0.5 font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-xs font-normal normal-case tracking-wide opacity-90">
            {bookLabel.plain}
          </span>
        ) : null}
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
                {stayAgain?.themed ?? t("bookYourStay")}
                {stayAgain ? (
                  <span className="mt-1 block font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm font-normal tracking-wide text-muted-foreground">
                    {stayAgain.plain}
                  </span>
                ) : null}
              </h2>
              <button
                type="button"
                className="inline-flex min-h-11 shrink-0 items-center rounded-full px-4 text-base text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
                onClick={() => dialogRef.current?.close()}
              >
                {t("close")}
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
  const { t } = useTranslate();
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
            <span className="font-heading text-2xl text-charcoal">{bookingLabel(booking.channel, booking.name, t)}</span>
            <span className="mt-1 text-base leading-7 text-muted-foreground">{bookingDetail(booking.channel, booking.detail, t)}</span>
          </a>
        </li>
      ))}
    </ul>
  );
}

function bookingLabel(channel: BookingChannel, fallback: string, translate: (key: MessageKey) => string) {
  if (channel === "direct") return translate("bookDirect");
  return fallback;
}

function bookingDetail(channel: BookingChannel, fallback: string, translate: (key: MessageKey) => string) {
  if (channel === "direct") return translate("bookDirectDetail");
  if (channel === "airbnb") return translate("bookAirbnbDetail");
  if (channel === "vrbo") return translate("bookVrboDetail");
  return fallback;
}

function openDialog(dialog: HTMLDialogElement | null) {
  if (!dialog || dialog.open) return;
  try {
    dialog.showModal();
  } catch {
    dialog.setAttribute("open", "");
  }
}
