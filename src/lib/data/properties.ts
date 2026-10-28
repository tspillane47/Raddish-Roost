import "server-only";

import { connection } from "next/server";
import { cache } from "react";
import { toBookingLinks, type BookingRow } from "@/lib/content/booking-links";
import { brandNameFromValue, DEFAULT_BRAND_NAME } from "@/lib/brand";
import {
  previewGuideSection,
  previewProperties,
  previewProperty,
  toGuideBlocks,
  toPropertyGuide,
  toPropertySummary,
  type BlockRow,
  type ContactRow,
  type PropertyRow,
  type SectionRow,
  type WifiRow,
} from "@/lib/data/map-content";
import { getSupabase } from "@/lib/supabase/server";
import { getSupabaseEnv } from "@/lib/supabase/env";
import { propertySlugSchema } from "@/lib/validation/slug";
import type { ContentResult, PropertyResult, PropertySummary, SectionResult } from "@/types/content";

const PROPERTY_COLUMNS =
  "id, slug, name, tagline, description, welcome_title, welcome_message, check_in_time, check_out_time, parking_summary, hero_image_path, sort_order";

function logSupabaseError(scope: string, message: string) {
  console.error(`[guidebook] ${scope}: ${message}`);
}

/**
 * Cache Components aborts in-flight fetches when the static shell is done.
 * Supabase reports that abort as a query error. Rethrow it so the page waits
 * for the real request instead of rendering the "couldn't be loaded" state.
 */
function rethrowPrerenderAbort(error: { message: string; digest?: string }) {
  if (
    error.digest === "HANGING_PROMISE_REJECTION" ||
    error.message.includes("During prerendering,")
  ) {
    const abort = new Error(error.message);
    (abort as Error & { digest: string }).digest = error.digest ?? "HANGING_PROMISE_REJECTION";
    throw abort;
  }
}

async function whenServingRequest() {
  await connection();
}

export const getBrandName = cache(async (): Promise<string> => {
  const supabase = getSupabase();
  if (!supabase) return DEFAULT_BRAND_NAME;
  await whenServingRequest();

  const { data, error } = await supabase
    .from("site_settings")
    .select("value")
    .eq("key", "brand_name")
    .maybeSingle();

  if (error) {
    rethrowPrerenderAbort(error);
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

  await whenServingRequest();
  const env = getSupabaseEnv();
  const { data, error } = await supabase
    .from("properties")
    .select(PROPERTY_COLUMNS)
    .eq("status", "published")
    .order("sort_order", { ascending: true });

  if (error) {
    rethrowPrerenderAbort(error);
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

  await whenServingRequest();
  const env = getSupabaseEnv();
  const { data, error } = await supabase
    .from("properties")
    .select(PROPERTY_COLUMNS)
    .eq("slug", slug)
    .eq("status", "published")
    .maybeSingle();

  if (error) {
    rethrowPrerenderAbort(error);
    logSupabaseError("property", error.message);
    return { ok: false, error: "unavailable" };
  }
  if (!data) return { ok: false, error: "not_found" };

  const property = data as PropertyRow;
  const [sectionsResult, wifiResult, contactsResult, bookingsResult] = await Promise.all([
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
    supabase
      .from("booking_links")
      .select("channel, url, sort_order")
      .eq("property_id", property.id)
      .order("sort_order", { ascending: true }),
  ]);

  if (sectionsResult.error) {
    rethrowPrerenderAbort(sectionsResult.error);
    logSupabaseError("sections", sectionsResult.error.message);
    return { ok: false, error: "unavailable" };
  }
  if (wifiResult.error) {
    rethrowPrerenderAbort(wifiResult.error);
    logSupabaseError("wifi", wifiResult.error.message);
    return { ok: false, error: "unavailable" };
  }
  if (contactsResult.error) {
    rethrowPrerenderAbort(contactsResult.error);
    logSupabaseError("contacts", contactsResult.error.message);
    return { ok: false, error: "unavailable" };
  }
  if (bookingsResult.error) {
    rethrowPrerenderAbort(bookingsResult.error);
    logSupabaseError("bookings", bookingsResult.error.message);
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
      (bookingsResult.data ?? []) as BookingRow[],
      env?.url ?? null,
    ),
  };
});

export const getGuideSection = cache(
  async (propertySlug: string, sectionSlug: string): Promise<SectionResult> => {
    if (
      !propertySlugSchema.safeParse(propertySlug).success ||
      !propertySlugSchema.safeParse(sectionSlug).success
    ) {
      return { ok: false, error: "not_found" };
    }

    const supabase = getSupabase();
    if (!supabase) {
      const section = previewGuideSection(propertySlug, sectionSlug);
      if (!section) return { ok: false, error: "not_found" };
      return { ok: true, source: "preview", section };
    }

    await whenServingRequest();
    const env = getSupabaseEnv();
    const { data: property, error: propertyError } = await supabase
      .from("properties")
      .select("id, slug, name")
      .eq("slug", propertySlug)
      .eq("status", "published")
      .maybeSingle();

    if (propertyError) {
      rethrowPrerenderAbort(propertyError);
      logSupabaseError("section-property", propertyError.message);
      return { ok: false, error: "unavailable" };
    }
    if (!property) return { ok: false, error: "not_found" };

    const { data: section, error: sectionError } = await supabase
      .from("guidebook_sections")
      .select("id, slug, title, summary")
      .eq("property_id", property.id)
      .eq("slug", sectionSlug)
      .eq("is_visible", true)
      .not("published_at", "is", null)
      .maybeSingle();

    if (sectionError) {
      rethrowPrerenderAbort(sectionError);
      logSupabaseError("section", sectionError.message);
      return { ok: false, error: "unavailable" };
    }
    if (!section) return { ok: false, error: "not_found" };

    const { data: blocks, error: blocksError } = await supabase
      .from("guidebook_blocks")
      .select("id, title, body, sort_order")
      .eq("section_id", section.id)
      .not("published_at", "is", null)
      .order("sort_order", { ascending: true });

    if (blocksError) {
      rethrowPrerenderAbort(blocksError);
      logSupabaseError("blocks", blocksError.message);
      return { ok: false, error: "unavailable" };
    }

    let bookings: BookingRow[] = [];
    if (section.slug === "stay-again") {
      const { data: bookingRows, error: bookingsError } = await supabase
        .from("booking_links")
        .select("channel, url, sort_order")
        .eq("property_id", property.id)
        .order("sort_order", { ascending: true });

      if (bookingsError) {
        rethrowPrerenderAbort(bookingsError);
        logSupabaseError("section-bookings", bookingsError.message);
        return { ok: false, error: "unavailable" };
      }
      bookings = (bookingRows ?? []) as BookingRow[];
    }

    return {
      ok: true,
      source: "database",
      section: {
        propertySlug: property.slug,
        propertyName: property.name,
        slug: section.slug,
        title: section.title?.trim() || "Guide section",
        summary: section.summary,
        blocks: toGuideBlocks((blocks ?? []) as BlockRow[], env?.url ?? null),
        bookings: toBookingLinks(bookings),
      },
    };
  },
);
