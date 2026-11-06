import { describe, expect, it } from "vitest";
import {
  DAD_STAY_GLANCE,
  isPetFriendlyStay,
  stayGlanceFor,
} from "@/lib/content/stay-glance";

describe("dad stay glance", () => {
  it("covers every dad property with entry, pets, and laundry facts", () => {
    expect(Object.keys(DAD_STAY_GLANCE).sort()).toEqual(
      [
        "backyard-bungalow",
        "cider-loft",
        "hinesburg-hideaway-3",
        "hinesburg-hideaway-4",
        "landing-pad",
        "sanibel-sunsets",
        "switchback-suite",
        "tennisplace-a35",
      ].sort(),
    );
    expect(stayGlanceFor("cider-loft")?.entry).toBe("keypad");
    expect(stayGlanceFor("tennisplace-a35")?.entry).toBe("lockbox");
    expect(stayGlanceFor("tennisplace-a35")?.parkingKey).toBe("glanceParkingCovered");
    expect(stayGlanceFor("tennisplace-a35")?.extras?.map((item) => item.key)).toEqual([
      "glanceSharedPool",
      "glanceTennisPickleball",
    ]);
    expect(stayGlanceFor("landing-pad")?.laundry).toBe("none");
    expect(stayGlanceFor("backyard-bungalow")?.laundry).toBe("in_unit");
    expect(stayGlanceFor("sanibel-sunsets")?.minStayKey).toBe("sanibelMinStay");
    expect(stayGlanceFor("sanibel-sunsets")?.goodToKnowKey).toBe("goodToKnowSanibelPets");
    expect(stayGlanceFor("raddish-roost")).toBeNull();
  });

  it("marks the five pet-friendly stays", () => {
    expect(isPetFriendlyStay("cider-loft")).toBe(true);
    expect(isPetFriendlyStay("hinesburg-hideaway-3")).toBe(true);
    expect(isPetFriendlyStay("hinesburg-hideaway-4")).toBe(true);
    expect(isPetFriendlyStay("backyard-bungalow")).toBe(true);
    expect(isPetFriendlyStay("landing-pad")).toBe(true);
    expect(isPetFriendlyStay("switchback-suite")).toBe(false);
    expect(isPetFriendlyStay("tennisplace-a35")).toBe(false);
  });
});
