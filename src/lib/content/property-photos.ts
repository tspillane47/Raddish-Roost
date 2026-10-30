import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import type { PhotoFocus } from "@/lib/content/photo-focus";
import { propertySlugSchema } from "@/lib/validation/slug";

export type { PhotoFocus } from "@/lib/content/photo-focus";
export { photoObjectPosition } from "@/lib/content/photo-focus";

export type PropertyPhoto = {
  file: string;
  src: string;
  alt: string;
  width: number;
  height: number;
  sections: string[];
  group: string | null;
  focus: PhotoFocus;
};

export type PhotoGroup = {
  id: string;
  label: string;
  preview: string[];
};

export type PhotoSet = {
  id: string;
  label: string;
  photos: PropertyPhoto[];
};

type ManifestPhoto = {
  file?: unknown;
  alt?: unknown;
  width?: unknown;
  height?: unknown;
  sections?: unknown;
  group?: unknown;
  focus?: unknown;
};

type ManifestGroup = {
  id?: unknown;
  label?: unknown;
  preview?: unknown;
};

type Manifest = {
  hero?: unknown;
  heroPhotos?: unknown;
  photos?: unknown;
  groups?: unknown;
};

const DEFAULT_GROUPS: PhotoGroup[] = [
  { id: "living", label: "Living Spaces", preview: [] },
  { id: "kitchen-dining", label: "Kitchen and Dining", preview: [] },
  { id: "bedrooms", label: "Bedrooms", preview: [] },
  { id: "bath-laundry", label: "Bath and Laundry", preview: [] },
  { id: "outside", label: "Outside and Around Town", preview: [] },
];

const EMPTY = {
  hero: null,
  heroPhotos: [] as PropertyPhoto[],
  photos: [] as PropertyPhoto[],
  groups: [] as PhotoGroup[],
};

/**
 * Photos live in public/images/properties/{slug}/manifest.json.
 * A stay with no folder gets none.
 */
export function getPropertyPhotos(slug: string): {
  hero: PropertyPhoto | null;
  heroPhotos: PropertyPhoto[];
  photos: PropertyPhoto[];
  groups: PhotoGroup[];
} {
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
        group: isSlug(photo.group) ? photo.group : null,
        focus: photoFocus(photo.focus),
      },
    ];
  });

  const groups = parseGroups(manifest.groups);
  const hero = photos.find((photo) => photo.file === manifest.hero) ?? null;
  const listed = Array.isArray(manifest.heroPhotos) ? manifest.heroPhotos.filter(isPhotoFile) : [];
  const heroPhotos = chooseHeroPhotos(photos, listed, typeof manifest.hero === "string" ? manifest.hero : null);
  return { hero, heroPhotos, photos, groups };
}

/** Up to three banner photos. A short gallery uses what it has. */
export function chooseHeroPhotos(
  photos: PropertyPhoto[],
  listed: string[],
  heroFile: string | null,
): PropertyPhoto[] {
  const fromList = listed
    .flatMap((file) => photos.find((photo) => photo.file === file) ?? [])
    .slice(0, 3);
  if (fromList.length > 0) return fromList;

  const hero = photos.find((photo) => photo.file === heroFile) ?? null;
  const rest = photos.filter((photo) => photo.file !== hero?.file);
  return [hero, ...rest].filter((photo): photo is PropertyPhoto => photo !== null).slice(0, 3);
}

const SECTION_PHOTO_ALIASES: Record<string, readonly string[]> = {
  "check-in-checkout": ["check-in", "checkout"],
  "the-house": ["house-guide", "amenities"],
  "getting-here": ["parking"],
  "things-to-do": ["local-recommendations", "recommendations"],
};

export function photosForSection(slug: string, sectionSlug: string): PropertyPhoto[] {
  const names = new Set([sectionSlug, ...(SECTION_PHOTO_ALIASES[sectionSlug] ?? [])]);
  return getPropertyPhotos(slug).photos.filter((photo) => photo.sections.some((section) => names.has(section)));
}

/** Labeled preview sets for the property page. Other stays opt in by filling manifest.json. */
export function photoSets(slug: string): PhotoSet[] {
  const gallery = getPropertyPhotos(slug);
  if (gallery.photos.length === 0) return [];

  const groups = gallery.groups.length > 0 ? gallery.groups : groupsFromPhotos(gallery.photos);
  const heroFiles = new Set(gallery.heroPhotos.map((photo) => photo.file));
  return groups.flatMap((group) => {
    const members = gallery.photos.filter((photo) => photo.group === group.id);
    const listed =
      group.preview.length > 0
        ? group.preview.flatMap((file) => members.find((photo) => photo.file === file) ?? [])
        : members.slice(0, 2);
    const nonHero = listed.filter((photo) => !heroFiles.has(photo.file));
    const heroOnes = listed.filter((photo) => heroFiles.has(photo.file));
    const chosen = listed.length > 0 ? [...nonHero, ...heroOnes] : members.slice(0, 2);
    if (chosen.length === 0) return [];
    return [{ id: group.id, label: group.label, photos: chosen }];
  });
}

function groupsFromPhotos(photos: PropertyPhoto[]): PhotoGroup[] {
  return DEFAULT_GROUPS.filter((group) => photos.some((photo) => photo.group === group.id));
}

function parseGroups(value: unknown): PhotoGroup[] {
  if (!Array.isArray(value)) return [];
  return value.flatMap((entry) => {
    const group = entry as ManifestGroup;
    if (!isSlug(group.id) || typeof group.label !== "string" || group.label.trim().length === 0) return [];
    const preview = Array.isArray(group.preview) ? group.preview.filter(isPhotoFile) : [];
    return [{ id: group.id, label: group.label.trim(), preview }];
  });
}

function isPhotoFile(file: unknown): file is string {
  return typeof file === "string" && /^[a-z0-9]+(?:-[a-z0-9]+)*\.webp$/.test(file);
}

function isSlug(value: unknown): value is string {
  return typeof value === "string" && /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(value);
}

function photoFocus(value: unknown): PhotoFocus {
  if (value === "top" || value === "bottom" || value === "center") return value;
  return "center";
}

function isPositiveNumber(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value) && value > 0;
}

function sectionSlugs(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.filter((section): section is string => typeof section === "string" && section.length > 0);
}
