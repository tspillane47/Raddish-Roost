import { propertySlugSchema } from "@/lib/validation/slug";

const RESERVED_PATHS = new Set(["contact", "privacy", "terms", "admin"]);

export function slugToReject(pathname: string, publishedSlugs: ReadonlySet<string>): string | null {
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length === 0) return null;

  let slug: string;
  try {
    slug = decodeURIComponent(parts[0]).toLowerCase();
  } catch {
    return parts[0];
  }

  if (slug.includes(".") || parts.some((part) => part.includes(".")) || RESERVED_PATHS.has(slug)) {
    return null;
  }
  const slugShaped = propertySlugSchema.safeParse(slug).success;
  if (!slugShaped) return parts.length === 1 ? slug : null;
  if (!publishedSlugs.has(slug)) return slug;
  return null;
}

export function guideSectionFromPath(pathname: string): { property: string; section: string } | null {
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length !== 3 || parts[1] !== "guide") return null;
  try {
    return {
      property: decodeURIComponent(parts[0]).toLowerCase(),
      section: decodeURIComponent(parts[2]).toLowerCase(),
    };
  } catch {
    return null;
  }
}
