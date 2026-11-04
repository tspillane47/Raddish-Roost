import type { Locale } from "@/lib/i18n/locale";
import type { SiteConfig, SiteLabelKey, SiteLabelPair, SiteLabelSet } from "@/sites/types";

/** Guidebook section slug → site label key. */
export const SECTION_LABEL_KEYS: Record<string, SiteLabelKey> = {
  "check-in-checkout": "checkInCheckout",
  "check-in": "checkInCheckout",
  checkout: "checkInCheckout",
  "getting-here": "gettingHere",
  wifi: "wifi",
  "the-house": "theHouse",
  "house-guide": "theHouse",
  amenities: "theHouse",
  "house-rules": "houseRules",
  "things-to-do": "thingsToDo",
  contact: "contact",
  "stay-again": "stayAgain",
};

export function siteLabels(site: SiteConfig, locale: Locale = "en"): SiteLabelSet | null {
  if (!site.labels) return null;
  return site.labels[locale] ?? site.labels.en ?? null;
}

export function siteLabel(
  site: SiteConfig,
  key: SiteLabelKey,
  locale: Locale = "en",
): SiteLabelPair | null {
  const set = siteLabels(site, locale);
  return set?.[key] ?? null;
}

export function sectionLabel(
  site: SiteConfig,
  sectionSlug: string,
  locale: Locale = "en",
): SiteLabelPair | null {
  const key = SECTION_LABEL_KEYS[sectionSlug];
  if (!key) return null;
  return siteLabel(site, key, locale);
}

export function checkoutStamp(site: SiteConfig, locale: Locale = "en"): string | null {
  return siteLabels(site, locale)?.checkoutStamp ?? null;
}
