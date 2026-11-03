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

  it("marks dad placeholders clearly and uses neutral assets", () => {
    expect(dadSite.name).toBe("[Dad's Site Name]");
    expect(dadSite.welcome.placeName).toBe("[Dad's Site Name]");
    expect(dadSite.hero.src).toBe("/sites/dad/hero.webp");
    expect(dadSite.logos).toEqual([]);
    expect(dadSite.icons.icon192).toBe("/sites/dad/icon-192.png");
    expect(dadSite.comingSoonTitle.length).toBeGreaterThan(0);
    expect(JSON.stringify(dadSite)).not.toContain("—");
    expect(JSON.stringify(dadSite)).toContain("[Dad's Site Name]");
  });

  it("resolves the active site from SITE_KEY", () => {
    expect(getSiteConfig("roost").key).toBe("roost");
    expect(getSiteConfig("dad").key).toBe("dad");
    expect(getSiteConfig("dad").name).toBe("[Dad's Site Name]");
  });
});
