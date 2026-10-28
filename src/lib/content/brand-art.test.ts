import { describe, expect, it } from "vitest";
import { ARTWORK_ORDER, WELCOME_BANNER, WELCOME_BANNER_DARK, brandLogo, orderLikeArtwork } from "@/lib/content/brand-art";

describe("brand artwork", () => {
  it("keeps the painted order and the Raddish logo", () => {
    expect(ARTWORK_ORDER).toEqual(["onion-ranch", "shallot-chalet", "raddish-roost"]);
    expect(brandLogo("raddish-roost")?.src).toBe("/images/brand/logo-raddish-roost.webp");
    expect(WELCOME_BANNER.src).toBe("/images/brand/banner.webp");
    expect(WELCOME_BANNER_DARK.src).toBe("/images/brand/banner-dark.webp");
    expect(brandLogo("raddish-roost")?.alt).toBe("Logo for The Raddish Roost");
    expect(brandLogo("somewhere-else")).toBeNull();

    const ordered = orderLikeArtwork([
      { slug: "raddish-roost" },
      { slug: "extra-cabin" },
      { slug: "onion-ranch" },
      { slug: "shallot-chalet" },
    ]);
    expect(ordered.map((item) => item.slug)).toEqual([
      "onion-ranch",
      "shallot-chalet",
      "raddish-roost",
      "extra-cabin",
    ]);
  });
});
