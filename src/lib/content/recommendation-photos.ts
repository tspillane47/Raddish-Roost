import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

export type RecommendationPhoto = { src: string; alt: string };

type ManifestPhoto = { name?: unknown; file?: unknown; alt?: unknown };

const PHOTO_FILE = /^[a-z0-9]+(?:-[a-z0-9]+)*\.webp$/;

/**
 * Photos are optional. Add one by dropping a WebP in public/images/recommendations/
 * and listing it in manifest.json:
 * { "photos": [{ "name": "Place name", "file": "place-name.webp", "alt": "What the photo shows." }] }
 */
export function recommendationPhoto(name: string): RecommendationPhoto | null {
  const directory = path.join(process.cwd(), "public", "images", "recommendations");
  const manifestPath = path.join(directory, "manifest.json");
  if (!existsSync(manifestPath)) return null;

  let manifest: { photos?: unknown };
  try {
    manifest = JSON.parse(readFileSync(manifestPath, "utf8")) as { photos?: unknown };
  } catch {
    return null;
  }

  return photoFromManifest(manifest.photos, name, (file) => existsSync(path.join(directory, file)));
}

export function photoFromManifest(
  photos: unknown,
  name: string,
  fileExists: (file: string) => boolean,
): RecommendationPhoto | null {
  if (!Array.isArray(photos)) return null;
  const match = photos.find((entry) => {
    const photo = entry as ManifestPhoto;
    return typeof photo.name === "string" && photo.name.trim() === name.trim();
  }) as ManifestPhoto | undefined;
  if (!match) return null;
  if (typeof match.file !== "string" || !PHOTO_FILE.test(match.file)) return null;
  if (typeof match.alt !== "string" || match.alt.trim().length === 0) return null;
  if (!fileExists(match.file)) return null;
  return { src: `/images/recommendations/${match.file}`, alt: match.alt.trim() };
}
