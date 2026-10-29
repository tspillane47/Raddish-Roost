"use client";

import { trackGuestPortalClick } from "@/lib/analytics/guest-portal-click";
import { EARLY_CHECK_IN_TEXT, EARLY_CHECK_IN_TITLE } from "@/lib/content/guest-portal";

export function EarlyArrival({
  propertySlug,
  portalUrl,
}: {
  propertySlug: string;
  portalUrl: string | null;
}) {
  return (
    <div className="mt-3 rounded-xl bg-cream px-4 py-3">
      <p className="font-heading text-xl text-charcoal">{EARLY_CHECK_IN_TITLE}</p>
      <p className="mt-2 text-base leading-7">{EARLY_CHECK_IN_TEXT}</p>
      {portalUrl ? (
        <a
          href={portalUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="mt-3 inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
          onClick={() => trackGuestPortalClick(propertySlug)}
        >
          Open Guest Portal
        </a>
      ) : null}
    </div>
  );
}
