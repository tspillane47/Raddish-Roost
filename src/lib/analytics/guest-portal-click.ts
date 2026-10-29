import { createBrowserSupabase } from "@/lib/supabase/browser";
import { getSupabaseEnv } from "@/lib/supabase/env";

export function trackGuestPortalClick(propertySlug: string) {
  if (!getSupabaseEnv()) return;
  const path = window.location.pathname.slice(0, 300);

  void createBrowserSupabase()
    .from("analytics_events")
    .insert({
      event_name: "guest_portal_click",
      property_slug: propertySlug,
      path,
    })
    .then(({ error }) => {
      if (error) console.error("[guidebook] guest portal click:", error.message);
    });
}
