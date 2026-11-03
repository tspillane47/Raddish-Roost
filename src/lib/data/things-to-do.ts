import "server-only";

import { connection } from "next/server";
import { cache } from "react";
import { linkDescription, linkHostTip } from "@/lib/content/link-voice";
import { recommendationPhoto } from "@/lib/content/recommendation-photos";
import {
  directionsUrl,
  guestTags,
  sectionForPlace,
  stayHasThingSections,
  thingSeason,
  thingTip,
  type PerfectDay,
  type PerfectDaySeason,
  type ThingToDo,
} from "@/lib/content/things-to-do";
import { copyText } from "@/lib/i18n/copy";
import { getLocale } from "@/lib/i18n/get-locale";
import { loadCopy } from "@/lib/i18n/load-copy";
import { t } from "@/lib/i18n/translate";
import { getSiteKey, propertyBelongsToSite, siteIdForKey } from "@/lib/site";
import { getSupabase } from "@/lib/supabase/server";
import { propertySlugSchema } from "@/lib/validation/slug";

type RecommendationJoin = {
  id: string;
  category: string;
  subcategory?: string | null;
  season: string | null;
  name: string | null;
  description: string | null;
  host_note: string | null;
  town?: string | null;
  is_active: boolean;
  published_at: string | null;
};

type LinkRow = {
  id?: string | null;
  sort_order: number;
  host_note?: string | null;
  custom_description?: string | null;
  guest_tags?: string[] | null;
  recommendations: RecommendationJoin | RecommendationJoin[] | null;
};

const VOICE_COLUMNS =
  "id, sort_order, host_note, custom_description, guest_tags, recommendations(id, category, subcategory, season, name, description, host_note, town, is_active, published_at)";
const TAGGED_COLUMNS =
  "sort_order, guest_tags, recommendations(id, category, subcategory, season, name, description, host_note, town, is_active, published_at)";
const FULL_COLUMNS =
  "sort_order, recommendations(id, category, subcategory, season, name, description, host_note, town, is_active, published_at)";
const BASIC_COLUMNS =
  "sort_order, recommendations(id, category, season, name, description, host_note, is_active, published_at)";

function activeSiteId() {
  return siteIdForKey(getSiteKey());
}

export type ThingsResult =
  | { ok: true; propertySlug: string; propertyName: string; places: ThingToDo[] }
  | { ok: false; error: "not_found" | "unavailable" };

export const getThingsToDo = cache(async (slug: string): Promise<ThingsResult> => {
  if (!propertySlugSchema.safeParse(slug).success) return { ok: false, error: "not_found" };

  const supabase = getSupabase();
  if (!supabase) return { ok: true, propertySlug: slug, propertyName: "This stay", places: [] };

  await connection();
  const siteKey = getSiteKey();
  const scopedProperty = await supabase
    .from("properties")
    .select("id, site_id, slug, name")
    .eq("slug", slug)
    .eq("status", "published")
    .eq("site_id", activeSiteId())
    .maybeSingle();

  let property = scopedProperty.data;
  let propertyError = scopedProperty.error;
  if (propertyError && /site_id/.test(propertyError.message) && siteKey === "roost") {
    const legacy = await supabase
      .from("properties")
      .select("id, slug, name")
      .eq("slug", slug)
      .eq("status", "published")
      .maybeSingle();
    property = legacy.data as typeof property;
    propertyError = legacy.error;
  }

  if (propertyError) {
    rethrowPrerenderAbort(propertyError);
    console.error(`[guidebook] things property: ${propertyError.message}`);
    return { ok: false, error: "unavailable" };
  }
  if (!property) return { ok: false, error: "not_found" };
  if (
    "site_id" in property &&
    property.site_id &&
    !propertyBelongsToSite({ site_id: property.site_id as string }, siteKey)
  ) {
    return { ok: false, error: "not_found" };
  }

  const voice = await supabase
    .from("property_recommendations")
    .select(VOICE_COLUMNS)
    .eq("property_id", property.id)
    .not("published_at", "is", null)
    .order("sort_order", { ascending: true });

  let rows = (voice.data ?? []) as unknown as LinkRow[];
  let listError = voice.error;
  if (listError && /host_note|custom_description|Could not find the 'id' column/i.test(listError.message)) {
    const tagged = await supabase
      .from("property_recommendations")
      .select(TAGGED_COLUMNS)
      .eq("property_id", property.id)
      .not("published_at", "is", null)
      .order("sort_order", { ascending: true });
    rows = (tagged.data ?? []) as unknown as LinkRow[];
    listError = tagged.error;
  }
  if (listError && /guest_tags/.test(listError.message)) {
    const full = await supabase
      .from("property_recommendations")
      .select(FULL_COLUMNS)
      .eq("property_id", property.id)
      .not("published_at", "is", null)
      .order("sort_order", { ascending: true });
    rows = (full.data ?? []) as unknown as LinkRow[];
    listError = full.error;
  }
  if (listError) {
    rethrowPrerenderAbort(listError);
    const missingColumn = /subcategory|town/.test(listError.message);
    if (!missingColumn) {
      console.error(`[guidebook] things: ${listError.message}`);
      return { ok: false, error: "unavailable" };
    }
    const basic = await supabase
      .from("property_recommendations")
      .select(BASIC_COLUMNS)
      .eq("property_id", property.id)
      .not("published_at", "is", null)
      .order("sort_order", { ascending: true });
    if (basic.error) {
      rethrowPrerenderAbort(basic.error);
      console.error(`[guidebook] things: ${basic.error.message}`);
      return { ok: false, error: "unavailable" };
    }
    rows = (basic.data ?? []) as unknown as LinkRow[];
  }

  const joined = rows.flatMap((row) => {
    const recommendation = Array.isArray(row.recommendations) ? row.recommendations[0] : row.recommendations;
    if (!recommendation?.is_active || !recommendation.published_at || !recommendation.name?.trim()) return [];
    return [
      {
        sort: row.sort_order,
        linkId: row.id ?? null,
        linkHostNote: row.host_note ?? null,
        linkDescription: row.custom_description ?? null,
        recommendation,
        tags: guestTags(row.guest_tags),
      },
    ];
  });
  const hasSections = stayHasThingSections(
    joined.map((item) => ({
      subcategory: item.recommendation.subcategory ?? null,
      category: item.recommendation.category,
    })),
  );

  const copy = await loadCopy();
  const places = joined.flatMap((item): ThingToDo[] => {
    const recommendation = item.recommendation;
    const section = sectionForPlace(
      { subcategory: recommendation.subcategory ?? null, category: recommendation.category },
      hasSections,
    );
    if (!section) return [];
    const name = recommendation.name!.trim();
    const town = recommendation.town?.trim() || null;
    const englishDescription = linkDescription({
      customDescription: item.linkDescription,
      recommendationDescription: recommendation.description,
    });
    const tip = linkHostTip({
      linkId: item.linkId,
      linkHostNote: item.linkHostNote,
      recommendationId: recommendation.id,
      recommendationHostNote: recommendation.host_note,
    });
    return [
      {
        id: recommendation.id,
        name,
        town,
        description: thingTip(
          copyText(copy, "recommendations", recommendation.id, "description", englishDescription),
        ),
        tip: thingTip(copyText(copy, tip.table, tip.id, "host_note", tip.english)),
        section,
        season: thingSeason(recommendation.season),
        tags: item.tags,
        directionsUrl: directionsUrl(name, town),
        photo: recommendationPhoto(name),
      },
    ];
  });

  return { ok: true, propertySlug: property.slug, propertyName: property.name, places };
});

type StopJoin = {
  id: string;
  time_label: string;
  name: string | null;
  detail: string | null;
  sort_order: number;
  recommendations: RecommendationJoin | RecommendationJoin[] | null;
};

type DayJoin = {
  id: string;
  season: string;
  title: string | null;
  itinerary_stops: StopJoin[] | null;
};

export const getPerfectDays = cache(async (slug: string): Promise<PerfectDay[]> => {
  if (!propertySlugSchema.safeParse(slug).success) return [];
  const supabase = getSupabase();
  if (!supabase) return [];

  await connection();
  const siteKey = getSiteKey();
  const scopedProperty = await supabase
    .from("properties")
    .select("id, site_id")
    .eq("slug", slug)
    .eq("status", "published")
    .eq("site_id", activeSiteId())
    .maybeSingle();

  let property = scopedProperty.data;
  let propertyError = scopedProperty.error;
  if (propertyError && /site_id/.test(propertyError.message) && siteKey === "roost") {
    const legacy = await supabase
      .from("properties")
      .select("id")
      .eq("slug", slug)
      .eq("status", "published")
      .maybeSingle();
    property = legacy.data as typeof property;
    propertyError = legacy.error;
  }

  if (propertyError) {
    rethrowPrerenderAbort(propertyError);
    console.error(`[guidebook] perfect day property: ${propertyError.message}`);
    return [];
  }
  if (!property) return [];
  if (
    "site_id" in property &&
    property.site_id &&
    !propertyBelongsToSite({ site_id: property.site_id as string }, siteKey)
  ) {
    return [];
  }

  const copy = await loadCopy();
  const locale = await getLocale();
  const { data, error } = await supabase
    .from("itineraries")
    .select(
      "id, season, title, itinerary_stops(id, time_label, name, detail, sort_order, recommendations(id, category, subcategory, season, name, description, host_note, town, is_active, published_at))",
    )
    .eq("property_id", property.id)
    .eq("is_visible", true)
    .not("published_at", "is", null);

  if (error) {
    rethrowPrerenderAbort(error);
    if (!/itineraries|schema cache|itinerary_stops/i.test(error.message)) {
      console.error(`[guidebook] perfect day: ${error.message}`);
    }
    return [];
  }

  return ((data ?? []) as unknown as DayJoin[]).flatMap((day) => {
    if (day.season !== "fall" && day.season !== "winter") return [];
    const stops = (day.itinerary_stops ?? [])
      .slice()
      .sort((a, b) => a.sort_order - b.sort_order)
      .flatMap((stop) => {
        const name = stop.name?.trim() ?? "";
        const detail = stop.detail?.trim() ?? "";
        if (!name || !detail) return [];
        const recommendation = Array.isArray(stop.recommendations) ? stop.recommendations[0] : stop.recommendations;
        return [
          {
            id: stop.id,
            timeLabel: copyText(copy, "itinerary_stops", stop.id, "time_label", stop.time_label) ?? stop.time_label,
            name,
            detail: copyText(copy, "itinerary_stops", stop.id, "detail", detail) ?? detail,
            place: toPlace(recommendation, copy),
          },
        ];
      });
    if (stops.length === 0) return [];
    return [
      {
        season: day.season as PerfectDaySeason,
        title: copyText(copy, "itineraries", day.id, "title", day.title)?.trim() || t(locale, "perfectDay"),
        stops,
      },
    ];
  });
});

function toPlace(
  recommendation: RecommendationJoin | null | undefined,
  copy: Awaited<ReturnType<typeof loadCopy>>,
): ThingToDo | null {
  if (!recommendation?.is_active || !recommendation.published_at || !recommendation.name?.trim()) return null;
  const section = sectionForPlace(
    { subcategory: recommendation.subcategory ?? null, category: recommendation.category },
    true,
  );
  const name = recommendation.name.trim();
  const town = recommendation.town?.trim() || null;
  return {
    id: recommendation.id,
    name,
    town,
    description: thingTip(copyText(copy, "recommendations", recommendation.id, "description", recommendation.description)),
    tip: thingTip(copyText(copy, "recommendations", recommendation.id, "host_note", recommendation.host_note)),
    section: section ?? "see",
    season: thingSeason(recommendation.season),
    directionsUrl: directionsUrl(name, town),
    photo: recommendationPhoto(name),
  };
}

function rethrowPrerenderAbort(error: { message: string; digest?: string }) {
  if (error.digest === "HANGING_PROMISE_REJECTION" || error.message.includes("During prerendering,")) {
    const abort = new Error(error.message);
    (abort as Error & { digest: string }).digest = error.digest ?? "HANGING_PROMISE_REJECTION";
    throw abort;
  }
}
