import { describe, expect, it } from "vitest";
import { copyText } from "@/lib/i18n/copy";
import { localeFromAcceptLanguage, parseLocale, requestLocale } from "@/lib/i18n/locale";
import { messages } from "@/lib/i18n/messages";
import { t, tf } from "@/lib/i18n/translate";

describe("locale", () => {
  it("uses Spanish or French from the browser, and English otherwise", () => {
    expect(localeFromAcceptLanguage("fr-CA,fr;q=0.9,en;q=0.8")).toBe("fr");
    expect(localeFromAcceptLanguage("es-MX,en;q=0.5")).toBe("es");
    expect(localeFromAcceptLanguage("de,it;q=0.8,en;q=0.2")).toBe("en");
    expect(localeFromAcceptLanguage(null)).toBe("en");
  });

  it("keeps a saved choice ahead of the browser language", () => {
    expect(requestLocale("es", "fr-FR,fr;q=0.9")).toBe("es");
    expect(requestLocale(null, "fr")).toBe("fr");
    expect(parseLocale("de")).toBe("en");
  });

  it("falls back to English when a translation is missing", () => {
    const map = new Map([["recommendations:1:description", "Una mesa junto a las ventanas."]]);
    expect(copyText(map, "recommendations", "1", "description", "Ask for a window.")).toBe(
      "Una mesa junto a las ventanas.",
    );
    expect(copyText(map, "recommendations", "2", "host_note", "Host tip stays.")).toBe("Host tip stays.");
    expect(copyText(null, "recommendations", "2", "host_note", "Host tip stays.")).toBe("Host tip stays.");
    expect(t("es", "clearFilters")).toBe("Quitar");
    expect(tf("en", "weatherHigh", { temp: 55 })).toBe("High 55°");
    expect(tf("es", "checkInAt", { time: "4:00 PM" })).toBe("La llegada es a las 4:00 PM");
    expect(tf("fr", "checkoutAt", { time: "10:00 AM" })).toBe("Le départ est à 10:00 AM");
  });

  it("keeps the host voice free of dashes and the one-D spelling", () => {
    for (const locale of ["en", "es", "fr"] as const) {
      for (const value of Object.values(messages[locale])) {
        expect(value).not.toContain("—");
        expect(value).not.toContain("–");
        expect(value).not.toContain("Radish");
      }
    }
    expect(messages.en.welcomeBand).toBe("Welcome to");
    expect(messages.es.welcomeBand).toBe("Bienvenida a");
    expect(messages.fr.welcomeBand).toBe("Bienvenue au");
    expect(messages.en.vtCreemeesBody).toContain("soft serve");
    expect(messages.es.vtCreemeesBody).toContain("helado suave");
    expect(messages.fr.vtCreemeesBody).toContain("glace molle");
  });
});
