import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import { propertySlugSchema } from "@/lib/validation/slug";

export type PropertyPhoto = {
  file: string;
  src: string;
  alt: string;
  width: number;
  height: number;
  sections: string[];
};

type ManifestPhoto = {
  file?: unknown;
  alt?: unknown;
  width?: unknown;
  height?: unknown;
  sections?: unknown;
};

type Manifest = {
  hero?: unknown;
  photos?: unknown;
};

const EMPTY = { hero: null, photos: [] as PropertyPhoto[] };

/**
 * Photos live in public/images/properties/{slug}/manifest.json.
 * A stay with no folder, including The Shallot Chalet and The Onion Ranch, gets none.
 */
export function getPropertyPhotos(slug: string): { hero: PropertyPhoto | null; photos: PropertyPhoto[] } {
  if (!propertySlugSchema.safeParse(slug).success) return EMPTY;

  const directory = path.join(process.cwd(), "public", "images", "properties", slug);
  const manifestPath = path.join(directory, "manifest.json");
  if (!existsSync(manifestPath)) return EMPTY;

  let manifest: Manifest;
  try {
    manifest = JSON.parse(readFileSync(manifestPath, "utf8")) as Manifest;
  } catch {
    return EMPTY;
  }

  if (!Array.isArray(manifest.photos)) return EMPTY;

  const photos = manifest.photos.flatMap((entry) => {
    const photo = entry as ManifestPhoto;
    if (!isPhotoFile(photo.file) || typeof photo.alt !== "string" || photo.alt.trim().length === 0) {
      return [];
    }
    if (!isPositiveNumber(photo.width) || !isPositiveNumber(photo.height)) return [];
    if (!existsSync(path.join(directory, photo.file))) return [];

    return [
      {
        file: photo.file,
        src: `/images/properties/${slug}/${photo.file}`,
        alt: photo.alt.trim(),
        width: photo.width,
        height: photo.height,
        sections: sectionSlugs(photo.sections),
      },
    ];
  });

  const hero = photos.find((photo) => photo.file === manifest.hero) ?? null;
  return { hero, photos };
}

export function photosForSection(slug: string, sectionSlug: string): PropertyPhoto[] {
  return getPropertyPhotos(slug).photos.filter((photo) => photo.sections.includes(sectionSlug));
}

function isPhotoFile(file: unknown): file is string {
  return typeof file === "string" && /^[a-z0-9]+(?:-[a-z0-9]+)*\.webp$/.test(file);
}

function isPositiveNumber(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value) && value > 0;
}

function sectionSlugs(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.filter((section): section is string => typeof section === "string" && section.length > 0);
}
