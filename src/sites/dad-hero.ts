import type { SiteHero } from "@/sites/types";

/**
 * Getaway-car homepage hero for The Getaway Club.
 * The wagon sits slightly right of center; focus keeps it in frame if cropped.
 */
export const DAD_GETAWAY_HERO: SiteHero = {
  src: "/sites/dad/hero-getaway.webp",
  width: 2172,
  height: 724,
  alt: "Vintage green station wagon packed for a getaway, with Vermont autumn on the left and a Sanibel beach on the right",
};

/** CSS object-position for the getaway wagon on narrow screens. */
export const DAD_GETAWAY_HERO_FOCUS = "50% 48%";
