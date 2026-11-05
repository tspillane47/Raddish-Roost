import { describe, expect, it } from "vitest";
import { flyingOutDriveKey } from "@/lib/content/flying-out";

describe("flying out drive times", () => {
  it("maps Vermont stays to drive-time copy keys", () => {
    expect(flyingOutDriveKey("landing-pad")).toBe("flyingOutDriveLandingPad");
    expect(flyingOutDriveKey("backyard-bungalow")).toBe("flyingOutDriveBackyard");
    expect(flyingOutDriveKey("hinesburg-hideaway-3")).toBe("flyingOutDriveHinesburg");
    expect(flyingOutDriveKey("hinesburg-hideaway-4")).toBe("flyingOutDriveHinesburg");
    expect(flyingOutDriveKey("cider-loft")).toBe("flyingOutDriveCiderLoft");
    expect(flyingOutDriveKey("switchback-suite")).toBe("flyingOutDriveSwitchback");
    expect(flyingOutDriveKey("raddish-roost")).toBe("flyingOutDriveRaddishRoost");
    expect(flyingOutDriveKey("shallot-chalet")).toBe("flyingOutDriveWinooski");
    expect(flyingOutDriveKey("onion-ranch")).toBe("flyingOutDriveWinooski");
    expect(flyingOutDriveKey("safe-harbor")).toBeNull();
  });
});
