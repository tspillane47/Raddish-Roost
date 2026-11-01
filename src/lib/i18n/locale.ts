export const LOCALES = ["en", "es", "fr"] as const;

export type Locale = (typeof LOCALES)[number];

export const LOCALE_COOKIE = "rr_lang";

export const LOCALE_HEADER = "x-rr-lang";

const YEAR = 60 * 60 * 24 * 365;

export function isLocale(value: string | null | undefined): value is Locale {
  return value === "en" || value === "es" || value === "fr";
}

export function parseLocale(value: string | null | undefined): Locale {
  return isLocale(value) ? value : "en";
}

/** First visit: Spanish or French when that is the browser language. Otherwise English. */
export function localeFromAcceptLanguage(header: string | null | undefined): Locale {
  if (!header) return "en";
  const ranked = header
    .split(",")
    .map((part) => {
      const [tag, ...params] = part.trim().split(";");
      const qualityParam = params.find((param) => param.trim().toLowerCase().startsWith("q="));
      const quality = qualityParam ? Number(qualityParam.split("=")[1]) : 1;
      return { tag: tag.trim().toLowerCase(), quality };
    })
    .filter((part) => part.tag && Number.isFinite(part.quality))
    .sort((a, b) => b.quality - a.quality);

  for (const part of ranked) {
    if (part.tag.startsWith("es")) return "es";
    if (part.tag.startsWith("fr")) return "fr";
    if (part.tag.startsWith("en")) return "en";
  }
  return "en";
}

export function requestLocale(cookieValue: string | null | undefined, acceptLanguage: string | null | undefined): Locale {
  if (isLocale(cookieValue)) return cookieValue;
  return localeFromAcceptLanguage(acceptLanguage);
}

export function localeCookie(locale: Locale): string {
  return `${LOCALE_COOKIE}=${locale}; Path=/; Max-Age=${YEAR}; SameSite=Lax`;
}

export function intlLocale(locale: Locale): string {
  if (locale === "es") return "es";
  if (locale === "fr") return "fr";
  return "en-US";
}
