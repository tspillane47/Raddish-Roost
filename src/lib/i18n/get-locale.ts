import "server-only";

import { headers } from "next/headers";
import { LOCALE_HEADER, parseLocale, type Locale } from "@/lib/i18n/locale";

export async function getLocale(): Promise<Locale> {
  try {
    return parseLocale((await headers()).get(LOCALE_HEADER));
  } catch {
    return "en";
  }
}
