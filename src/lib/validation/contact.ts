const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const phonePattern = /^\+?[0-9().\-\s]{7,20}$/;

export type ContactChannel = "airbnb" | "email" | "phone" | "sms";

export function toContactHref(channel: ContactChannel, value: string): string | null {
  const trimmed = value.trim();
  if (channel === "email" && emailPattern.test(trimmed)) {
    return `mailto:${trimmed}`;
  }
  if ((channel === "phone" || channel === "sms") && phonePattern.test(trimmed)) {
    const digits = trimmed.replace(/[^\d+]/g, "");
    if (digits.replace(/\D/g, "").length < 7) return null;
    return channel === "sms" ? `sms:${digits}` : `tel:${digits}`;
  }
  if (channel === "airbnb") {
    try {
      const url = new URL(trimmed);
      if (url.protocol === "https:") return url.toString();
    } catch {
      return null;
    }
  }
  return null;
}
