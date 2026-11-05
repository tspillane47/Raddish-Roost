import { existsSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { dadSite } from "@/sites/dad";
import { DAD_GETAWAY_HERO, DAD_GETAWAY_HERO_FOCUS } from "@/sites/dad-hero";
import { getSiteConfig, roostSite } from "@/sites";
import { sectionLabel, siteLabel } from "@/sites/labels";

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
    expect(roostSite.labels).toBeUndefined();
    expect(JSON.stringify(roostSite)).not.toContain("—");
    expect(JSON.stringify(roostSite)).not.toContain("Radish");
  });

  it("matches the Getaway Club heist brand for dad", () => {
    expect(dadSite.name).toBe("The Getaway Club");
    expect(dadSite.shortName).toBe("Getaway Club");
    expect(dadSite.tagline).toBe("Make a clean getaway.");
    expect(dadSite.collectionBody).toContain("No questions asked.");
    expect(dadSite.hero.src).toBe("/sites/dad/hero.webp");
    expect(DAD_GETAWAY_HERO.src).toBe("/sites/dad/hero-getaway.webp");
    expect(DAD_GETAWAY_HERO.width).toBe(2172);
    expect(DAD_GETAWAY_HERO.height).toBe(724);
    expect(DAD_GETAWAY_HERO_FOCUS).toBe("50% 48%");
    expect(
      existsSync(path.join(process.cwd(), "public/sites/dad/hero-getaway.webp")),
    ).toBe(true);
    expect(existsSync(path.join(process.cwd(), "public/sites/dad/hero.webp"))).toBe(true);
    expect(dadSite.colors.forest).toBe("#1B4332");
    expect(dadSite.colors.cream).toBe("#E8DCC8");
    expect(dadSite.colors.terracotta).toBe("#C1121F");
    expect(dadSite.colors.sage).toBe("#6B9B8E");
    expect(dadSite.colors.mustard).toBe("#C9A227");
    expect(dadSite.nav?.map((item) => item.label)).toEqual([
      "The Hideouts",
      "Vermont",
      "Sanibel",
    ]);
    expect(dadSite.bookCta?.label).toBe("Plan Your Escape");
    expect(dadSite.bookCta?.plain).toBe("Book now");
    expect(dadSite.artworkOrder).toHaveLength(8);
    expect(siteLabel(dadSite, "checkInCheckout", "en")?.themed).toContain("Clean Getaway");
    expect(sectionLabel(dadSite, "things-to-do", "es")?.plain).toBe("Cosas que hacer");
    expect(sectionLabel(dadSite, "wifi", "fr")?.themed).toBe("Comms");
    expect(dadSite.labels?.en?.checkoutStamp).toBe("CLEAN GETAWAY");
    expect(dadSite.labels?.es?.ourStays?.themed).toBeTruthy();
    expect(dadSite.labels?.fr?.bookNow?.themed).toBeTruthy();
    expect(JSON.stringify(dadSite)).not.toContain("—");
    expect(JSON.stringify(dadSite)).not.toContain("Far & Familiar");
    expect(dadSite.name).toBe("The Getaway Club");
  });

  it("resolves the active site from SITE_KEY", () => {
    expect(getSiteConfig("roost").key).toBe("roost");
    expect(getSiteConfig("dad").key).toBe("dad");
    expect(getSiteConfig("dad").name).toBe("The Getaway Club");
  });
});
