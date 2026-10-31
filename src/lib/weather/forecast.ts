import "server-only";

import { cacheLife } from "next/cache";
import { parseForecast, type WeatherSnapshot } from "@/lib/content/weather";

export async function getStayWeather(latitude: number, longitude: number): Promise<WeatherSnapshot | null> {
  "use cache";
  cacheLife({ stale: 60 * 30, revalidate: 60 * 30, expire: 60 * 60 });

  if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) return null;
  if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) return null;

  try {
    const url = new URL("https://api.open-meteo.com/v1/forecast");
    url.searchParams.set("latitude", latitude.toFixed(4));
    url.searchParams.set("longitude", longitude.toFixed(4));
    url.searchParams.set("current", "temperature_2m,weather_code");
    url.searchParams.set("daily", "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset");
    url.searchParams.set("temperature_unit", "fahrenheit");
    url.searchParams.set("timezone", "America/New_York");
    url.searchParams.set("forecast_days", "3");
    const response = await fetch(url, { cache: "no-store" });
    if (!response.ok) return null;
    return parseForecast(await response.json());
  } catch (error) {
    console.error("[guidebook] weather:", error instanceof Error ? error.message : "unavailable");
    return null;
  }
}
