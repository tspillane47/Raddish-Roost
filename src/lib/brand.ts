import { getSiteConfig, roostSite } from "@/sites";

/** Roost defaults kept for tests and fallbacks. Prefer getSiteConfig() at runtime. */
export const DEFAULT_BRAND_NAME = roostSite.name;

export const BRAND_COLORS = roostSite.colors;

export function brandNameFromValue(value: unknown, fallback = getSiteConfig().name): string {
  if (typeof value === "string") {
    const trimmed = value.trim();
    if (trimmed.length > 0 && trimmed.length <= 80) return trimmed;
  }
  return fallback;
}
