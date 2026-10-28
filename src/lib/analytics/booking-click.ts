import type { BookingChannel } from "@/lib/content/booking-links";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { getSupabaseEnv } from "@/lib/supabase/env";

export function trackBookingClick(propertySlug: string, platform: BookingChannel) {
  if (!getSupabaseEnv()) return;
  const path = window.location.pathname.slice(0, 300);

  void createBrowserSupabase()
    .from("analytics_events")
    .insert({
      event_name: "booking_click",
      property_slug: propertySlug,
      platform,
      path,
    })
    .then(({ error }) => {
      if (error) console.error("[guidebook] booking click:", error.message);
    });
}
