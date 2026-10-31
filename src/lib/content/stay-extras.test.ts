import { readFileSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { mapsSearchUrl, nearbyForTown, nearbyHref } from "@/lib/content/nearby";
import { VERMONT_101 } from "@/lib/content/vermont-101";
import {
  parseForecast,
  heroWeatherCount,
  heroWeatherKind,
  previewWeather,
  weatherLine,
  weatherPreviewScene,
  weatherView,
} from "@/lib/content/weather";

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
          sunrise: ["2026-10-30T07:20"],
          sunset: ["2026-10-30T17:45"],
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
    expect(snapshot?.sunrise).toBe("2026-10-30T07:20");
    expect(snapshot?.sunset).toBe("2026-10-30T17:45");
  });

  it("picks the sky from the code and the hour around sunrise and sunset", () => {
    const sunrise = "2026-10-30T07:20";
    const sunset = "2026-10-30T17:45";
    const at = (clock: string) => new Date(`2026-10-30T${clock}:00-04:00`);
    const view = (code: number, clock: string) => weatherView({ code, sunrise, sunset }, at(clock));

    expect(view(0, "15:00").scene).toBe("clear-day");
    expect(view(0, "18:20").scene).toBe("golden");
    expect(view(0, "22:00").scene).toBe("clear-night");
    expect(view(3, "15:00")).toMatchObject({ scene: "cloudy", clouds: 4, sun: false });
    expect(view(2, "15:00")).toMatchObject({ scene: "cloudy", partly: true, clouds: 2, sun: true });
    expect(view(61, "18:20").scene).toBe("rain");
    expect(view(65, "12:00").raindrops).toBe(36);
    expect(view(51, "12:00").raindrops).toBe(18);
    expect(view(73, "12:00")).toMatchObject({ scene: "snow", snowflakes: 32 });
    expect(view(45, "12:00").scene).toBe("fog");
    expect(view(95, "12:00")).toMatchObject({ scene: "storm", lightning: true, raindrops: 34 });
    expect(view(0, "22:00").stars).toBeLessThanOrEqual(40);
    expect(view(73, "12:00").snowflakes).toBeLessThanOrEqual(40);
    expect(view(65, "12:00").raindrops).toBeLessThanOrEqual(40);
  });

  it("keeps the weather preview in development", () => {
    expect(weatherPreviewScene("clear-night", "development")).toBe("clear-night");
    expect(weatherPreviewScene("golden", "development")).toBe("golden");
    expect(weatherPreviewScene("hail", "development")).toBeNull();
    expect(weatherPreviewScene("snow", "production")).toBeNull();
    expect(weatherPreviewScene("snow", "test")).toBeNull();
    expect(previewWeather("snow")).toMatchObject({ scene: "snow", temp: 28, code: 73 });
    expect(previewWeather("clear-day").line).not.toContain("—");
  });

  it("puts weather on the hero for snow, rain, storm, fog, and sun", () => {
    expect(heroWeatherKind(weatherView(previewWeather("clear-night")))).toBeNull();
    expect(heroWeatherKind(weatherView(previewWeather("cloudy")))).toBeNull();
    expect(heroWeatherKind(weatherView(previewWeather("clear-day")))).toBe("sun");
    expect(heroWeatherKind(weatherView(previewWeather("golden")))).toBe("sun");
    expect(heroWeatherKind(weatherView(previewWeather("snow")))).toBe("snow");
    expect(heroWeatherKind(weatherView(previewWeather("rain")))).toBe("rain");
    expect(heroWeatherKind(weatherView(previewWeather("storm")))).toBe("storm");
    expect(heroWeatherKind(weatherView(previewWeather("fog")))).toBe("fog");
    expect(heroWeatherCount("snow")).toBeLessThan(20);
    expect(heroWeatherCount("storm")).toBeGreaterThan(heroWeatherCount("rain"));
    expect(heroWeatherCount("storm")).toBeLessThanOrEqual(20);
    expect(heroWeatherCount("sun")).toBeLessThanOrEqual(6);
    const css = readFileSync(
      path.resolve(__dirname, "../../components/property/hero-weather.css"),
      "utf8",
    );
    expect(css).toContain("pointer-events: none");
    expect(css).toContain("prefers-reduced-motion");
    expect(css).toContain("display: none !important");
    expect(css).not.toContain("weather-flash");
    expect(css).not.toContain("hero-gust");
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
