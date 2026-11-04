"use server";

import { cookies } from "next/headers";
import { refresh } from "next/cache";
import { isLocale, LOCALE_COOKIE, type Locale } from "@/lib/i18n/locale";

const YEAR = 60 * 60 * 24 * 365;

/** Persist the guest language choice and refresh the current route. */
export async function setLocale(locale: Locale): Promise<void> {
  if (!isLocale(locale)) return;

  const jar = await cookies();
  jar.set(LOCALE_COOKIE, locale, {
    path: "/",
    maxAge: YEAR,
    sameSite: "lax",
  });
  refresh();
}
