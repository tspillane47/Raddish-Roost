"use client";

import { useRouter } from "next/navigation";
import { LOCALES, localeCookie, type Locale } from "@/lib/i18n/locale";
import { useTranslate } from "@/lib/i18n/locale-context";

export function LanguageToggle() {
  const router = useRouter();
  const { locale, t } = useTranslate();

  function choose(next: Locale) {
    if (next === locale) return;
    document.cookie = localeCookie(next);
    router.refresh();
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
            aria-pressed={locale === code}
            onClick={() => choose(code)}
            className={`inline-flex size-11 items-center justify-center rounded-full text-sm font-semibold uppercase focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest ${
              locale === code ? "bg-forest text-cream" : "text-forest"
            }`}
          >
            {code}
          </button>
        </span>
      ))}
    </div>
  );
}
