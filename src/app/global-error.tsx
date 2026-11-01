"use client";

import { useMemo } from "react";
import { LOCALE_COOKIE, parseLocale, type Locale } from "@/lib/i18n/locale";
import { t } from "@/lib/i18n/translate";

export default function GlobalError({
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  const locale = useMemo(() => readCookieLocale(), []);
  return (
    <html lang={locale}>
      <body
        style={{
          margin: 0,
          minHeight: "100dvh",
          background: "#F7F4ED",
          color: "#262626",
          fontFamily: "Georgia, serif",
        }}
      >
        <main style={{ maxWidth: "36rem", margin: "0 auto", padding: "6rem 1.25rem" }}>
          <h1 style={{ fontSize: "2.5rem", fontWeight: 400, color: "#263F35" }}>{t(locale, "somethingWrong")}</h1>
          <p style={{ fontFamily: "Inter, sans-serif", fontSize: "1.125rem", lineHeight: 1.6 }}>
            {t(locale, "couldntLoad")}
          </p>
          <button
            type="button"
            onClick={reset}
            style={{
              marginTop: "2rem",
              minHeight: "3rem",
              background: "#263F35",
              color: "#F7F4ED",
              border: 0,
              borderRadius: "0.5rem",
              padding: "0 1.25rem",
              fontFamily: "Inter, sans-serif",
              fontSize: "1rem",
            }}
          >
            {t(locale, "tryAgain")}
          </button>
        </main>
      </body>
    </html>
  );
}

function readCookieLocale(): Locale {
  if (typeof document === "undefined") return "en";
  const match = document.cookie.split("; ").find((part) => part.startsWith(`${LOCALE_COOKIE}=`));
  return parseLocale(match?.split("=")[1]);
}
