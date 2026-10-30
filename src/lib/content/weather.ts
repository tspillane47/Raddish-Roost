/** Town centers, not street addresses. */
export const TOWN_COORDINATES: Record<string, { latitude: number; longitude: number }> = {
  "raddish-roost": { latitude: 44.3378, longitude: -72.7562 },
  "shallot-chalet": { latitude: 44.4914, longitude: -73.1854 },
  "onion-ranch": { latitude: 44.4914, longitude: -73.1854 },
};

export type WeatherDay = {
  label: string;
  code: number;
  high: number;
  low: number;
};

export type WeatherSnapshot = {
  temp: number;
  code: number;
  high: number;
  low: number;
  days: WeatherDay[];
  line: string | null;
};

const SNOW_LINE = "Fresh snow! Great day for the mountain.";
const RAIN_LINE = "Rainy day? Check the Rainy Day picks in Things to Do.";
const FALL_LINE = "Peak foliage season. Perfect day for a scenic drive.";

export function weatherCondition(code: number): string {
  if (code === 0) return "Clear";
  if (code === 1) return "Mainly clear";
  if (code === 2) return "Partly cloudy";
  if (code === 3) return "Cloudy";
  if (code === 45 || code === 48) return "Fog";
  if ((code >= 51 && code <= 57) || code === 80) return "Drizzle";
  if ((code >= 61 && code <= 67) || code === 81 || code === 82) return "Rain";
  if ((code >= 71 && code <= 77) || code === 85 || code === 86) return "Snow";
  if (code >= 95) return "Thunderstorm";
  return "Cloudy";
}

function isRain(code: number): boolean {
  return (code >= 51 && code <= 67) || (code >= 80 && code <= 82) || code >= 95;
}

function isSnow(code: number): boolean {
  return (code >= 71 && code <= 77) || code === 85 || code === 86;
}

/** Snow, then rain, then foliage in September, October, and November. */
export function weatherLine(code: number, month: number): string | null {
  if (isSnow(code)) return SNOW_LINE;
  if (isRain(code)) return RAIN_LINE;
  if (month >= 8 && month <= 10) return FALL_LINE;
  return null;
}

type ForecastJson = {
  current?: { temperature_2m?: unknown; weather_code?: unknown };
  daily?: {
    time?: unknown;
    weather_code?: unknown;
    temperature_2m_max?: unknown;
    temperature_2m_min?: unknown;
  };
};

function numberAt(value: unknown, index?: number): number | null {
  const raw = index === undefined ? value : Array.isArray(value) ? value[index] : undefined;
  const parsed = typeof raw === "number" ? raw : typeof raw === "string" ? Number(raw) : NaN;
  return Number.isFinite(parsed) ? Math.round(parsed) : null;
}

function codeAt(value: unknown, index?: number): number | null {
  const raw = index === undefined ? value : Array.isArray(value) ? value[index] : undefined;
  const parsed = typeof raw === "number" ? raw : typeof raw === "string" ? Number(raw) : NaN;
  return Number.isInteger(parsed) ? parsed : null;
}

export function parseForecast(payload: unknown, today = new Date()): WeatherSnapshot | null {
  if (!payload || typeof payload !== "object") return null;
  const body = payload as ForecastJson;
  const temp = numberAt(body.current?.temperature_2m);
  const code = codeAt(body.current?.weather_code);
  const times = Array.isArray(body.daily?.time) ? body.daily.time : [];
  if (temp === null || code === null || times.length < 3) return null;

  const days: WeatherDay[] = [];
  for (let index = 0; index < 3; index += 1) {
    const high = numberAt(body.daily?.temperature_2m_max, index);
    const low = numberAt(body.daily?.temperature_2m_min, index);
    const dayCode = codeAt(body.daily?.weather_code, index);
    const time = times[index];
    if (high === null || low === null || dayCode === null || typeof time !== "string") return null;
    days.push({
      label: index === 0 ? "Today" : weekdayLabel(time),
      code: dayCode,
      high,
      low,
    });
  }

  const todayForecast = days[0];
  if (!todayForecast) return null;
  return {
    temp,
    code,
    high: todayForecast.high,
    low: todayForecast.low,
    days,
    line: weatherLine(code, today.getMonth()),
  };
}

function weekdayLabel(isoDate: string): string {
  const date = new Date(`${isoDate}T12:00:00`);
  if (Number.isNaN(date.getTime())) return isoDate;
  return date.toLocaleDateString("en-US", { weekday: "short", timeZone: "America/New_York" });
}
