"use client";

import { KeyRound, LockKeyhole, Car, PawPrint, Ban, Shirt, Thermometer } from "lucide-react";
import {
  entryLabelKey,
  laundryLabelKey,
  petsLabelKey,
  stayGlanceFor,
} from "@/lib/content/stay-glance";
import { useTranslate } from "@/lib/i18n/locale-context";

export function StayGlance({ propertySlug }: { propertySlug: string }) {
  const { t } = useTranslate();
  const glance = stayGlanceFor(propertySlug);
  if (!glance) return null;

  const EntryIcon = glance.entry === "lockbox" ? LockKeyhole : KeyRound;
  const PetsIcon = glance.pets ? PawPrint : Ban;

  const items = [
    { icon: EntryIcon, label: t(entryLabelKey(glance.entry)) },
    { icon: Car, label: t(glance.parkingKey) },
    { icon: PetsIcon, label: t(petsLabelKey(glance.pets)) },
    { icon: Shirt, label: t(laundryLabelKey(glance.laundry)) },
    { icon: Thermometer, label: t("glanceThermostat") },
  ];

  return (
    <section aria-labelledby="at-a-glance-heading" className="mt-8">
      <h2
        id="at-a-glance-heading"
        className="font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm font-semibold uppercase tracking-[0.18em] text-forest"
      >
        {t("atAGlance")}
      </h2>
      <ul className="mt-3 grid list-none grid-cols-2 gap-2 p-0 sm:grid-cols-3 md:grid-cols-5">
        {items.map((item) => (
          <li
            key={item.label}
            className="flex items-start gap-2 rounded-sm border border-dashed border-terracotta/40 bg-beige/60 px-3 py-2.5"
          >
            <item.icon className="mt-0.5 size-4 shrink-0 text-forest" aria-hidden strokeWidth={1.75} />
            <span className="font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-xs leading-5 tracking-wide text-charcoal">
              {item.label}
            </span>
          </li>
        ))}
      </ul>
    </section>
  );
}
