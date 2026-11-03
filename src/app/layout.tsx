import type { CSSProperties } from "react";
import type { Metadata, Viewport } from "next";
import { DM_Serif_Display, Inter } from "next/font/google";
import { SiteChrome } from "@/components/layout/site-chrome";
import { LocaleProvider } from "@/lib/i18n/locale-context";
import { getLocale } from "@/lib/i18n/get-locale";
import { getSiteConfig, sitePaletteStyle } from "@/sites";
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
  return (
    <html
      lang={locale}
      className={`${inter.variable} ${display.variable} antialiased`}
      style={sitePaletteStyle(site.colors) as CSSProperties}
    >
      <body className="flex min-h-dvh flex-col">
        <LocaleProvider locale={locale}>
          <SiteChrome>{children}</SiteChrome>
        </LocaleProvider>
      </body>
    </html>
  );
}
