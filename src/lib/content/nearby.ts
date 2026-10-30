export const PROPERTY_TOWNS: Record<string, string> = {
  "raddish-roost": "Waterbury, VT",
  "shallot-chalet": "Winooski, VT",
  "onion-ranch": "Winooski, VT",
};

export const NEARBY_KINDS = [
  { kind: "grocery", label: "Grocery store", search: "grocery store near" },
  { kind: "pharmacy", label: "Pharmacy", search: "pharmacy near" },
  { kind: "gas", label: "Gas station", search: "gas station near" },
  { kind: "urgent_care", label: "Urgent care", search: "urgent care near" },
  { kind: "hospital", label: "Hospital (ER)", search: "hospital near" },
] as const;

export type NearbyKind = (typeof NEARBY_KINDS)[number]["kind"];

export type NearbyEssential = {
  id: string;
  kind: NearbyKind;
  label: string;
  href: string;
  placeName: string | null;
  note: string | null;
};

export function isNearbyKind(value: string): value is NearbyKind {
  return NEARBY_KINDS.some((item) => item.kind === value);
}

export function mapsSearchUrl(query: string): string {
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`;
}

export function nearbySearchQuery(kind: NearbyKind, town: string): string {
  const item = NEARBY_KINDS.find((entry) => entry.kind === kind);
  return `${item?.search ?? "near"} ${town}`;
}

export function nearbyHref(mapsUrl: string | null | undefined, searchQuery: string): string | null {
  const direct = mapsUrl?.trim() ?? "";
  if (direct.startsWith("https://")) return direct;
  const query = searchQuery.trim();
  if (!query) return null;
  return mapsSearchUrl(query);
}

export function nearbyForTown(town: string): NearbyEssential[] {
  return NEARBY_KINDS.map((item) => {
    const query = `${item.search} ${town}`;
    return {
      id: item.kind,
      kind: item.kind,
      label: item.label,
      href: mapsSearchUrl(query),
      placeName: null,
      note: item.kind === "hospital" ? "For emergencies, call 911." : null,
    };
  });
}
