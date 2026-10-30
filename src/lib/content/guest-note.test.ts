import { describe, expect, it } from "vitest";
import {
  clearGuestNoteLimits,
  guestNoteBlocked,
  GUEST_NOTE_TEXT,
  rememberGuestNote,
  REVIEW_NOTE,
  validateGuestNote,
} from "@/lib/content/guest-note";

describe("guest notes", () => {
  it("requires a note, keeps the name optional, and ignores a filled honeypot", () => {
    expect(validateGuestNote({ name: "", message: "  ", propertySlug: "raddish-roost", honeypot: "" })).toEqual({
      ok: false,
      error: "Tell us what's going on.",
    });
    expect(
      validateGuestNote({
        name: "Alex",
        message: "The heat will not turn on.",
        propertySlug: "Raddish-Roost",
        honeypot: "",
      }),
    ).toEqual({
      ok: true,
      ignore: false,
      name: "Alex",
      message: "The heat will not turn on.",
      propertySlug: "raddish-roost",
    });
    expect(
      validateGuestNote({ name: "", message: "The sink is dripping.", propertySlug: "onion-ranch", honeypot: "" }).ok,
    ).toBe(true);
    expect(
      validateGuestNote({ name: "", message: "Hello", propertySlug: "raddish-roost", honeypot: "spammer" }),
    ).toEqual({ ok: true, ignore: true });
    expect(validateGuestNote({ name: "A".repeat(121), message: "Hi", propertySlug: "raddish-roost", honeypot: "" }).ok).toBe(
      false,
    );
    expect(GUEST_NOTE_TEXT).not.toMatch(/—|–/);
  });

  it("allows five notes an hour, then asks the guest to wait", () => {
    clearGuestNoteLimits();
    const now = Date.parse("2026-10-30T15:00:00Z");
    for (let index = 0; index < 5; index += 1) rememberGuestNote("guest", now + index);
    expect(guestNoteBlocked("guest", now + 6)).toBe(true);
    expect(guestNoteBlocked("guest", now + 60 * 60 * 1000 + 10)).toBe(false);
    expect(REVIEW_NOTE).not.toMatch(/discount|perk|reward|coupon/i);
    expect(REVIEW_NOTE).not.toMatch(/—|–/);
  });
});
