import { describe, expect, it } from "vitest";
import {
  DAD_SITE_ID,
  DEFAULT_SITE_KEY,
  ROOST_SITE_ID,
  getSiteKey,
  guideSectionRequest,
  parseSiteKey,
  propertyBelongsToSite,
  publishedSlugsRequest,
  siteIdForKey,
} from "@/lib/site";

describe("site key", () => {
  it("defaults to roost when SITE_KEY is missing or unknown", () => {
    expect(getSiteKey({})).toBe("roost");
    expect(getSiteKey({ SITE_KEY: "" })).toBe("roost");
    expect(getSiteKey({ SITE_KEY: " other " })).toBe("roost");
    expect(DEFAULT_SITE_KEY).toBe("roost");
  });

  it("accepts roost and dad only", () => {
    expect(getSiteKey({ SITE_KEY: "dad" })).toBe("dad");
    expect(getSiteKey({ SITE_KEY: "ROOST" })).toBe("roost");
    expect(parseSiteKey("dad")).toBe("dad");
    expect(parseSiteKey("nope")).toBeNull();
  });
});

describe("site property isolation", () => {
  it("never treats the other site's property as local", () => {
    const roostStay = { site_id: ROOST_SITE_ID, slug: "raddish-roost" };
    const dadStay = { site_id: DAD_SITE_ID, slug: "maple-lodge" };

    expect(propertyBelongsToSite(roostStay, "roost")).toBe(true);
    expect(propertyBelongsToSite(roostStay, "dad")).toBe(false);
    expect(propertyBelongsToSite(dadStay, "dad")).toBe(true);
    expect(propertyBelongsToSite(dadStay, "roost")).toBe(false);
    expect(propertyBelongsToSite(null, "roost")).toBe(false);
  });

  it("keeps published slug requests scoped to one site_id", () => {
    const roostUrl = publishedSlugsRequest("https://example.supabase.co", "roost");
    const dadUrl = publishedSlugsRequest("https://example.supabase.co", "dad");

    expect(roostUrl).toContain(`site_id=eq.${ROOST_SITE_ID}`);
    expect(roostUrl).not.toContain(DAD_SITE_ID);
    expect(dadUrl).toContain(`site_id=eq.${DAD_SITE_ID}`);
    expect(dadUrl).not.toContain(ROOST_SITE_ID);
    expect(siteIdForKey("roost")).toBe(ROOST_SITE_ID);
  });

  it("keeps guidebook section checks scoped to one site_id", () => {
    const url = guideSectionRequest(
      "https://example.supabase.co",
      "roost",
      "raddish-roost",
      "getting-here",
    );
    expect(url).toContain("properties.slug=eq.raddish-roost");
    expect(url).toContain(`properties.site_id=eq.${ROOST_SITE_ID}`);
    expect(url).not.toContain(DAD_SITE_ID);
  });

  it("filters a mixed property list down to the active site only", () => {
    const rows = [
      { slug: "raddish-roost", site_id: ROOST_SITE_ID },
      { slug: "maple-lodge", site_id: DAD_SITE_ID },
      { slug: "shallot-chalet", site_id: ROOST_SITE_ID },
    ];
    const roostOnly = rows.filter((row) => propertyBelongsToSite(row, "roost"));
    const dadOnly = rows.filter((row) => propertyBelongsToSite(row, "dad"));

    expect(roostOnly.map((row) => row.slug)).toEqual(["raddish-roost", "shallot-chalet"]);
    expect(dadOnly.map((row) => row.slug)).toEqual(["maple-lodge"]);
    expect(roostOnly.some((row) => row.slug === "maple-lodge")).toBe(false);
    expect(dadOnly.some((row) => row.slug === "raddish-roost")).toBe(false);
  });
});
