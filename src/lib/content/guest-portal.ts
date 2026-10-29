export const GUEST_PORTAL_URLS: Record<string, string> = {
  "raddish-roost":
    "https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su",
  "shallot-chalet": "https://stay.hospitable.com/53bf07d7-1177-43f0-bd73-36427f1b1289/upgrade?_t=sc_su",
  "onion-ranch":
    "https://stay.hospitable.com/72b4adbe-4aa2-4d62-a077-55829eeba0d1/login?returnUrl=%2F72b4adbe-4aa2-4d62-a077-55829eeba0d1%2Fupgrade%3F_t%3Dsc_su",
};

export const LATE_CHECKOUT_TITLE = "Want to stay a little longer?";

export const LATE_CHECKOUT_TEXT =
  "You can request a late checkout through your guest portal. Requests depend on availability. To log in, enter the booker's last name or phone number.";

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
