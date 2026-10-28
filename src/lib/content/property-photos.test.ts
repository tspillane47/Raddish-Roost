import { readdirSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { getPropertyPhotos, photosForSection, photoSets } from "@/lib/content/property-photos";

describe("property photos", () => {
  it("loads The Raddish Roost gallery from its folder", () => {
    const { hero, photos } = getPropertyPhotos("raddish-roost");
    const directory = path.join(process.cwd(), "public/images/properties/raddish-roost");
    const files = readdirSync(directory)
      .filter((file) => file.endsWith(".webp"))
      .sort();

    expect(hero?.file).toBe("front-of-house.webp");
    expect(hero?.src).toBe("/images/properties/raddish-roost/front-of-house.webp");
    expect(photos.map((photo) => photo.file).sort()).toEqual(files);
    expect(photos.length).toBeGreaterThan(0);

    for (const photo of photos) {
      expect(photo.alt.length).toBeGreaterThan(20);
      expect(photo.alt).not.toMatch(/—|–/);
      expect(photo.width).toBeLessThanOrEqual(1600);
      expect(photo.alt.toLowerCase()).not.toMatch(/keypad|lockbox|door code/);
    }
  });

  it("matches photos to guidebook sections", () => {
    expect(photosForSection("raddish-roost", "house-guide").map((photo) => photo.file)).toEqual([
      "kitchen.webp",
      "gas-stove.webp",
      "bathroom.webp",
      "stairs.webp",
    ]);
    expect(photosForSection("raddish-roost", "amenities").map((photo) => photo.file)).toEqual([
      "front-of-house.webp",
      "laundry-room.webp",
    ]);
    expect(photosForSection("raddish-roost", "getting-here").map((photo) => photo.file)).toContain(
      "front-and-driveway.webp",
    );
    expect(photosForSection("raddish-roost", "wifi").map((photo) => photo.file)).toEqual(["living-room.webp"]);
    expect(photosForSection("raddish-roost", "parking").map((photo) => photo.file)).toEqual([
      "front-and-driveway.webp",
    ]);
  });

  it("builds labeled preview sets from the manifest", () => {
    const sets = photoSets("raddish-roost");
    expect(sets.map((set) => set.label)).toEqual([
      "Living Spaces",
      "Kitchen and Dining",
      "Bedrooms",
      "Bath and Laundry",
      "Outside and Around Town",
    ]);
    expect(sets[0]?.photos.map((photo) => photo.file)).toEqual([
      "living-room-wide.webp",
      "living-room.webp",
      "sitting-room.webp",
    ]);
    expect(sets[1]?.photos.map((photo) => photo.file)).toEqual([
      "kitchen.webp",
      "dining-room.webp",
      "gas-stove.webp",
    ]);
    const shown = sets.reduce((count, set) => count + set.photos.length, 0);
    expect(shown).toBeGreaterThanOrEqual(8);
    expect(shown).toBeLessThanOrEqual(10);
    expect(photoSets("shallot-chalet")).toEqual([]);
  });

  it("returns nothing until another stay adds a photo folder", () => {
    expect(getPropertyPhotos("shallot-chalet")).toEqual({ hero: null, photos: [], groups: [] });
    expect(getPropertyPhotos("onion-ranch")).toEqual({ hero: null, photos: [], groups: [] });
    expect(getPropertyPhotos("../secrets")).toEqual({ hero: null, photos: [], groups: [] });
    expect(photosForSection("shallot-chalet", "house-guide")).toEqual([]);
  });
});
