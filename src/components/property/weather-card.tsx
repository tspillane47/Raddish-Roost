import { Cloud, CloudFog, CloudLightning, CloudRain, CloudSnow, CloudSun, Sun } from "lucide-react";
import { weatherCondition, type WeatherSnapshot } from "@/lib/content/weather";

export function WeatherCard({ weather }: { weather: WeatherSnapshot }) {
  const condition = weatherCondition(weather.code);
  return (
    <section aria-label="Weather" className="rounded-2xl bg-beige/60 p-4">
      <div className="flex items-center gap-3">
        <WeatherIcon code={weather.code} className="size-10 shrink-0 text-forest" />
        <div className="min-w-0">
          <p className="font-heading text-4xl leading-none text-charcoal">
            {weather.temp}°<span className="sr-only"> Fahrenheit</span>
          </p>
          <p className="mt-1 text-base leading-7">{condition}</p>
        </div>
        <p className="ml-auto text-right text-base leading-7">
          <span className="block text-sm text-muted-foreground">Today</span>
          High {weather.high}°
          <span className="block">Low {weather.low}°</span>
        </p>
      </div>
      <ol className="mt-4 grid list-none grid-cols-3 gap-2 p-0">
        {weather.days.map((day) => (
          <li key={day.label} className="rounded-xl bg-cream px-2 py-2 text-center">
            <p className="text-sm text-forest">{day.label}</p>
            <WeatherIcon code={day.code} className="mx-auto mt-1 size-5 text-forest" />
            <p className="mt-1 text-sm leading-6">
              {day.high}° <span className="text-muted-foreground">{day.low}°</span>
            </p>
          </li>
        ))}
      </ol>
      {weather.line ? <p className="mt-3 text-base leading-7">{weather.line}</p> : null}
    </section>
  );
}

function WeatherIcon({ code, className }: { code: number; className: string }) {
  const props = { className, "aria-hidden": true as const, strokeWidth: 1.75 };
  if (code === 0 || code === 1) return <Sun {...props} />;
  if (code === 2) return <CloudSun {...props} />;
  if (code === 45 || code === 48) return <CloudFog {...props} />;
  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return <CloudRain {...props} />;
  if ((code >= 71 && code <= 77) || code === 85 || code === 86) return <CloudSnow {...props} />;
  if (code >= 95) return <CloudLightning {...props} />;
  return <Cloud {...props} />;
}
