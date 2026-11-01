"use client";

import { trackLateCheckoutClick } from "@/lib/analytics/late-checkout-click";
import { useTranslate } from "@/lib/i18n/locale-context";

export function LateCheckout({
  propertySlug,
  portalUrl,
}: {
  propertySlug: string;
  portalUrl: string | null;
}) {
  const { t } = useTranslate();
  return (
    <div className="mt-3 rounded-xl bg-cream px-4 py-3">
      <p className="font-heading text-xl text-charcoal">{t("lateCheckoutTitle")}</p>
      <p className="mt-2 text-base leading-7">{t("lateCheckoutText")}</p>
      {portalUrl ? (
        <a
          href={portalUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="mt-3 inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
          onClick={() => trackLateCheckoutClick(propertySlug)}
        >
          {t("requestLateCheckout")}
        </a>
      ) : null}
    </div>
  );
}
