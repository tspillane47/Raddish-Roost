import type { Metadata } from "next";
import { DM_Serif_Display, Inter } from "next/font/google";
import { SiteChrome } from "@/components/layout/site-chrome";
import { DEFAULT_BRAND_NAME } from "@/lib/brand";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

const display = DM_Serif_Display({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-display",
});

export const metadata: Metadata = {
  title: {
    default: DEFAULT_BRAND_NAME,
    template: `%s · ${DEFAULT_BRAND_NAME}`,
  },
  description: "Everything you need for a wonderful stay, all in one place.",
  robots: {
    index: false,
    follow: false,
  },
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={`${inter.variable} ${display.variable} h-full antialiased`}>
      <body className="flex min-h-full flex-col">
        <SiteChrome>{children}</SiteChrome>
      </body>
    </html>
  );
}
