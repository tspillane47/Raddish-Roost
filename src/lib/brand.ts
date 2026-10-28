export const DEFAULT_BRAND_NAME = "The Vermont Roost Collection";

export const BRAND_COLORS = {
  forest: "#263F35",
  sage: "#A8B7A0",
  cream: "#F7F4ED",
  charcoal: "#262626",
  beige: "#DDD3C4",
  terracotta: "#B97759",
  muted: "#3E4A43",
} as const;

export function brandNameFromValue(value: unknown): string {
  if (typeof value === "string") {
    const trimmed = value.trim();
    if (trimmed.length > 0 && trimmed.length <= 80) return trimmed;
  }
  return DEFAULT_BRAND_NAME;
}
