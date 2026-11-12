import type { CSSProperties } from "react";
import type { Metadata, Viewport } from "next";
import {
  Alfa_Slab_One,
  DM_Serif_Display,
  Instrument_Serif,
  Inter,
  Inter_Tight,
  Special_Elite,
} from "next/font/google";
import { SiteChrome } from "@/components/layout/site-chrome";
import { LocaleProvider } from "@/lib/i18n/locale-context";
import { getLocale } from "@/lib/i18n/get-locale";
import { getSiteConfig, sitePaletteStyle } from "@/sites";
import { SiteProvider } from "@/sites/site-context";
import "./globals.css";

export const instant = false;

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const display = DM_Serif_Display({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-display",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const dadDisplay = Alfa_Slab_One({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-dad-display",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const dadTypewriter = Special_Elite({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-dad-typewriter",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const errinDisplay = Instrument_Serif({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-errin-display",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const errinSans = Inter_Tight({
  subsets: ["latin"],
  variable: "--font-errin-sans",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

export async function generateMetadata(): Promise<Metadata> {
  const site = getSiteConfig();
  return {
    title: {
      default: site.name,
      template: `%s · ${site.name}`,
    },
    description: site.seoDescription,
    applicationName: site.shortName,
    robots: {
      index: false,
      follow: false,
    },
    appleWebApp: {
      capable: true,
      title: site.shortName,
      statusBarStyle: "default",
    },
    icons: {
      icon: [
        { url: site.icons.favicon },
        { url: site.icons.icon192, sizes: "192x192", type: "image/png" },
        { url: site.icons.icon512, sizes: "512x512", type: "image/png" },
      ],
      apple: [{ url: site.icons.appleTouch }],
    },
  };
}

export function generateViewport(): Viewport {
  const site = getSiteConfig();
  return {
    width: "device-width",
    initialScale: 1,
    viewportFit: "cover",
    themeColor: site.colors.forest,
  };
}

export default async function RootLayout({ children }: LayoutProps<"/">) {
  const locale = await getLocale();
  const site = getSiteConfig();
  const fontVars =
    site.key === "dad"
      ? `${inter.variable} ${display.variable} ${dadDisplay.variable} ${dadTypewriter.variable}`
      : site.key === "errin"
        ? `${inter.variable} ${display.variable} ${errinDisplay.variable} ${errinSans.variable}`
        : `${inter.variable} ${display.variable}`;
  const palette = sitePaletteStyle(site.colors) as CSSProperties;
  const style =
    site.key === "dad"
      ? ({
          ...palette,
          "--font-heading": "var(--font-dad-display), ui-serif, Georgia, serif",
        } as CSSProperties)
      : site.key === "errin"
        ? ({
            ...palette,
            "--font-heading": "var(--font-errin-display), ui-serif, Georgia, serif",
            "--font-sans": "var(--font-errin-sans), var(--font-inter), ui-sans-serif, system-ui, sans-serif",
          } as CSSProperties)
        : palette;

  return (
    <html lang={locale} className={`${fontVars} antialiased`} style={style}>
      <body
        className={`flex min-h-dvh flex-col ${site.key === "errin" ? "font-[family-name:var(--font-errin-sans,var(--font-inter))]" : ""}`}
      >
        <SiteProvider siteKey={site.key}>
          <LocaleProvider locale={locale}>
            <SiteChrome>{children}</SiteChrome>
          </LocaleProvider>
        </SiteProvider>
      </body>
    </html>
  );
}
