import { propertySlugSchema } from "@/lib/validation/slug";

const RESERVED_PATHS = new Set(["contact", "privacy", "terms", "admin"]);

export function singlePathSegment(pathname: string): string | null {
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length !== 1) return null;
  try {
    return decodeURIComponent(parts[0]).toLowerCase();
  } catch {
    return null;
  }
}

export function slugToReject(pathname: string, publishedSlugs: ReadonlySet<string>): string | null {
  const slug = singlePathSegment(pathname);
  if (!slug || slug.includes(".") || RESERVED_PATHS.has(slug)) return null;
  if (!propertySlugSchema.safeParse(slug).success || !publishedSlugs.has(slug)) return slug;
  return null;
}
