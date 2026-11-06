export const THING_SECTIONS = [
  { id: "beaches", label: "Beaches" },
  { id: "eat", label: "Eat" },
  { id: "drink", label: "Drink" },
  { id: "coffee", label: "Coffee" },
  { id: "ski_ride", label: "Ski & Ride" },
  { id: "see", label: "See" },
  { id: "hike", label: "Hike" },
  { id: "bike", label: "Bike" },
  { id: "winter_fun", label: "Winter Fun" },
  { id: "sweet_treats", label: "Sweet Treats" },
  { id: "groceries", label: "Groceries" },
  { id: "on_the_water", label: "On the Water" },
] as const;

export type ThingSectionId = (typeof THING_SECTIONS)[number]["id"];

export type ThingSeason = "spring" | "summer" | "fall" | "winter";

/** Classic Vermont seasons, or a named option key like beach_day. */
export type PerfectDaySeason = string;

export type PerfectDayStop = {
  id: string;
  timeLabel: string;
  name: string;
  detail: string;
  place: ThingToDo | null;
};

export type PerfectDay = {
  season: PerfectDaySeason;
  title: string;
  stops: PerfectDayStop[];
};

export type DirectionsRegion = "Vermont" | "Florida";

export function isClassicItinerarySeason(season: string): season is "fall" | "winter" {
  return season === "fall" || season === "winter";
}

/** Fall is September through November. Winter is December through March. Other months use Fall for now. */
export function currentItinerarySeason(date: Date): "fall" | "winter" {
  const month = date.getMonth();
  if (month === 11 || month <= 2) return "winter";
  return "fall";
}

/** Prefer the seasonal day when present; otherwise the first named option. */
export function preferredPerfectDay(days: PerfectDay[], today: Date): PerfectDaySeason | null {
  if (days.length === 0) return null;
  if (days.every((day) => isClassicItinerarySeason(day.season))) {
    const preferred = currentItinerarySeason(today);
    if (days.some((day) => day.season === preferred)) return preferred;
  }
  return days[0]?.season ?? null;
}

export const THING_FILTERS = [
  { id: "walkable", label: "Walkable" },
  { id: "rainy_day", label: "Rainy Day" },
  { id: "kid_friendly", label: "Kid Friendly" },
  { id: "dog_friendly", label: "Dog Friendly" },
] as const;

export type ThingFilterId = (typeof THING_FILTERS)[number]["id"];

export function isThingFilter(value: string): value is ThingFilterId {
  return THING_FILTERS.some((filter) => filter.id === value);
}

export function guestTags(value: unknown): ThingFilterId[] {
  if (!Array.isArray(value)) return [];
  return value.filter((tag): tag is ThingFilterId => typeof tag === "string" && isThingFilter(tag));
}

/** A place has to match every selected chip. */
export function placesMatchingFilters(places: ThingToDo[], filters: readonly ThingFilterId[]): ThingToDo[] {
  if (filters.length === 0) return places;
  return places.filter((place) => filters.every((filter) => place.tags?.includes(filter)));
}

export type ThingToDo = {
  id: string;
  name: string;
  town: string | null;
  description: string | null;
  tip: string | null;
  section: ThingSectionId;
  season: ThingSeason | null;
  tags?: ThingFilterId[];
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

export function directionsUrl(
  name: string,
  town: string | null,
  region: DirectionsRegion = "Vermont",
  address: string | null = null,
): string {
  const street = address?.trim() || null;
  const query = street
    ? [name.trim(), street, region].filter((part) => part && part.length > 0).join(" ")
    : [name.trim(), town?.trim(), region].filter((part) => part && part.length > 0).join(" ");
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
