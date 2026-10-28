import { describe, expect, it } from "vitest";
import { SAMPLE_PROPERTIES } from "@/lib/content/sample-catalog";
import { slugToReject } from "@/lib/routing/property-path";

const published = new Set(SAMPLE_PROPERTIES.map((property) => property.slug));

describe("unknown property paths", () => {
  it("rejects slugs that are not a published stay", () => {
    expect(slugToReject("/not-a-real-stay", published)).toBe("not-a-real-stay");
    expect(slugToReject("/raddish-roost", published)).toBeNull();
    expect(slugToReject("/shallot-chalet", published)).toBeNull();
    expect(slugToReject("/onion-ranch", published)).toBeNull();
    expect(slugToReject("/contact", published)).toBeNull();
    expect(slugToReject("/privacy", published)).toBeNull();
    expect(slugToReject("/", published)).toBeNull();
  });
});
