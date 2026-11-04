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

  it("matches the Getaway Club brand for dad", () => {
    expect(dadSite.name).toBe("The Getaway Club");
    expect(dadSite.shortName).toBe("Getaway Club");
    expect(dadSite.tagline).toBe("Good places to get away.");
    expect(dadSite.hero.src).toBe("/sites/dad/hero.webp");
    expect(dadSite.colors.forest).toBe("#163A4A");
    expect(dadSite.colors.cream).toBe("#F1EDE4");
    expect(dadSite.colors.terracotta).toBe("#E85D04");
    expect(dadSite.colors.sage).toBe("#4A7C7A");
    expect(dadSite.colors.mustard).toBe("#F0C808");
    expect(dadSite.nav?.map((item) => item.label)).toEqual([
      "Our Stays",
      "Vermont",
      "Sanibel",
    ]);
    expect(dadSite.nav?.map((item) => item.href).join(" ")).not.toMatch(/\/about|\/contact/);
    expect(dadSite.bookCta?.label).toBe("Book a Stay");
    expect(dadSite.artworkOrder).toHaveLength(8);
    expect(JSON.stringify(dadSite)).not.toContain("—");
    expect(JSON.stringify(dadSite)).not.toContain("[Dad's Site Name]");
    expect(JSON.stringify(dadSite)).not.toContain("Far & Familiar");
  });

  it("resolves the active site from SITE_KEY", () => {
    expect(getSiteConfig("roost").key).toBe("roost");
    expect(getSiteConfig("dad").key).toBe("dad");
    expect(getSiteConfig("dad").name).toBe("The Getaway Club");
  });
});
