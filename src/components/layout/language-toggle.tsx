"use client";

import { useEffect, useState, useTransition } from "react";
import { LOCALES, type Locale } from "@/lib/i18n/locale";
import { useTranslate } from "@/lib/i18n/locale-context";
import { setLocale } from "@/lib/i18n/set-locale";

export function LanguageToggle() {
  const { locale, t } = useTranslate();
  const [pendingLocale, setPendingLocale] = useState<Locale | null>(null);
  const [, startTransition] = useTransition();
  const active = pendingLocale ?? locale;

  useEffect(() => {
    if (pendingLocale && locale === pendingLocale) {
      setPendingLocale(null);
    }
  }, [locale, pendingLocale]);

  function choose(next: Locale) {
    if (next === active) return;
    setPendingLocale(next);
    startTransition(async () => {
      try {
        await setLocale(next);
      } catch {
        setPendingLocale(null);
      }
    });
  }

  return (
    <div role="group" aria-label={t("language")} className="flex shrink-0 items-center">
      {LOCALES.map((code, index) => (
        <span key={code} className="flex items-center">
          {index > 0 ? (
            <span aria-hidden="true" className="text-sm text-forest/40">
              |
            </span>
          ) : null}
          <button
            type="button"
            aria-pressed={active === code}
            onClick={() => choose(code)}
            className={`inline-flex size-11 items-center justify-center rounded-full text-sm font-semibold uppercase focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest ${
              active === code ? "bg-forest text-cream" : "text-forest"
            }`}
          >
            {code}
          </button>
        </span>
      ))}
    </div>
  );
}
