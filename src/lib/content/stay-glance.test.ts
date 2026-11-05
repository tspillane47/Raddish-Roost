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
        "safe-harbor",
        "shell-game",
        "switchback-suite",
      ].sort(),
    );
    expect(stayGlanceFor("cider-loft")?.entry).toBe("keypad");
    expect(stayGlanceFor("shell-game")?.entry).toBe("lockbox");
    expect(stayGlanceFor("landing-pad")?.laundry).toBe("none");
    expect(stayGlanceFor("backyard-bungalow")?.laundry).toBe("in_unit");
    expect(stayGlanceFor("safe-harbor")?.minStayKey).toBe("sanibelMinStay");
    expect(stayGlanceFor("raddish-roost")).toBeNull();
  });

  it("marks the five pet-friendly stays", () => {
    expect(isPetFriendlyStay("cider-loft")).toBe(true);
    expect(isPetFriendlyStay("hinesburg-hideaway-3")).toBe(true);
    expect(isPetFriendlyStay("hinesburg-hideaway-4")).toBe(true);
    expect(isPetFriendlyStay("backyard-bungalow")).toBe(true);
    expect(isPetFriendlyStay("landing-pad")).toBe(true);
    expect(isPetFriendlyStay("switchback-suite")).toBe(false);
    expect(isPetFriendlyStay("shell-game")).toBe(false);
  });
});
