export const THING_SECTIONS = [
  { id: "eat", label: "Eat" },
  { id: "drink", label: "Drink" },
  { id: "coffee", label: "Coffee" },
  { id: "ski_ride", label: "Ski & Ride" },
  { id: "see", label: "See" },
  { id: "hike", label: "Hike" },
  { id: "bike", label: "Bike" },
  { id: "winter_fun", label: "Winter Fun" },
  { id: "sweet_treats", label: "Sweet Treats" },
] as const;

export type ThingSectionId = (typeof THING_SECTIONS)[number]["id"];

export type ThingSeason = "spring" | "summer" | "fall" | "winter";

export type ThingToDo = {
  id: string;
  name: string;
  town: string | null;
  description: string | null;
  tip: string | null;
  section: ThingSectionId;
  season: ThingSeason | null;
  directionsUrl: string;
  photo: {
    src: string;
    alt: string;
    credit: { author: string; license: string; url: string } | null;
  } | null;
};

const SEASON_LABELS: Record<ThingSeason, string> = {
  spring: "Spring",
  summer: "Summer",
  fall: "Fall",
  winter: "Winter",
};

export function seasonLabel(season: ThingSeason | null): string | null {
  return season ? SEASON_LABELS[season] : null;
}

export function directionsUrl(name: string, town: string | null): string {
  const query = [name.trim(), town?.trim(), "Vermont"].filter((part) => part && part.length > 0).join(" ");
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`;
}

export function isThingSection(value: string | null | undefined): value is ThingSectionId {
  return THING_SECTIONS.some((section) => section.id === value);
}

export function thingSeason(value: string | null | undefined): ThingSeason | null {
  if (value === "spring" || value === "summer" || value === "fall" || value === "winter") return value;
  return null;
}

export function thingTip(value: string | null | undefined): string | null {
  const tip = value?.trim() ?? "";
  return tip.length > 0 ? tip : null;
}

type Assignable = {
  subcategory: string | null;
  category: string;
};

/** Places with a section use it. Older rows without one stay visible only when a stay has no sections yet. */
export function sectionForPlace(place: Assignable, stayHasSections: boolean): ThingSectionId | null {
  if (isThingSection(place.subcategory)) return place.subcategory;
  if (stayHasSections) return null;
  if (place.category === "food_drink") return "eat";
  if (place.category === "outdoors") return "hike";
  if (place.category === "shopping" || place.category === "family" || place.category === "vermont_experiences") {
    return "see";
  }
  return null;
}

export function stayHasThingSections(places: Assignable[]): boolean {
  return places.some((place) => isThingSection(place.subcategory));
}
