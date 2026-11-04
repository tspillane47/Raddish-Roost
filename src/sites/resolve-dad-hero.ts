import "server-only";
import { existsSync } from "node:fs";
import path from "node:path";
import type { SiteHero } from "@/sites/types";

/** Prefer getaway-car art when present; otherwise keep the current dad hero. */
export function resolveDadHero(fallback: SiteHero): SiteHero {
  const getawayPath = path.join(process.cwd(), "public/sites/dad/hero-getaway.webp");
  if (!existsSync(getawayPath)) return fallback;
  return {
    src: "/sites/dad/hero-getaway.webp",
    width: fallback.width,
    height: fallback.height,
    alt: "Vintage getaway-car travel poster for The Getaway Club",
  };
}
