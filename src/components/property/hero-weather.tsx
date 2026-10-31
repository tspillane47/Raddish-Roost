"use client";

import { useEffect, useState, type CSSProperties } from "react";
import { heroWeatherCount, heroWeatherKind, weatherView, type HeroWeatherKind, type WeatherSnapshot } from "@/lib/content/weather";
import "./hero-weather.css";

export function HeroWeather({ weather }: { weather: WeatherSnapshot | null }) {
  const view = weather ? weatherView(weather) : null;
  const kind = view ? heroWeatherKind(view) : null;
  const [node, setNode] = useState<HTMLElement | null>(null);
  const [paused, setPaused] = useState(false);

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

  if (!kind || !view) return null;

  return (
    <div
      ref={setNode}
      className="hero-weather pointer-events-none"
      data-hero-weather={kind}
      data-warm={kind === "sun" && view.scene === "golden" ? "true" : undefined}
      data-paused={paused ? "true" : "false"}
      aria-hidden="true"
    >
      {kind === "fog" ? (
        <>
          <span className="hero-haze" />
          <span className="hero-haze hero-haze-2" />
        </>
      ) : (
        pieces(kind).map((piece) => (
          <span key={piece.key} className={piece.className} style={piece.style} />
        ))
      )}
    </div>
  );
}

function pieces(kind: HeroWeatherKind) {
  return Array.from({ length: heroWeatherCount(kind) }, (_, index) => ({
    key: index,
    className: classNameFor(kind),
    style: styleFor(kind, index),
  }));
}

function classNameFor(kind: HeroWeatherKind): string {
  if (kind === "snow") return "hero-speck hero-speck-snow";
  if (kind === "sun") return "hero-ray";
  return "hero-speck hero-speck-rain";
}

function styleFor(kind: HeroWeatherKind, index: number): CSSProperties {
  const falling = kind === "rain" || kind === "storm";
  const duration = falling ? 0.7 + (index % 5) * 0.16 : kind === "sun" ? 6 + index * 1.4 : 10 + (index % 6) * 1.6;
  return {
    "--left": kind === "sun" ? `${12 + index * 20}%` : `${(index * 17 + 4) % 100}%`,
    "--top": kind === "sun" ? "-18%" : `${(index * 23) % 78}%`,
    "--delay": `${-(index % 10) * (falling ? 0.18 : 0.45)}s`,
    "--dur": `${duration}s`,
    "--sway": `${index % 2 === 0 ? 16 : -20}px`,
    "--size": `${5 + (index % 4) * 1.5}px`,
  } as CSSProperties;
}
