import "server-only";

import { createHash, randomBytes } from "node:crypto";
import { cookies, headers } from "next/headers";
import { guestNoteBlocked, rememberGuestNote, validateGuestNote, type GuestNoteResult } from "@/lib/content/guest-note";
import { getSupabase } from "@/lib/supabase/server";

export type { GuestNoteResult };

export async function submitGuestNote(formData: FormData): Promise<GuestNoteResult> {
  const checked = validateGuestNote({
    name: String(formData.get("name") ?? ""),
    message: String(formData.get("message") ?? ""),
    propertySlug: String(formData.get("property") ?? ""),
    honeypot: String(formData.get("company") ?? ""),
  });

  if (!checked.ok) return { status: "error", message: checked.error };
  if (checked.ignore) return { status: "sent" };

  const visitorHash = await visitorHashFromRequest();
  if (guestNoteBlocked(visitorHash)) {
    return { status: "error", message: "Please wait a bit and try again." };
  }

  const supabase = getSupabase();
  if (!supabase) return { status: "error", message: "We couldn't send that just now. Please try again." };

  const { error } = await supabase.rpc("submit_guest_note", {
    p_name: checked.name,
    p_message: checked.message,
    p_property_slug: checked.propertySlug,
    p_visitor_hash: visitorHash,
  });

  if (error) {
    if (/wait a bit/i.test(error.message)) {
      return { status: "error", message: "Please wait a bit and try again." };
    }
    console.error("[guidebook] guest note:", error.message);
    return { status: "error", message: "We couldn't send that just now. Please try again." };
  }

  rememberGuestNote(visitorHash);
  return { status: "sent" };
}

async function visitorHashFromRequest() {
  const headerList = await headers();
  const cookieStore = await cookies();
  let visitor = cookieStore.get("rr_guest")?.value ?? "";
  if (!/^[a-f0-9]{32}$/.test(visitor)) {
    visitor = randomBytes(16).toString("hex");
    cookieStore.set("rr_guest", visitor, {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      path: "/",
      maxAge: 60 * 60 * 24 * 365,
    });
  }
  const ip = headerList.get("x-forwarded-for")?.split(",")[0]?.trim() || "local";
  return createHash("sha256").update(`${visitor}:${ip}`).digest("hex");
}
