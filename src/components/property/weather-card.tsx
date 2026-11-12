"use client";

import { useEffect, useState, type CSSProperties } from "react";
import { weatherCondition, weatherView, type WeatherDay, type WeatherSnapshot } from "@/lib/content/weather";
import { intlLocale } from "@/lib/i18n/locale";
import { useTranslate } from "@/lib/i18n/locale-context";
import { messages, type MessageKey } from "@/lib/i18n/messages";
import { useSiteConfig } from "@/sites/site-context";
import "./weather-card.css";

export function WeatherCard({ weather }: { weather: WeatherSnapshot }) {
  const site = useSiteConfig();
  const view = weatherView(weather);
  const { locale, t, tf } = useTranslate();
  const [node, setNode] = useState<HTMLElement | null>(null);
  const [paused, setPaused] = useState(false);
  const condition = weatherCondition(weather.code);

  useEffect(() => {
    if (!node || typeof IntersectionObserver === "undefined") return;
    let onScreen = true;
    const sync = () => {
      const next = !onScreen || document.visibilityState === "hidden";
      setPaused((current) => (current === next ? current : next));
    };
    const observer = new IntersectionObserver(([entry]) => {
      onScreen = entry.isIntersecting;
      sync();
    });
    observer.observe(node);
    document.addEventListener("visibilitychange", sync);
    sync();
    return () => {
      observer.disconnect();
      document.removeEventListener("visibilitychange", sync);
    };
  }, [node]);

  if (site.key === "errin") {
    return (
      <section
        aria-label={t("weather")}
        className="w-full border border-[var(--beige)] bg-[var(--cream)] px-5 py-5"
      >
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0">
            <p className="text-[0.7rem] font-medium uppercase tracking-[0.22em] text-[var(--muted)]">
              {t("weather")}
            </p>
            <p className="mt-3 font-[family-name:var(--font-errin-display,var(--font-display))] text-[3rem] leading-none tracking-tight text-[var(--charcoal)]">
              {weather.temp}°<span className="sr-only"> {t("fahrenheit")}</span>
            </p>
            <p className="mt-2 text-sm leading-5 text-[var(--muted)]">{conditionLabel(condition, t)}</p>
          </div>
          <p className="pt-7 text-right text-sm leading-6 text-[var(--muted)]">
            <span className="block">{tf("weatherHigh", { temp: weather.high })}</span>
            <span className="block">{tf("weatherLow", { temp: weather.low })}</span>
          </p>
        </div>
        <div className="mt-5 h-px w-full bg-[var(--beige)]" aria-hidden="true" />
        <ol className="mt-4 grid list-none grid-cols-3 gap-3 p-0">
          {weather.days.map((day) => (
            <li key={day.label} className="min-w-0">
              <p className="text-[0.65rem] font-medium uppercase tracking-[0.18em] text-[var(--muted)]">
                {dayName(day, locale, t)}
              </p>
              <p className="mt-1 text-sm tabular-nums text-[var(--charcoal)]">
                {day.high}° / {day.low}°
              </p>
            </li>
          ))}
        </ol>
      </section>
    );
  }

  return (
    <section
      ref={setNode}
      aria-label={t("weather")}
      data-scene={view.scene}
      data-tone={view.tone}
      data-night={view.night ? "true" : "false"}
      data-paused={paused ? "true" : "false"}
      data-cold={weather.temp < 32 ? "true" : "false"}
      data-hot={weather.temp > 85 ? "true" : "false"}
      className="weather-card relative h-[210px] w-full overflow-hidden rounded-3xl sm:h-[220px]"
    >
      <div className="weather-sky" aria-hidden="true">
        <Sky view={view} />
      </div>
      {weather.temp > 85 ? <div className="weather-shimmer" aria-hidden="true" /> : null}
      <div className="weather-copy relative z-10 flex h-full flex-col justify-between px-4 py-3.5 sm:px-5">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="font-sans text-[3.25rem] leading-none font-light tracking-tight">
              {weather.temp}°<span className="sr-only"> {t("fahrenheit")}</span>
            </p>
            <p className="mt-1 text-sm leading-5 font-medium">{conditionLabel(condition, t)}</p>
          </div>
          <p className="pt-1 text-right text-sm leading-5">
            <span className="block">{tf("weatherHigh", { temp: weather.high })}</span>
            <span className="block">{tf("weatherLow", { temp: weather.low })}</span>
          </p>
        </div>
        <ol className="grid list-none grid-cols-3 gap-2 p-0">
          {weather.days.map((day) => (
            <li key={day.label} className="weather-pill flex min-w-0 items-center justify-center gap-1.5 rounded-full px-2 py-1.5">
              <span className="truncate text-[11px]">{dayName(day, locale, t)}</span>
              <DayIcon code={day.code} />
              <span className="text-[11px] whitespace-nowrap tabular-nums">
                {day.high}° {day.low}°
              </span>
            </li>
          ))}
        </ol>
        {localizedLine(weather.line, t) ? (
          <p className="line-clamp-2 text-xs leading-4">{localizedLine(weather.line, t)}</p>
        ) : (
          <span className="h-4" />
        )}
      </div>
    </section>
  );
}

const CONDITION_KEYS: Record<string, MessageKey> = {
  Clear: "weatherClear",
  "Mainly clear": "weatherMainly",
  "Partly cloudy": "weatherPartly",
  Cloudy: "weatherCloudy",
  Fog: "weatherFog",
  Drizzle: "weatherDrizzle",
  Rain: "weatherRain",
  Snow: "weatherSnow",
  Thunderstorm: "weatherStorm",
};

function conditionLabel(condition: string, translate: (key: MessageKey) => string) {
  const key = CONDITION_KEYS[condition];
  return key ? translate(key) : condition;
}

function localizedLine(line: string | null, translate: (key: MessageKey) => string) {
  if (line === messages.en.weatherSnowLine) return translate("weatherSnowLine");
  if (line === messages.en.weatherRainLine) return translate("weatherRainLine");
  if (line === messages.en.weatherFallLine) return translate("weatherFallLine");
  return line;
}

function dayName(day: WeatherDay, locale: ReturnType<typeof useTranslate>["locale"], translate: (key: MessageKey) => string) {
  if (day.label === "Today") return translate("today");
  if (!day.date) return day.label;
  return new Intl.DateTimeFormat(intlLocale(locale), { weekday: "short", timeZone: "America/New_York" }).format(
    new Date(`${day.date}T12:00:00`),
  );
}

function Sky({ view }: { view: ReturnType<typeof weatherView> }) {
  return (
    <>
      {view.sun ? <Sun /> : null}
      {view.moon ? <Moon /> : null}
      {marks(view.stars, 3).map((mark) => (
        <span key={mark.key} className="weather-star" style={mark.style} />
      ))}
      {Array.from({ length: view.clouds }, (_, index) => (
        <span key={index} className={`weather-cloud weather-cloud-${index + 1}`} />
      ))}
      {marks(view.raindrops, 7).map((mark) => (
        <span key={mark.key} className="weather-drop" style={mark.style} />
      ))}
      {marks(view.snowflakes, 11).map((mark) => (
        <span key={mark.key} className="weather-flake" style={mark.style} />
      ))}
      {view.fog
        ? [1, 2, 3].map((band) => <span key={band} className={`weather-fogband weather-fogband-${band}`} />)
        : null}
      {view.lightning ? <span className="weather-lightning" /> : null}
    </>
  );
}

function Sun() {
  return (
    <div className="weather-sun">
      <div className="weather-sun-glow" />
      <svg className="weather-rays" viewBox="0 0 80 80" aria-hidden="true">
        {Array.from({ length: 10 }, (_, index) => (
          <line
            key={index}
            x1="40"
            y1="8"
            x2="40"
            y2="16"
            stroke="rgba(255, 214, 140, 0.8)"
            strokeWidth="1.5"
            strokeLinecap="round"
            transform={`rotate(${index * 36} 40 40)`}
          />
        ))}
      </svg>
    </div>
  );
}

function Moon() {
  return (
    <div className="weather-moon">
      <div className="weather-moon-glow" />
    </div>
  );
}

function DayIcon({ code }: { code: number }) {
  const stroke = "currentColor";
  if (code === 0 || code === 1) {
    return (
      <svg viewBox="0 0 16 16" className="size-3.5 shrink-0" aria-hidden="true">
        <circle cx="8" cy="8" r="2.4" fill="none" stroke={stroke} strokeWidth="1.2" />
      </svg>
    );
  }
  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82) || code >= 95) {
    return (
      <svg viewBox="0 0 16 16" className="size-3.5 shrink-0" aria-hidden="true">
        <path d="M5 3.5v7M8 2.5v9M11 4.5v6" fill="none" stroke={stroke} strokeWidth="1.2" strokeLinecap="round" />
      </svg>
    );
  }
  if ((code >= 71 && code <= 77) || code === 85 || code === 86) {
    return (
      <svg viewBox="0 0 16 16" className="size-3.5 shrink-0" aria-hidden="true">
        <circle cx="5" cy="6" r="1" fill={stroke} />
        <circle cx="9" cy="4.5" r="1" fill={stroke} />
        <circle cx="11" cy="8" r="1" fill={stroke} />
      </svg>
    );
  }
  return (
    <svg viewBox="0 0 16 16" className="size-3.5 shrink-0" aria-hidden="true">
      <path d="M4 10.5h7.2a2.2 2.2 0 0 0 .2-4.4 3.2 3.2 0 0 0-6.1-1 2.4 2.4 0 0 0-1.3 5.4z" fill="none" stroke={stroke} strokeWidth="1.2" />
    </svg>
  );
}

function marks(count: number, seed: number) {
  return Array.from({ length: count }, (_, index) => {
    const step = index + seed;
    return {
      key: `${seed}-${index}`,
      style: {
        "--left": `${(step * 19) % 100}%`,
        "--top": `${(step * 23) % 86}%`,
        "--delay": `${-((step % 11) * 0.45)}s`,
        "--dur": `${7 + (step % 6)}s`,
        "--sway": `${step % 2 === 0 ? 8 : -11}px`,
        "--len": `${9 + (step % 8)}px`,
        "--size": `${1.5 + (step % 3)}px`,
      } as CSSProperties,
    };
  });
}
