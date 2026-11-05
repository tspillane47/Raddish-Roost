import type { MessageKey } from "@/lib/i18n/messages";

export type EntryKind = "keypad" | "lockbox";
export type LaundryKind = "in_unit" | "coin_op" | "none";

export type StayGlance = {
  entry: EntryKind;
  parkingKey: MessageKey;
  pets: boolean;
  laundry: LaundryKind;
  goodToKnowKey?: MessageKey;
  minStayKey?: MessageKey;
};

/** Dad-only at-a-glance facts for property pages and stay cards. */
export const DAD_STAY_GLANCE: Record<string, StayGlance> = {
  "cider-loft": {
    entry: "keypad",
    parkingKey: "glanceParkingCiderLoft",
    pets: true,
    laundry: "coin_op",
    goodToKnowKey: "goodToKnowCiderLoftStairs",
  },
  "switchback-suite": {
    entry: "keypad",
    parkingKey: "glanceParkingSwitchback",
    pets: false,
    laundry: "none",
  },
  "hinesburg-hideaway-3": {
    entry: "keypad",
    parkingKey: "glanceParkingHinesburg",
    pets: true,
    laundry: "none",
  },
  "hinesburg-hideaway-4": {
    entry: "keypad",
    parkingKey: "glanceParkingHinesburg",
    pets: true,
    laundry: "none",
  },
  "backyard-bungalow": {
    entry: "keypad",
    parkingKey: "glanceParkingDriveway",
    pets: true,
    laundry: "in_unit",
    goodToKnowKey: "goodToKnowBackyardTraffic",
  },
  "landing-pad": {
    entry: "keypad",
    parkingKey: "glanceParkingDriveway",
    pets: true,
    laundry: "none",
  },
  "tennisplace-a35": {
    entry: "lockbox",
    parkingKey: "glanceParkingDedicated",
    pets: false,
    laundry: "coin_op",
    minStayKey: "sanibelMinStay",
  },
  "sanibel-sunsets": {
    entry: "lockbox",
    parkingKey: "glanceParkingDedicated",
    pets: false,
    laundry: "coin_op",
    minStayKey: "sanibelMinStay",
  },
};

export function stayGlanceFor(slug: string): StayGlance | null {
  return DAD_STAY_GLANCE[slug] ?? null;
}

export function isPetFriendlyStay(slug: string): boolean {
  return DAD_STAY_GLANCE[slug]?.pets === true;
}

export function entryLabelKey(entry: EntryKind): MessageKey {
  return entry === "lockbox" ? "glanceLockbox" : "glanceKeypad";
}

export function laundryLabelKey(laundry: LaundryKind): MessageKey {
  if (laundry === "in_unit") return "glanceLaundryInUnit";
  if (laundry === "coin_op") return "glanceLaundryCoinOp";
  return "glanceLaundryNone";
}

export function petsLabelKey(pets: boolean): MessageKey {
  return pets ? "glancePetsAllowed" : "glanceNoPets";
}
