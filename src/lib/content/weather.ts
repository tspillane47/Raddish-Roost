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
  sunrise?: string | null;
  sunset?: string | null;
  /** Forced sky, used by the development preview. */
  scene?: WeatherScene;
};

export const WEATHER_SCENES = [
  "clear-day",
  "clear-night",
  "cloudy",
  "rain",
  "snow",
  "fog",
  "storm",
  "golden",
] as const;

export type WeatherScene = (typeof WEATHER_SCENES)[number];

export type WeatherView = {
  scene: WeatherScene;
  tone: "light" | "dark";
  night: boolean;
  partly: boolean;
  clouds: number;
  raindrops: number;
  snowflakes: number;
  stars: number;
  sun: boolean;
  moon: boolean;
  lightning: boolean;
  fog: boolean;
};

const NY = "America/New_York";
const GOLDEN_MINUTES = 60;

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

export function isWeatherScene(value: string): value is WeatherScene {
  return (WEATHER_SCENES as readonly string[]).includes(value);
}

/** Development only. Production ignores the query. */
export function weatherPreviewScene(
  value: string | string[] | undefined,
  env = process.env.NODE_ENV,
): WeatherScene | null {
  if (env !== "development") return null;
  const raw = Array.isArray(value) ? value[0] : value;
  if (!raw || !isWeatherScene(raw)) return null;
  return raw;
}

export function previewWeather(scene: WeatherScene): WeatherSnapshot {
  const presets = {
    "clear-day": { code: 0, temp: 72, high: 76, low: 54 },
    "clear-night": { code: 0, temp: 41, high: 58, low: 37 },
    cloudy: { code: 3, temp: 54, high: 57, low: 44 },
    rain: { code: 65, temp: 48, high: 52, low: 43 },
    snow: { code: 73, temp: 28, high: 31, low: 22 },
    fog: { code: 45, temp: 44, high: 48, low: 40 },
    storm: { code: 95, temp: 62, high: 68, low: 55 },
    golden: { code: 1, temp: 66, high: 70, low: 48 },
  } as const;
  const preset = presets[scene];
  return {
    ...preset,
    scene,
    sunrise: null,
    sunset: null,
    line: weatherLine(preset.code, 9),
    days: [
      { label: "Today", code: preset.code, high: preset.high, low: preset.low },
      { label: "Sat", code: 2, high: preset.high - 2, low: preset.low },
      { label: "Sun", code: 0, high: preset.high + 1, low: preset.low + 2 },
    ],
  };
}

export function withWeatherPreview(
  weather: WeatherSnapshot | null,
  scene: WeatherScene | null,
): WeatherSnapshot | null {
  if (!scene) return weather;
  return previewWeather(scene);
}

type Clock = { day: string; minutes: number };

function minutesInZone(date: Date): Clock {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone: NY,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  }).formatToParts(date);
  const read = (type: string) => parts.find((part) => part.type === type)?.value ?? "0";
  return {
    day: `${read("year")}-${read("month")}-${read("day")}`,
    minutes: (Number(read("hour")) % 24) * 60 + Number(read("minute")),
  };
}

function parseLocalStamp(stamp: string | null | undefined): Clock | null {
  const match = /^(\d{4}-\d{2}-\d{2})T(\d{2}):(\d{2})/.exec(stamp ?? "");
  if (!match) return null;
  return { day: match[1], minutes: Number(match[2]) * 60 + Number(match[3]) };
}

/** Day, night, or the hour around sunrise and sunset. Times are America/New_York local stamps. */
export function skyPeriod(
  sunrise: string | null | undefined,
  sunset: string | null | undefined,
  now = new Date(),
): "night" | "golden" | "day" {
  const current = minutesInZone(now);
  const rise = parseLocalStamp(sunrise);
  const set = parseLocalStamp(sunset);
  if (!rise || !set || rise.day !== current.day || set.day !== current.day) {
    if (current.minutes < 6 * 60 || current.minutes >= 19 * 60) return "night";
    const nearMorning = Math.abs(current.minutes - 7 * 60) <= GOLDEN_MINUTES;
    const nearEvening = Math.abs(current.minutes - 17 * 60) <= GOLDEN_MINUTES;
    return nearMorning || nearEvening ? "golden" : "day";
  }
  if (Math.abs(current.minutes - rise.minutes) <= GOLDEN_MINUTES) return "golden";
  if (Math.abs(current.minutes - set.minutes) <= GOLDEN_MINUTES) return "golden";
  if (current.minutes < rise.minutes || current.minutes >= set.minutes) return "night";
  return "day";
}

export function weatherScene(
  code: number,
  sunrise: string | null | undefined,
  sunset: string | null | undefined,
  now = new Date(),
): WeatherScene {
  if (code >= 95) return "storm";
  if (isSnow(code)) return "snow";
  if (isRain(code)) return "rain";
  if (code === 45 || code === 48) return "fog";
  const period = skyPeriod(sunrise, sunset, now);
  if (period === "golden") return "golden";
  if (period === "night" && code <= 1) return "clear-night";
  if (code >= 2) return "cloudy";
  return "clear-day";
}

function raindropsFor(code: number): number {
  if (code === 65 || code === 67 || code === 82 || code >= 95) return 36;
  if (code >= 61 || code === 63 || code === 81) return 28;
  return 18;
}

export function weatherView(
  weather: Pick<WeatherSnapshot, "code" | "scene" | "sunrise" | "sunset">,
  now = new Date(),
): WeatherView {
  const scene =
    weather.scene ?? weatherScene(weather.code, weather.sunrise, weather.sunset, now);
  const period = skyPeriod(weather.sunrise, weather.sunset, now);
  const partly = !weather.scene && weather.code === 2 && (scene === "cloudy" || scene === "golden");
  const night = scene === "clear-night" || (scene === "cloudy" && !weather.scene && period === "night");
  const dark = scene === "clear-night" || scene === "rain" || scene === "storm" || night;
  const clouds =
    scene === "storm" || scene === "rain" ? 3 : partly ? 2 : scene === "cloudy" ? 4 : 0;
  return {
    scene,
    tone: dark ? "dark" : "light",
    night,
    partly,
    clouds,
    raindrops: scene === "storm" ? 34 : scene === "rain" ? raindropsFor(weather.code) : 0,
    snowflakes: scene === "snow" ? 32 : 0,
    stars: scene === "clear-night" ? 14 : 0,
    sun: scene === "clear-day" || scene === "golden" || partly,
    moon: scene === "clear-night",
    lightning: scene === "storm",
    fog: scene === "fog",
  };
}

export type HeroWeatherKind = "snow" | "rain" | "storm" | "fog" | "sun";

/**
 * Snow, rain, storm, and fog always show.
 * Clear day and golden hour get sunshine.
 * Cloudy and night stay clean.
 */
export function heroWeatherKind(view: Pick<WeatherView, "scene">): HeroWeatherKind | null {
  if (view.scene === "snow" || view.scene === "rain" || view.scene === "storm" || view.scene === "fog") {
    return view.scene;
  }
  if (view.scene === "clear-day" || view.scene === "golden") return "sun";
  return null;
}

/** Fewer pieces than the weather card, so the photos stay readable. */
export function heroWeatherCount(kind: HeroWeatherKind): number {
  if (kind === "snow") return 18;
  if (kind === "storm") return 20;
  if (kind === "rain") return 16;
  if (kind === "sun") return 4;
  return 0;
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
    sunrise?: unknown;
    sunset?: unknown;
  };
};

function numberAt(value: unknown, index?: number): number | null {
  const raw = index === undefined ? value : Array.isArray(value) ? value[index] : undefined;
  const parsed = typeof raw === "number" ? raw : typeof raw === "string" ? Number(raw) : NaN;
  return Number.isFinite(parsed) ? Math.round(parsed) : null;
}

function stringAt(value: unknown, index: number): string | null {
  const raw = Array.isArray(value) ? value[index] : undefined;
  return typeof raw === "string" && raw.trim() ? raw : null;
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
    sunrise: stringAt(body.daily?.sunrise, 0),
    sunset: stringAt(body.daily?.sunset, 0),
  };
}

function weekdayLabel(isoDate: string): string {
  const date = new Date(`${isoDate}T12:00:00`);
  if (Number.isNaN(date.getTime())) return isoDate;
  return date.toLocaleDateString("en-US", { weekday: "short", timeZone: "America/New_York" });
}
