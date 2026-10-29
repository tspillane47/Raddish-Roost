import { describe, expect, it } from "vitest";
import { creditForFile, photoFromManifest, recommendationPhoto } from "@/lib/content/recommendation-photos";
import {
  directionsUrl,
  sectionForPlace,
  stayHasThingSections,
  thingSeason,
  thingTip,
} from "@/lib/content/things-to-do";

describe("things to do", () => {
  it("builds a Google Maps search from the place name and town", () => {
    expect(directionsUrl("Waterworks Food + Drink", "Winooski")).toBe(
      "https://www.google.com/maps/search/?api=1&query=Waterworks%20Food%20%2B%20Drink%20Winooski%20Vermont",
    );
    expect(directionsUrl("Camel's Hump", "Huntington / Duxbury")).toContain("Huntington%20%2F%20Duxbury%20Vermont");
    expect(directionsUrl("The Reservoir", null)).toBe(
      "https://www.google.com/maps/search/?api=1&query=The%20Reservoir%20Vermont",
    );
  });

  it("keeps a blank tip empty", () => {
    expect(thingTip(null)).toBeNull();
    expect(thingTip("  ")).toBeNull();
    expect(thingTip("Great seafood!")).toBe("Great seafood!");
    expect(thingSeason("year_round")).toBeNull();
    expect(thingSeason("summer")).toBe("summer");
  });

  it("hides unsectioned places once a stay has the new sections", () => {
    const places = [
      { subcategory: "eat", category: "food_drink" },
      { subcategory: null, category: "food_drink" },
    ];
    expect(stayHasThingSections(places)).toBe(true);
    expect(sectionForPlace(places[1], true)).toBeNull();
    expect(sectionForPlace({ subcategory: null, category: "food_drink" }, false)).toBe("eat");
    expect(sectionForPlace({ subcategory: "ski_ride", category: "outdoors" }, true)).toBe("ski_ride");
  });
});

describe("recommendation photos", () => {
  it("uses a manifest photo only when the file and alt text are present", () => {
    const photos = [
      { name: "Honey Road", file: "honey-road.webp", alt: "A dining room with a wood table." },
      { name: "May Day", file: "may-day.webp", alt: "   " },
      { name: "Pho Hong", file: "../secret.webp", alt: "A bowl of soup." },
    ];
    expect(photoFromManifest(photos, "Honey Road", () => true)?.src).toBe(
      "/images/recommendations/honey-road.webp",
    );
    expect(photoFromManifest(photos, "May Day", () => true)).toBeNull();
    expect(photoFromManifest(photos, "Pho Hong", () => true)).toBeNull();
    expect(photoFromManifest(photos, "Honey Road", () => false)).toBeNull();
    expect(photoFromManifest([], "Honey Road", () => true)).toBeNull();
  });

  it("shows a credit only when the license requires one", () => {
    const credits = {
      photos: [
        {
          file: "camels-hump.webp",
          sourceUrl: "https://commons.wikimedia.org/wiki/File:CamelsHumpMt_fromCharlotteVT_20140824.jpg",
          author: "Niranjan Arminius",
          license: "CC BY-SA 4.0",
          attributionRequired: true,
        },
        {
          file: "bolton-valley.webp",
          sourceUrl: "https://commons.wikimedia.org/wiki/File:Bolton_valley_windmill.jpg",
          author: "Storylanding",
          license: "CC0",
          attributionRequired: false,
        },
      ],
    };
    expect(creditForFile(credits, "camels-hump.webp")?.license).toBe("CC BY-SA 4.0");
    expect(creditForFile(credits, "bolton-valley.webp")).toBeNull();
    expect(recommendationPhoto("Camel's Hump")?.credit?.author).toBe("Niranjan Arminius");
    expect(recommendationPhoto("Bolton Valley Resort")?.src).toBe("/images/recommendations/bolton-valley.webp");
    expect(recommendationPhoto("Bolton Valley Resort")?.credit).toBeNull();
    expect(recommendationPhoto("Waterworks Food + Drink")).toBeNull();
  });
});
