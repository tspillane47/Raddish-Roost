import { describe, expect, it } from "vitest";
import { mapsSearchUrl, nearbyForTown, nearbyHref } from "@/lib/content/nearby";
import { VERMONT_101 } from "@/lib/content/vermont-101";
import { parseForecast, weatherLine } from "@/lib/content/weather";

describe("weather lines", () => {
  it("uses a short seasonal line and stays quiet otherwise", () => {
    const october = new Date(2026, 9, 30);
    expect(weatherLine(0, october.getMonth())).toBe("Peak foliage season. Perfect day for a scenic drive.");
    expect(weatherLine(61, october.getMonth())).toBe(
      "Rainy day? Check the Rainy Day picks in Things to Do.",
    );
    expect(weatherLine(73, october.getMonth())).toBe("Fresh snow! Great day for the mountain.");
    expect(weatherLine(0, 6)).toBeNull();
    expect(weatherLine(0, 9)).not.toContain("—");
  });

  it("reads a three-day Open-Meteo forecast", () => {
    const snapshot = parseForecast(
      {
        current: { temperature_2m: 48.4, weather_code: 2 },
        daily: {
          time: ["2026-10-30", "2026-10-31", "2026-11-01"],
          weather_code: [2, 61, 0],
          temperature_2m_max: [55.2, 49, 52],
          temperature_2m_min: [38.6, 40, 33],
        },
      },
      new Date(2026, 9, 30),
    );
    expect(snapshot?.temp).toBe(48);
    expect(snapshot?.high).toBe(55);
    expect(snapshot?.low).toBe(39);
    expect(snapshot?.days.map((day) => day.label)[0]).toBe("Today");
    expect(snapshot?.days).toHaveLength(3);
    expect(snapshot?.line).toBe("Peak foliage season. Perfect day for a scenic drive.");
    expect(parseForecast({ current: { temperature_2m: 40 } })).toBeNull();
  });
});

describe("nearby essentials", () => {
  it("builds a Google Maps search and keeps the hospital note", () => {
    const items = nearbyForTown("Waterbury, VT");
    expect(items.map((item) => item.label)).toEqual([
      "Grocery store",
      "Pharmacy",
      "Gas station",
      "Urgent care",
      "Hospital (ER)",
    ]);
    expect(items[0]?.href).toBe(mapsSearchUrl("grocery store near Waterbury, VT"));
    expect(items[4]?.note).toBe("For emergencies, call 911.");
    expect(items[0]?.note).toBeNull();
    expect(nearbyHref("https://maps.example/store", "grocery store near Waterbury, VT")).toBe(
      "https://maps.example/store",
    );
  });
});

describe("Vermont 101", () => {
  it("keeps the short host notes and the road conditions link", () => {
    const copy = VERMONT_101.map((item) => ("body" in item ? item.body : `${item.before}${item.linkLabel}${item.after}`)).join(
      " ",
    );
    expect(copy).toContain("Vermont's word for soft serve. Try a maple creemee.");
    expect(copy).toContain("Vermont makes more maple syrup than any other state.");
    expect(copy).toContain("late March into May");
    expect(copy).toContain("late September through mid October");
    expect(copy).toContain("newengland511.org");
    expect(copy).toContain("one of the most breweries per person");
    expect(copy).toContain("Pack out what you bring in");
    expect(VERMONT_101.find((item) => item.id === "winter")).toMatchObject({
      href: "https://newengland511.org",
    });
    expect(copy).not.toContain("—");
    expect(copy).not.toContain("Radish");
  });
});
