export const BOOKING_CHANNELS = ["direct", "airbnb", "vrbo"] as const;

export type BookingChannel = (typeof BOOKING_CHANNELS)[number];

export type BookingLink = {
  channel: BookingChannel;
  name: string;
  detail: string;
  url: string;
};

export type BookingRow = {
  channel: string;
  url: string;
};

const COPY: Record<BookingChannel, { name: string; detail: string }> = {
  direct: { name: "Book Direct", detail: "Book with us directly." },
  airbnb: { name: "Airbnb", detail: "Book this stay on Airbnb." },
  vrbo: { name: "VRBO", detail: "Book this stay on VRBO." },
};

export function toBookingLinks(rows: BookingRow[]): BookingLink[] {
  const chosen = new Map<BookingChannel, string>();

  for (const row of rows) {
    if (!isBookingChannel(row.channel) || chosen.has(row.channel)) continue;
    const url = httpsUrl(row.url);
    if (!url) continue;
    chosen.set(row.channel, url);
  }

  return BOOKING_CHANNELS.flatMap((channel) => {
    const url = chosen.get(channel);
    if (!url) return [];
    return [{ channel, url, ...COPY[channel] }];
  });
}

function isBookingChannel(value: string): value is BookingChannel {
  return (BOOKING_CHANNELS as readonly string[]).includes(value);
}

function httpsUrl(value: string): string | null {
  try {
    const url = new URL(value.trim());
    if (url.protocol !== "https:") return null;
    return url.href;
  } catch {
    return null;
  }
}
