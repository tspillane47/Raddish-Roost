import { LEGACY_SECTION_REDIRECTS } from "@/lib/content/sections";
import { guideSectionFromPath } from "@/lib/routing/property-path";

/** Where an old guidebook or Explore address should go, once that section exists. */
export function guideRedirectRequest(pathname: string): { property: string; section: string } | null {
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length === 2 && parts[1]?.toLowerCase() === "explore") {
    try {
      return { property: decodeURIComponent(parts[0] ?? "").toLowerCase(), section: "things-to-do" };
    } catch {
      return null;
    }
  }

  const guide = guideSectionFromPath(pathname);
  if (!guide) return null;
  const section = LEGACY_SECTION_REDIRECTS[guide.section];
  if (!section) return null;
  return { property: guide.property, section };
}
