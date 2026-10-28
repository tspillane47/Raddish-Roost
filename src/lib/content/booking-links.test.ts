import { describe, expect, it } from "vitest";
import { toBookingLinks } from "@/lib/content/booking-links";

describe("booking links", () => {
  it("keeps https links in direct, Airbnb, then VRBO order", () => {
    const links = toBookingLinks([
      { channel: "vrbo", url: "https://www.vrbo.com/stay" },
      { channel: "airbnb", url: "https://www.airbnb.com/rooms/1" },
      { channel: "direct", url: "https://example.com/book" },
      { channel: "other", url: "https://example.com/other" },
      { channel: "airbnb", url: "http://www.airbnb.com/rooms/2" },
      { channel: "direct", url: "javascript:alert(1)" },
    ]);

    expect(links.map((link) => link.channel)).toEqual(["direct", "airbnb", "vrbo"]);
    expect(links.map((link) => link.name)).toEqual(["Book Direct", "Airbnb", "VRBO"]);
    expect(links[0]?.url).toBe("https://example.com/book");
    expect(links[1]?.detail).toBe("Book this stay on Airbnb.");
    expect(JSON.stringify(links)).not.toContain("Best rate");
  });

  it("drops a stay that has no https booking link", () => {
    expect(toBookingLinks([{ channel: "airbnb", url: "http://www.airbnb.com/rooms/1" }])).toEqual([]);
  });
});
