import type { Metadata, Viewport } from "next";
import { DM_Serif_Display, Inter } from "next/font/google";
import { SiteChrome } from "@/components/layout/site-chrome";
import { LocaleProvider } from "@/lib/i18n/locale-context";
import { getLocale } from "@/lib/i18n/get-locale";
import { t } from "@/lib/i18n/translate";
import { BRAND_COLORS, DEFAULT_BRAND_NAME } from "@/lib/brand";
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
  const locale = await getLocale();
  return {
    title: {
      default: DEFAULT_BRAND_NAME,
      template: `%s · ${DEFAULT_BRAND_NAME}`,
    },
    description: t(locale, "everythingYouNeed"),
    applicationName: "Vermont Roost",
  robots: {
    index: false,
    follow: false,
  },
  appleWebApp: {
    capable: true,
    title: "Vermont Roost",
    statusBarStyle: "default",
  },
  };
}

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
  themeColor: BRAND_COLORS.forest,
};

export default async function RootLayout({ children }: LayoutProps<"/">) {
  const locale = await getLocale();
  return (
    <html lang={locale} className={`${inter.variable} ${display.variable} antialiased`}>
      <body className="flex min-h-dvh flex-col">
        <LocaleProvider locale={locale}>
          <SiteChrome>{children}</SiteChrome>
        </LocaleProvider>
      </body>
    </html>
  );
}
