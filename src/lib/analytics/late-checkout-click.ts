import { createBrowserSupabase } from "@/lib/supabase/browser";
import { getSupabaseEnv } from "@/lib/supabase/env";

export function trackLateCheckoutClick(propertySlug: string) {
  if (!getSupabaseEnv()) return;
  const path = window.location.pathname.slice(0, 300);

  void createBrowserSupabase()
    .from("analytics_events")
    .insert({
      event_name: "late_checkout_click",
      property_slug: propertySlug,
      path,
    })
    .then(({ error }) => {
      if (error) console.error("[guidebook] late checkout click:", error.message);
    });
}
