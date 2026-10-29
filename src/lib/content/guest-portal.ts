export const RADDISH_GUEST_PORTAL_URL =
  "https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su";

export const EARLY_CHECK_IN_TITLE = "Want to arrive early?";

export const EARLY_CHECK_IN_TEXT =
  "You can request an earlier check-in through your guest portal. We'll send you the link with your booking. To log in, enter the booker's last name or phone number.";

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
