export const GUEST_NOTE_TITLE = "Something not right?";

export const GUEST_NOTE_TEXT =
  "Let us know right away and we'll do our best to fix it. You'll usually hear back within an hour.";

export const GUEST_NOTE_SENT = "Thanks. We got your note and we'll get back to you.";

export const EMERGENCY_COPY =
  "For immediate danger, call 911. Property emergency contacts have not been added.";

export const REVIEW_NOTE =
  "Thanks for staying with us! If you enjoyed your stay, we'd be so grateful for a review. You'll get a review request from Airbnb or VRBO after checkout.";

const WINDOW_MS = 60 * 60 * 1000;
const LIMIT = 5;
const hits = new Map<string, number[]>();

export function clearGuestNoteLimits() {
  hits.clear();
}

export function guestNoteBlocked(visitorHash: string, now = Date.now()) {
  const recent = (hits.get(visitorHash) ?? []).filter((time) => now - time < WINDOW_MS);
  hits.set(visitorHash, recent);
  return recent.length >= LIMIT;
}

export function rememberGuestNote(visitorHash: string, now = Date.now()) {
  const recent = (hits.get(visitorHash) ?? []).filter((time) => now - time < WINDOW_MS);
  recent.push(now);
  hits.set(visitorHash, recent);
}

export type GuestNoteInput = {
  name: string;
  message: string;
  propertySlug: string;
  honeypot: string;
};

export type GuestNoteResult = { status: "sent" } | { status: "error"; message: string };

export type GuestNoteCheck =
  | { ok: true; ignore: true }
  | { ok: true; ignore: false; name: string | null; message: string; propertySlug: string }
  | { ok: false; error: string };

const SLUG = /^[a-z0-9]+(-[a-z0-9]+)*$/;

export function validateGuestNote(input: GuestNoteInput): GuestNoteCheck {
  if (input.honeypot.trim().length > 0) return { ok: true, ignore: true };

  const name = input.name.trim();
  const message = input.message.trim();
  const propertySlug = input.propertySlug.trim().toLowerCase();

  if (!SLUG.test(propertySlug)) return { ok: false, error: "Choose a stay." };
  if (name.length > 120) return { ok: false, error: "Name is too long." };
  if (message.length === 0) return { ok: false, error: "Tell us what's going on." };
  if (message.length > 5000) return { ok: false, error: "That note is too long." };

  return { ok: true, ignore: false, name: name.length > 0 ? name : null, message, propertySlug };
}
