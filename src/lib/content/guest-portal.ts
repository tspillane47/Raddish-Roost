import { messages } from "@/lib/i18n/messages";

export const GUEST_PORTAL_URLS: Record<string, string> = {
  "raddish-roost":
    "https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su",
  "shallot-chalet": "https://stay.hospitable.com/53bf07d7-1177-43f0-bd73-36427f1b1289/upgrade?_t=sc_su",
  "onion-ranch":
    "https://stay.hospitable.com/72b4adbe-4aa2-4d62-a077-55829eeba0d1/login?returnUrl=%2F72b4adbe-4aa2-4d62-a077-55829eeba0d1%2Fupgrade%3F_t%3Dsc_su",
  "landing-pad": "https://stay.hospitable.com/6aed4c3b-8103-4db3-853f-5fd092dd3e52/upgrade?_t=sc_su",
  "backyard-bungalow": "https://stay.hospitable.com/46d5dd47-d2f7-465a-82e6-b0976953cb91/upgrade?_t=sc_su",
};

export const LATE_CHECKOUT_TITLE = messages.en.lateCheckoutTitle;

export const LATE_CHECKOUT_TEXT = messages.en.lateCheckoutText;

export function guestPortalUrl(value: string | null | undefined): string | null {
  const url = value?.trim() ?? "";
  if (!url.startsWith("https://")) return null;
  try {
    const parsed = new URL(url);
    if (parsed.protocol !== "https:") return null;
    return url;
  } catch {
    return null;
  }
}
