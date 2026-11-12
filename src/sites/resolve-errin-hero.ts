import { existsSync } from "node:fs";
import path from "node:path";
import type { SiteHero } from "@/sites/types";

/** Prefer a real hero.webp when present; otherwise the homepage draws the SVG scene. */
export function errinHeroFileExists(hero: SiteHero): boolean {
  const relative = hero.src.replace(/^\//, "");
  return existsSync(path.join(process.cwd(), "public", relative));
}
