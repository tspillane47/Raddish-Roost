import type { MessageKey } from "@/lib/i18n/messages";

/** Vermont stays that show a Flying Out card on Getting Here. */
export const FLYING_OUT_DRIVE_KEYS = {
  "landing-pad": "flyingOutDriveLandingPad",
  "backyard-bungalow": "flyingOutDriveBackyard",
  "hinesburg-hideaway-3": "flyingOutDriveHinesburg",
  "hinesburg-hideaway-4": "flyingOutDriveHinesburg",
  "cider-loft": "flyingOutDriveCiderLoft",
  "switchback-suite": "flyingOutDriveSwitchback",
  "raddish-roost": "flyingOutDriveRaddishRoost",
  "shallot-chalet": "flyingOutDriveWinooski",
  "onion-ranch": "flyingOutDriveWinooski",
} as const satisfies Record<string, MessageKey>;

export type FlyingOutSlug = keyof typeof FLYING_OUT_DRIVE_KEYS;

export function flyingOutDriveKey(slug: string): MessageKey | null {
  if (slug in FLYING_OUT_DRIVE_KEYS) {
    return FLYING_OUT_DRIVE_KEYS[slug as FlyingOutSlug];
  }
  return null;
}
