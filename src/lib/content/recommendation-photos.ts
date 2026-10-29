import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

export type PhotoCredit = { author: string; license: string; url: string };

export type RecommendationPhoto = { src: string; alt: string; credit: PhotoCredit | null };

type ManifestPhoto = { name?: unknown; file?: unknown; alt?: unknown };
type CreditEntry = {
  file?: unknown;
  sourceUrl?: unknown;
  author?: unknown;
  license?: unknown;
  attributionRequired?: unknown;
};

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
  let credits: unknown = null;
  try {
    manifest = JSON.parse(readFileSync(manifestPath, "utf8")) as { photos?: unknown };
  } catch {
    return null;
  }
  const creditsPath = path.join(directory, "credits.json");
  if (existsSync(creditsPath)) {
    try {
      credits = JSON.parse(readFileSync(creditsPath, "utf8"));
    } catch {
      credits = null;
    }
  }

  return photoFromManifest(
    manifest.photos,
    name,
    (file) => existsSync(path.join(directory, file)),
    credits,
  );
}

export function photoFromManifest(
  photos: unknown,
  name: string,
  fileExists: (file: string) => boolean,
  credits?: unknown,
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
  return {
    src: `/images/recommendations/${match.file}`,
    alt: match.alt.trim(),
    credit: creditForFile(credits, match.file),
  };
}

/** CC BY and CC BY-SA need a visible credit. Public domain and CC0 stay in credits.json only. */
export function creditForFile(credits: unknown, file: string): PhotoCredit | null {
  const photos = credits && typeof credits === "object" ? (credits as { photos?: unknown }).photos : null;
  if (!Array.isArray(photos)) return null;
  const match = photos.find((entry) => (entry as CreditEntry).file === file) as CreditEntry | undefined;
  if (!match || match.attributionRequired !== true) return null;
  if (typeof match.author !== "string" || match.author.trim().length === 0) return null;
  if (typeof match.license !== "string" || match.license.trim().length === 0) return null;
  if (typeof match.sourceUrl !== "string" || !match.sourceUrl.startsWith("https://")) return null;
  return { author: match.author.trim(), license: match.license.trim(), url: match.sourceUrl };
}
