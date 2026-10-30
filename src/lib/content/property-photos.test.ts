import { readdirSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { chooseHeroPhotos, getPropertyPhotos, photosForSection, photoSets } from "@/lib/content/property-photos";
import type { PropertyPhoto } from "@/lib/content/property-photos";

describe("property photos", () => {
  it("loads The Raddish Roost gallery from its folder", () => {
    const { hero, photos } = getPropertyPhotos("raddish-roost");
    const directory = path.join(process.cwd(), "public/images/properties/raddish-roost");
    const files = readdirSync(directory)
      .filter((file) => file.endsWith(".webp"))
      .sort();

    expect(hero?.file).toBe("front-of-house.webp");
    expect(hero?.src).toBe("/images/properties/raddish-roost/front-of-house.webp");
    expect(getPropertyPhotos("raddish-roost").heroPhotos.map((photo) => photo.file)).toEqual([
      "front-of-house.webp",
      "living-room.webp",
      "kitchen.webp",
    ]);
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
    expect(photosForSection("raddish-roost", "the-house").map((photo) => photo.file)).toEqual(
      expect.arrayContaining(["kitchen.webp", "front-of-house.webp", "laundry-room.webp", "stairs.webp"]),
    );
    expect(photosForSection("raddish-roost", "check-in-checkout").map((photo) => photo.file)).toContain(
      "front-of-house.webp",
    );
    expect(photosForSection("raddish-roost", "getting-here").map((photo) => photo.file)).toContain(
      "front-and-driveway.webp",
    );
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
      "sitting-room.webp",
      "living-room.webp",
    ]);
    expect(sets[1]?.photos.map((photo) => photo.file)).toEqual([
      "dining-room.webp",
      "gas-stove.webp",
      "kitchen.webp",
    ]);
    expect(sets[0]?.photos[0]?.file).not.toBe(
      getPropertyPhotos("raddish-roost").heroPhotos[0]?.file,
    );
    const shown = sets.reduce((count, set) => count + set.photos.length, 0);
    expect(shown).toBeGreaterThanOrEqual(8);
    expect(shown).toBeLessThanOrEqual(10);
  });

  it("loads The Shallot Chalet gallery from its folder", () => {
    const { hero, photos } = getPropertyPhotos("shallot-chalet");
    const directory = path.join(process.cwd(), "public/images/properties/shallot-chalet");
    const files = readdirSync(directory)
      .filter((file) => file.endsWith(".webp"))
      .sort();

    expect(hero?.file).toBe("living-room.webp");
    expect(getPropertyPhotos("shallot-chalet").heroPhotos.map((photo) => photo.file)).toEqual([
      "living-room.webp",
      "kitchen-wide.webp",
      "bedroom-armchair.webp",
    ]);
    expect(getPropertyPhotos("shallot-chalet").heroPhotos[1]?.focus).toBe("bottom");
    expect(photos.map((photo) => photo.file).sort()).toEqual(files);
    expect(photos).toHaveLength(18);
    expect(photosForSection("shallot-chalet", "house-guide").map((photo) => photo.file)[0]).toBe("kitchen.webp");
    expect(photosForSection("shallot-chalet", "amenities").map((photo) => photo.file)).toEqual([
      "kitchen-wide.webp",
    ]);
    expect(photosForSection("shallot-chalet", "wifi").map((photo) => photo.file)).toEqual([
      "living-room-wide.webp",
    ]);
    expect(photosForSection("shallot-chalet", "getting-here")).toEqual([]);
    expect(photoSets("shallot-chalet").map((set) => set.label)).toEqual([
      "Living Spaces",
      "Kitchen and Dining",
      "Bedrooms",
      "Bath and Laundry",
    ]);
    for (const photo of photos) {
      expect(photo.alt.toLowerCase()).not.toMatch(/keypad|lockbox|door code/);
    }
  });

  it("loads The Onion Ranch gallery from its folder", () => {
    const { hero, photos } = getPropertyPhotos("onion-ranch");
    const directory = path.join(process.cwd(), "public/images/properties/onion-ranch");
    const files = readdirSync(directory)
      .filter((file) => file.endsWith(".webp"))
      .sort();

    expect(hero?.file).toBe("front-entrance.webp");
    expect(getPropertyPhotos("onion-ranch").heroPhotos.map((photo) => photo.file)).toEqual([
      "front-entrance.webp",
      "living-room.webp",
      "kitchen.webp",
    ]);
    expect(photos.map((photo) => photo.file).sort()).toEqual(files);
    expect(photos).toHaveLength(16);
    expect(photosForSection("onion-ranch", "house-guide").map((photo) => photo.file)[0]).toBe("kitchen.webp");
    expect(photosForSection("onion-ranch", "getting-here").map((photo) => photo.file)).toEqual([
      "front-entrance.webp",
    ]);
    expect(photosForSection("onion-ranch", "wifi").map((photo) => photo.file)).toEqual(["workspace.webp"]);
    expect(photoSets("onion-ranch").map((set) => set.label)).toEqual([
      "Living Spaces",
      "Kitchen and Dining",
      "Bedrooms",
      "Bath and Laundry",
      "Outside and Around Town",
    ]);
    for (const photo of photos) {
      expect(photo.alt.toLowerCase()).not.toMatch(/keypad|lockbox|door code|\b122\b/);
      expect(photo.alt).not.toMatch(/—|–/);
    }
  });

  it("returns nothing for a slug with no photo folder", () => {
    expect(getPropertyPhotos("../secrets")).toEqual({ hero: null, heroPhotos: [], photos: [], groups: [] });
    expect(photosForSection("extra-cabin", "house-guide")).toEqual([]);
    expect(photoSets("extra-cabin")).toEqual([]);
  });

  it("uses a shorter hero list when a stay has fewer photos", () => {
    const photos = [
      samplePhoto("porch.webp"),
      samplePhoto("sofa.webp"),
    ];
    expect(chooseHeroPhotos(photos, ["missing.webp"], "porch.webp").map((photo) => photo.file)).toEqual([
      "porch.webp",
      "sofa.webp",
    ]);
    expect(chooseHeroPhotos(photos, [], null).map((photo) => photo.file)).toEqual([
      "porch.webp",
      "sofa.webp",
    ]);
    expect(chooseHeroPhotos([], ["porch.webp"], null)).toEqual([]);
  });
});

function samplePhoto(file: string): PropertyPhoto {
  return {
    file,
    src: `/images/${file}`,
    alt: "A sample room with a window and a chair.",
    width: 1600,
    height: 1000,
    sections: [],
    group: null,
    focus: "center",
  };
}
