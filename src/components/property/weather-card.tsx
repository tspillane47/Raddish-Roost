"use client";

import { useEffect, useState, type CSSProperties } from "react";
import { weatherCondition, weatherView, type WeatherSnapshot } from "@/lib/content/weather";
import "./weather-card.css";

export function WeatherCard({ weather }: { weather: WeatherSnapshot }) {
  const view = weatherView(weather);
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

  return (
    <section
      ref={setNode}
      aria-label="Weather"
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
              {weather.temp}°<span className="sr-only"> Fahrenheit</span>
            </p>
            <p className="mt-1 text-sm leading-5 font-medium">{condition}</p>
          </div>
          <p className="pt-1 text-right text-sm leading-5">
            <span className="block">High {weather.high}°</span>
            <span className="block">Low {weather.low}°</span>
          </p>
        </div>
        <ol className="grid list-none grid-cols-3 gap-2 p-0">
          {weather.days.map((day) => (
            <li key={day.label} className="weather-pill flex min-w-0 items-center justify-center gap-1.5 rounded-full px-2 py-1.5">
              <span className="truncate text-[11px]">{day.label}</span>
              <DayIcon code={day.code} />
              <span className="text-[11px] whitespace-nowrap tabular-nums">
                {day.high}° {day.low}°
              </span>
            </li>
          ))}
        </ol>
        {weather.line ? <p className="line-clamp-2 text-xs leading-4">{weather.line}</p> : <span className="h-4" />}
      </div>
    </section>
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
