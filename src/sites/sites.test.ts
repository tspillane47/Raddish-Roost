import { describe, expect, it } from "vitest";
import { dadSite } from "@/sites/dad";
import { getSiteConfig, roostSite } from "@/sites";

describe("site configs", () => {
  it("keeps the roost brand assets and name unchanged", () => {
    expect(roostSite.name).toBe("The Vermont Roost Collection");
    expect(roostSite.shortName).toBe("Vermont Roost");
    expect(roostSite.welcome.placeName).toBe("Vermont.");
    expect(roostSite.hero.src).toBe("/images/brand/hero.webp");
    expect(roostSite.artworkOrder).toEqual(["onion-ranch", "shallot-chalet", "raddish-roost"]);
    expect(roostSite.logos.map((logo) => logo.slug)).toEqual([
      "onion-ranch",
      "shallot-chalet",
      "raddish-roost",
    ]);
    expect(roostSite.colors.forest).toBe("#263F35");
    expect(roostSite.colors.cream).toBe("#F7F4ED");
    expect(JSON.stringify(roostSite)).not.toContain("—");
    expect(JSON.stringify(roostSite)).not.toContain("Radish");
  });

  it("matches the Far and Familiar concept for dad", () => {
    expect(dadSite.name).toBe("The Far & Familiar Collection");
    expect(dadSite.shortName).toBe("Far & Familiar");
    expect(dadSite.tagline).toBe("Good places to get away.");
    expect(dadSite.hero.src).toBe("/sites/dad/hero.webp");
    expect(dadSite.colors.forest).toBe("#1F3A2E");
    expect(dadSite.colors.cream).toBe("#F3EFE4");
    expect(dadSite.colors.terracotta).toBe("#C45C2A");
    expect(dadSite.colors.sage).toBe("#5B8A8A");
    expect(dadSite.colors.mustard).toBe("#C9A227");
    expect(dadSite.nav?.map((item) => item.label)).toEqual([
      "Our Stays",
      "Vermont",
      "Sanibel",
      "About",
      "Contact",
    ]);
    expect(dadSite.bookCta?.label).toBe("Book a Stay");
    expect(dadSite.artworkOrder).toHaveLength(8);
    expect(JSON.stringify(dadSite)).not.toContain("—");
    expect(JSON.stringify(dadSite)).not.toContain("[Dad's Site Name]");
  });

  it("resolves the active site from SITE_KEY", () => {
    expect(getSiteConfig("roost").key).toBe("roost");
    expect(getSiteConfig("dad").key).toBe("dad");
    expect(getSiteConfig("dad").name).toBe("The Far & Familiar Collection");
  });
});
