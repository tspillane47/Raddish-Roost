"use client";

import { createContext, useContext, useMemo } from "react";
import type { Locale } from "@/lib/i18n/locale";
import type { MessageKey } from "@/lib/i18n/messages";
import { t, tf } from "@/lib/i18n/translate";

const LocaleContext = createContext<Locale>("en");

export function LocaleProvider({ locale, children }: { locale: Locale; children: React.ReactNode }) {
  return <LocaleContext.Provider value={locale}>{children}</LocaleContext.Provider>;
}

export function useLocale(): Locale {
  return useContext(LocaleContext);
}

export function Tx({ k, values }: { k: MessageKey; values?: Record<string, string | number> }) {
  const { tf } = useTranslate();
  return <>{tf(k, values)}</>;
}

export function useTranslate() {
  const locale = useLocale();
  return useMemo(
    () => ({
      locale,
      t: (key: MessageKey) => t(locale, key),
      tf: (key: MessageKey, values?: Record<string, string | number>) => tf(locale, key, values),
    }),
    [locale],
  );
}
