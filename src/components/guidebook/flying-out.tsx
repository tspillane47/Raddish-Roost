"use client";

import { Plane } from "lucide-react";
import { trackLateCheckoutClick } from "@/lib/analytics/late-checkout-click";
import { flyingOutDriveKey } from "@/lib/content/flying-out";
import { useTranslate } from "@/lib/i18n/locale-context";

export function FlyingOut({
  propertySlug,
  portalUrl,
}: {
  propertySlug: string;
  portalUrl: string | null;
}) {
  const { t } = useTranslate();
  const driveKey = flyingOutDriveKey(propertySlug);
  if (!driveKey) return null;

  return (
    <section id="flying-out" aria-labelledby="flying-out-heading" className="scroll-mt-[var(--site-header)]">
      <h2 id="flying-out-heading" className="font-heading text-2xl text-charcoal">
        {t("flyingOutTitle")}
      </h2>
      <div className="mt-4 rounded-xl bg-beige/50 p-4">
        <div className="flex items-start gap-3">
          <Plane className="size-6 shrink-0 text-forest" aria-hidden strokeWidth={1.75} />
          <div className="min-w-0 flex-1">
            <p className="text-lg leading-8 text-charcoal">{t(driveKey)}</p>
            <p className="mt-2 text-base leading-7">{t("flyingOutBody")}</p>
            <p className="mt-2 text-base leading-7">{t("flyingOutSnow")}</p>
            {portalUrl ? (
              <p className="mt-3 text-base leading-7">
                <a
                  href={portalUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="font-medium text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
                  onClick={() => trackLateCheckoutClick(propertySlug)}
                >
                  {t("flyingOutLateTip")}
                </a>
              </p>
            ) : (
              <p className="mt-3 text-base leading-7 text-charcoal/80">{t("flyingOutLateTipNoPortal")}</p>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
