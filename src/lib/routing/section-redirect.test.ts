import { describe, expect, it } from "vitest";
import { guideRedirectRequest } from "@/lib/routing/section-redirect";

describe("guidebook redirects", () => {
  it("sends old section addresses to the merged sections", () => {
    expect(guideRedirectRequest("/raddish-roost/guide/check-in")).toEqual({
      property: "raddish-roost",
      section: "check-in-checkout",
    });
    expect(guideRedirectRequest("/shallot-chalet/guide/checkout")).toEqual({
      property: "shallot-chalet",
      section: "check-in-checkout",
    });
    expect(guideRedirectRequest("/onion-ranch/guide/amenities")).toEqual({
      property: "onion-ranch",
      section: "the-house",
    });
    expect(guideRedirectRequest("/raddish-roost/guide/house-guide")).toEqual({
      property: "raddish-roost",
      section: "the-house",
    });
    expect(guideRedirectRequest("/raddish-roost/guide/recommendations")).toEqual({
      property: "raddish-roost",
      section: "things-to-do",
    });
    expect(guideRedirectRequest("/shallot-chalet/guide/local-recommendations")).toEqual({
      property: "shallot-chalet",
      section: "things-to-do",
    });
    expect(guideRedirectRequest("/onion-ranch/explore")).toEqual({
      property: "onion-ranch",
      section: "things-to-do",
    });
  });

  it("leaves the new sections and other pages alone", () => {
    expect(guideRedirectRequest("/raddish-roost/guide/check-in-checkout")).toBeNull();
    expect(guideRedirectRequest("/raddish-roost/guide/the-house")).toBeNull();
    expect(guideRedirectRequest("/raddish-roost/guide/wifi")).toBeNull();
    expect(guideRedirectRequest("/raddish-roost/guide/faq")).toBeNull();
    expect(guideRedirectRequest("/raddish-roost")).toBeNull();
  });
});
