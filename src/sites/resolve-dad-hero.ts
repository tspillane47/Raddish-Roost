import "server-only";
import { existsSync } from "node:fs";
import path from "node:path";
import { DAD_GETAWAY_HERO } from "@/sites/dad-hero";
import type { SiteHero } from "@/sites/types";

/** Prefer getaway-car art when present; otherwise keep the current dad hero. */
export function resolveDadHero(fallback: SiteHero): SiteHero {
  const getawayPath = path.join(process.cwd(), "public", DAD_GETAWAY_HERO.src.replace(/^\//, ""));
  if (!existsSync(getawayPath)) return fallback;
  return { ...DAD_GETAWAY_HERO };
}
