import "server-only";

import { cookies, headers } from "next/headers";
import { LOCALE_COOKIE, LOCALE_HEADER, requestLocale, type Locale } from "@/lib/i18n/locale";

export async function getLocale(): Promise<Locale> {
  try {
    const headerList = await headers();
    const jar = await cookies();
    // Cookie is the source of truth. The proxy also mirrors it on x-rr-lang.
    return requestLocale(
      jar.get(LOCALE_COOKIE)?.value ?? headerList.get(LOCALE_HEADER),
      headerList.get("accept-language"),
    );
  } catch {
    return "en";
  }
}
