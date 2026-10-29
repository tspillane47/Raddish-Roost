import "server-only";

import { connection } from "next/server";
import { cache } from "react";
import { recommendationPhoto } from "@/lib/content/recommendation-photos";
import {
  directionsUrl,
  sectionForPlace,
  stayHasThingSections,
  thingSeason,
  thingTip,
  type ThingToDo,
} from "@/lib/content/things-to-do";
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
  sort_order: number;
  recommendations: RecommendationJoin | RecommendationJoin[] | null;
};

const FULL_COLUMNS =
  "sort_order, recommendations(id, category, subcategory, season, name, description, host_note, town, is_active, published_at)";
const BASIC_COLUMNS =
  "sort_order, recommendations(id, category, season, name, description, host_note, is_active, published_at)";

export type ThingsResult =
  | { ok: true; propertySlug: string; propertyName: string; places: ThingToDo[] }
  | { ok: false; error: "not_found" | "unavailable" };

export const getThingsToDo = cache(async (slug: string): Promise<ThingsResult> => {
  if (!propertySlugSchema.safeParse(slug).success) return { ok: false, error: "not_found" };

  const supabase = getSupabase();
  if (!supabase) return { ok: true, propertySlug: slug, propertyName: "This stay", places: [] };

  await connection();
  const { data: property, error: propertyError } = await supabase
    .from("properties")
    .select("id, slug, name")
    .eq("slug", slug)
    .eq("status", "published")
    .maybeSingle();

  if (propertyError) {
    rethrowPrerenderAbort(propertyError);
    console.error(`[guidebook] things property: ${propertyError.message}`);
    return { ok: false, error: "unavailable" };
  }
  if (!property) return { ok: false, error: "not_found" };

  const full = await supabase
    .from("property_recommendations")
    .select(FULL_COLUMNS)
    .eq("property_id", property.id)
    .not("published_at", "is", null)
    .order("sort_order", { ascending: true });

  let rows = (full.data ?? []) as unknown as LinkRow[];
  if (full.error) {
    rethrowPrerenderAbort(full.error);
    const missingColumn = /subcategory|town/.test(full.error.message);
    if (!missingColumn) {
      console.error(`[guidebook] things: ${full.error.message}`);
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
    return [{ sort: row.sort_order, recommendation }];
  });
  const hasSections = stayHasThingSections(
    joined.map((item) => ({
      subcategory: item.recommendation.subcategory ?? null,
      category: item.recommendation.category,
    })),
  );

  const places = joined.flatMap((item): ThingToDo[] => {
    const recommendation = item.recommendation;
    const section = sectionForPlace(
      { subcategory: recommendation.subcategory ?? null, category: recommendation.category },
      hasSections,
    );
    if (!section) return [];
    const name = recommendation.name!.trim();
    const town = recommendation.town?.trim() || null;
    return [
      {
        id: recommendation.id,
        name,
        town,
        description: thingTip(recommendation.description),
        tip: thingTip(recommendation.host_note),
        section,
        season: thingSeason(recommendation.season),
        directionsUrl: directionsUrl(name, town),
        photo: recommendationPhoto(name),
      },
    ];
  });

  return { ok: true, propertySlug: property.slug, propertyName: property.name, places };
});

function rethrowPrerenderAbort(error: { message: string; digest?: string }) {
  if (error.digest === "HANGING_PROMISE_REJECTION" || error.message.includes("During prerendering,")) {
    const abort = new Error(error.message);
    (abort as Error & { digest: string }).digest = error.digest ?? "HANGING_PROMISE_REJECTION";
    throw abort;
  }
}
