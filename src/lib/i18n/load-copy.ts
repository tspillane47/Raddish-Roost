import "server-only";

import { cache } from "react";
import { connection } from "next/server";
import { copyMapFromRows, type CopyMap } from "@/lib/i18n/copy";
import { getLocale } from "@/lib/i18n/get-locale";
import type { Locale } from "@/lib/i18n/locale";
import { getSupabase } from "@/lib/supabase/server";

export const loadCopy = cache(async (locale?: Locale): Promise<CopyMap> => {
  const language = locale ?? (await getLocale());
  if (language === "en") return new Map();
  const supabase = getSupabase();
  if (!supabase) return new Map();
  await connection();
  const { data, error } = await supabase
    .from("content_translations")
    .select("source_table, source_id, field, text")
    .eq("language", language);

  if (error) {
    const abort = error as { message: string; digest?: string };
    if (abort.digest === "HANGING_PROMISE_REJECTION" || abort.message.includes("During prerendering,")) {
      const hanging = new Error(abort.message);
      (hanging as Error & { digest: string }).digest = abort.digest ?? "HANGING_PROMISE_REJECTION";
      throw hanging;
    }
    if (!/content_translations|schema cache/i.test(error.message)) {
      console.error(`[guidebook] translations: ${error.message}`);
    }
    return new Map();
  }
  return copyMapFromRows((data ?? []) as { source_table: string; source_id: string; field: string; text: string }[]);
});
