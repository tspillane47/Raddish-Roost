"use client";

import { useState } from "react";
import { REVIEW_NOTE } from "@/lib/content/guest-note";
import type { CheckoutTask } from "@/types/content";

export function CheckoutList({ items }: { items: CheckoutTask[] }) {
  const [done, setDone] = useState<Record<string, boolean>>({});
  if (items.length === 0) return null;
  const finished = items.every((item) => done[item.id] === true);

  return (
    <section id="checkout-list" aria-labelledby="checkout-list-heading" className="scroll-mt-[var(--site-header)]">
      <h2 id="checkout-list-heading" className="font-heading text-2xl text-charcoal">
        Checkout checklist
      </h2>
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
      <p role={finished ? "status" : undefined} className="mt-4 text-base leading-7">
        {REVIEW_NOTE}
      </p>
    </section>
  );
}
