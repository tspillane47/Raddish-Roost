"use client";

import { Cross, Fuel, Hospital, Pill, Store } from "lucide-react";
import type { NearbyEssential, NearbyKind } from "@/lib/content/nearby";
import { messages, type MessageKey } from "@/lib/i18n/messages";
import { useTranslate } from "@/lib/i18n/locale-context";

const KIND_KEYS: Record<NearbyKind, MessageKey> = {
  grocery: "grocery",
  pharmacy: "pharmacy",
  gas: "gas",
  urgent_care: "urgentCare",
  hospital: "hospital",
};

export function NearbyEssentials({ items }: { items: NearbyEssential[] }) {
  const { t } = useTranslate();
  if (items.length === 0) return null;
  return (
    <section id="nearby-essentials" aria-labelledby="nearby-essentials-heading" className="scroll-mt-[var(--site-header)]">
      <h2 id="nearby-essentials-heading" className="font-heading text-2xl text-charcoal">
        {t("nearbyEssentials")}
      </h2>
      <ul className="mt-4 grid list-none gap-3 p-0">
        {items.map((item) => (
          <li key={item.id} className="rounded-xl bg-beige/50 p-4">
            <div className="flex items-start gap-3">
              <NearbyIcon kind={item.kind} />
              <div className="min-w-0 flex-1">
                <p className="text-lg leading-8 text-charcoal">{labelFor(item, t)}</p>
                {item.placeName ? <p className="text-base leading-7">{item.placeName}</p> : null}
                {item.note ? <p className="mt-1 text-base leading-7">{noteFor(item, t)}</p> : null}
              </div>
            </div>
            <p className="mt-3">
              <a
                href={item.href}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
              >
                {t("findNearest")}
              </a>
            </p>
          </li>
        ))}
      </ul>
    </section>
  );
}

function labelFor(item: NearbyEssential, translate: (key: MessageKey) => string) {
  const key = KIND_KEYS[item.kind];
  if (key && item.label === messages.en[key]) return translate(key);
  return item.label;
}

function noteFor(item: NearbyEssential, translate: (key: MessageKey) => string) {
  if (item.note === messages.en.hospitalNote) return translate("hospitalNote");
  return item.note;
}

function NearbyIcon({ kind }: { kind: NearbyKind }) {
  const props = { className: "size-6 shrink-0 text-forest", "aria-hidden": true as const, strokeWidth: 1.75 };
  if (kind === "grocery") return <Store {...props} />;
  if (kind === "pharmacy") return <Pill {...props} />;
  if (kind === "gas") return <Fuel {...props} />;
  if (kind === "urgent_care") return <Cross {...props} />;
  return <Hospital {...props} />;
}
