"use client";

import { trackLateCheckoutClick } from "@/lib/analytics/late-checkout-click";
import { LATE_CHECKOUT_TEXT, LATE_CHECKOUT_TITLE } from "@/lib/content/guest-portal";

export function LateCheckout({
  propertySlug,
  portalUrl,
}: {
  propertySlug: string;
  portalUrl: string | null;
}) {
  return (
    <div className="mt-3 rounded-xl bg-cream px-4 py-3">
      <p className="font-heading text-xl text-charcoal">{LATE_CHECKOUT_TITLE}</p>
      <p className="mt-2 text-base leading-7">{LATE_CHECKOUT_TEXT}</p>
      {portalUrl ? (
        <a
          href={portalUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="mt-3 inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
          onClick={() => trackLateCheckoutClick(propertySlug)}
        >
          Request Late Checkout
        </a>
      ) : null}
    </div>
  );
}
