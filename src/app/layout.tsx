import type { Metadata, Viewport } from "next";
import { DM_Serif_Display, Inter } from "next/font/google";
import { SiteChrome } from "@/components/layout/site-chrome";
import { BRAND_COLORS, DEFAULT_BRAND_NAME } from "@/lib/brand";
import "./globals.css";

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

export const metadata: Metadata = {
  title: {
    default: DEFAULT_BRAND_NAME,
    template: `%s · ${DEFAULT_BRAND_NAME}`,
  },
  description: "Everything you need for a wonderful stay, all in one place.",
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

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
  themeColor: BRAND_COLORS.forest,
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={`${inter.variable} ${display.variable} antialiased`}>
      <body className="flex min-h-dvh flex-col">
        <SiteChrome>{children}</SiteChrome>
      </body>
    </html>
  );
}
