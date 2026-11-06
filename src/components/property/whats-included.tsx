"use client";

import { Bike, Ship, Anchor } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { hasWhatsIncluded } from "@/lib/content/stay-glance";
import type { MessageKey } from "@/lib/i18n/messages";
import { useTranslate } from "@/lib/i18n/locale-context";

const ITEMS: { icon: LucideIcon; title: MessageKey; detail: MessageKey }[] = [
  { icon: Ship, title: "includedKayak", detail: "includedKayakDetail" },
  { icon: Bike, title: "includedBikes", detail: "includedBikesDetail" },
  { icon: Anchor, title: "includedBoatSlip", detail: "includedBoatSlipDetail" },
];

export function WhatsIncluded({ propertySlug }: { propertySlug: string }) {
  const { t } = useTranslate();
  if (!hasWhatsIncluded(propertySlug)) return null;

  return (
    <section aria-labelledby="whats-included-heading">
      <h2 id="whats-included-heading" className="font-heading text-3xl text-charcoal">
        {t("whatsIncluded")}
      </h2>
      <ul className="mt-4 grid list-none gap-3 p-0">
        {ITEMS.map((item) => (
          <li
            key={item.title}
            className="flex gap-3 rounded-sm border border-dashed border-terracotta/40 bg-beige/60 px-4 py-3"
          >
            <item.icon className="mt-1 size-5 shrink-0 text-forest" aria-hidden strokeWidth={1.75} />
            <div className="min-w-0">
              <p className="font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm font-semibold uppercase tracking-[0.12em] text-forest">
                {t(item.title)}
              </p>
              <p className="mt-1 text-base leading-7 text-charcoal">{t(item.detail)}</p>
            </div>
          </li>
        ))}
      </ul>
    </section>
  );
}
