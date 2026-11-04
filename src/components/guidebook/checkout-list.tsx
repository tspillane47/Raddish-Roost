"use client";

import { useState } from "react";
import { useLocale, useTranslate } from "@/lib/i18n/locale-context";
import { checkoutStamp, siteLabel } from "@/sites/labels";
import { useSiteConfig } from "@/sites/site-context";
import type { CheckoutTask } from "@/types/content";

export function CheckoutList({ items }: { items: CheckoutTask[] }) {
  const { t } = useTranslate();
  const locale = useLocale();
  const site = useSiteConfig();
  const intro = siteLabel(site, "checkoutIntro", locale);
  const stamp = checkoutStamp(site, locale);
  const [done, setDone] = useState<Record<string, boolean>>({});
  if (items.length === 0) return null;
  const finished = items.every((item) => done[item.id] === true);

  return (
    <section id="checkout-list" aria-labelledby="checkout-list-heading" className="scroll-mt-[var(--site-header)]">
      {intro ? (
        <>
          <h2 id="checkout-list-heading" className="font-heading text-2xl text-charcoal">
            {intro.themed}
          </h2>
          <p className="mt-1 font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm tracking-wide text-muted-foreground">
            {intro.plain}
          </p>
        </>
      ) : (
        <h2 id="checkout-list-heading" className="font-heading text-2xl text-charcoal">
          {t("checkoutChecklist")}
        </h2>
      )}
      <ul className="mt-4 grid list-none gap-3 p-0">
        {items.map((item) => {
          const checked = done[item.id] === true;
          return (
            <li key={item.id}>
              <label className="flex min-h-11 cursor-pointer items-start gap-3 rounded-xl border border-beige px-4 py-3 text-base leading-7">
                <input
                  type="checkbox"
                  className="mt-1 size-5 shrink-0 accent-forest"
                  checked={checked}
                  onChange={() => setDone((current) => ({ ...current, [item.id]: !current[item.id] }))}
                />
                <span>
                  <span className={checked ? "text-muted-foreground line-through" : undefined}>{item.label}</span>
                  {item.detail ? <span className="mt-1 block text-base leading-7">{item.detail}</span> : null}
                </span>
              </label>
            </li>
          );
        })}
      </ul>
      <div className="mt-4 flex flex-wrap items-start gap-4">
        <p role={finished ? "status" : undefined} className="min-w-0 flex-1 text-base leading-7">
          {t("reviewNote")}
        </p>
        {finished && stamp ? (
          <p
            role="status"
            className="shrink-0 rotate-[-12deg] border-[3px] border-terracotta px-3 py-2 font-[family-name:var(--font-dad-typewriter,ui-monospace,monospace)] text-sm font-bold tracking-[0.18em] text-terracotta motion-reduce:rotate-0"
          >
            {stamp}
          </p>
        ) : null}
      </div>
    </section>
  );
}
