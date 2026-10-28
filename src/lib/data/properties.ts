import "server-only";

import { cache } from "react";
import { brandNameFromValue, DEFAULT_BRAND_NAME } from "@/lib/brand";
import {
  previewProperties,
  previewProperty,
  toPropertyGuide,
  toPropertySummary,
  type ContactRow,
  type PropertyRow,
  type SectionRow,
  type WifiRow,
} from "@/lib/data/map-content";
import { getSupabase } from "@/lib/supabase/server";
import { getSupabaseEnv } from "@/lib/supabase/env";
import { propertySlugSchema } from "@/lib/validation/slug";
import type { ContentResult, PropertyResult, PropertySummary } from "@/types/content";

const PROPERTY_COLUMNS =
  "id, slug, name, tagline, description, welcome_title, welcome_message, check_in_time, check_out_time, parking_summary, hero_image_path, sort_order";

function logSupabaseError(scope: string, message: string) {
  console.error(`[guidebook] ${scope}: ${message}`);
}

export const getBrandName = cache(async (): Promise<string> => {
  const supabase = getSupabase();
  if (!supabase) return DEFAULT_BRAND_NAME;

  const { data, error } = await supabase
    .from("site_settings")
    .select("value")
    .eq("key", "brand_name")
    .maybeSingle();

  if (error) {
    logSupabaseError("brand", error.message);
    return DEFAULT_BRAND_NAME;
  }

  return brandNameFromValue(data?.value);
});

export const getPublishedProperties = cache(async (): Promise<ContentResult<PropertySummary[]>> => {
  const supabase = getSupabase();
  if (!supabase) {
    return { ok: true, source: "preview", data: previewProperties() };
  }

  const env = getSupabaseEnv();
  const { data, error } = await supabase
    .from("properties")
    .select(PROPERTY_COLUMNS)
    .eq("status", "published")
    .order("sort_order", { ascending: true });

  if (error) {
    logSupabaseError("properties", error.message);
    return { ok: false, error: "unavailable" };
  }

  const rows = (data ?? []) as PropertyRow[];
  return {
    ok: true,
    source: "database",
    data: rows.map((row) => toPropertySummary(row, env?.url ?? null)),
  };
});

export const getPropertyGuide = cache(async (slug: string): Promise<PropertyResult> => {
  if (!propertySlugSchema.safeParse(slug).success) {
    return { ok: false, error: "not_found" };
  }

  const supabase = getSupabase();
  if (!supabase) {
    const property = previewProperty(slug);
    if (!property) return { ok: false, error: "not_found" };
    return { ok: true, source: "preview", property };
  }

  const env = getSupabaseEnv();
  const { data, error } = await supabase
    .from("properties")
    .select(PROPERTY_COLUMNS)
    .eq("slug", slug)
    .eq("status", "published")
    .maybeSingle();

  if (error) {
    logSupabaseError("property", error.message);
    return { ok: false, error: "unavailable" };
  }
  if (!data) return { ok: false, error: "not_found" };

  const property = data as PropertyRow;
  const [sectionsResult, wifiResult, contactsResult] = await Promise.all([
    supabase
      .from("guidebook_sections")
      .select("slug, title, summary, section_type, sort_order")
      .eq("property_id", property.id)
      .eq("is_visible", true)
      .order("sort_order", { ascending: true }),
    supabase
      .from("property_wifi")
      .select("network_name, password, router_note")
      .eq("property_id", property.id)
      .eq("is_public", true)
      .maybeSingle(),
    supabase
      .from("contact_channels")
      .select("channel, label, value")
      .eq("property_id", property.id)
      .eq("is_public", true)
      .order("sort_order", { ascending: true }),
  ]);

  if (sectionsResult.error) {
    logSupabaseError("sections", sectionsResult.error.message);
    return { ok: false, error: "unavailable" };
  }
  if (wifiResult.error) {
    logSupabaseError("wifi", wifiResult.error.message);
    return { ok: false, error: "unavailable" };
  }
  if (contactsResult.error) {
    logSupabaseError("contacts", contactsResult.error.message);
    return { ok: false, error: "unavailable" };
  }

  return {
    ok: true,
    source: "database",
    property: toPropertyGuide(
      property,
      (sectionsResult.data ?? []) as SectionRow[],
      (wifiResult.data as WifiRow | null) ?? null,
      (contactsResult.data ?? []) as ContactRow[],
      env?.url ?? null,
    ),
  };
});
