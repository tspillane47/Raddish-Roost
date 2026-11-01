export type CopyMap = Map<string, string>;

export function copyKey(table: string, id: string, field: string): string {
  return `${table}:${id}:${field}`;
}

export function copyText(
  map: CopyMap | null | undefined,
  table: string,
  id: string | null | undefined,
  field: string,
  english: string | null | undefined,
): string | null {
  if (english == null) return null;
  if (!map || !id) return english;
  const next = map.get(copyKey(table, id, field));
  return next && next.trim() ? next : english;
}

export function copyMapFromRows(
  rows: { source_table?: string | null; source_id?: string | null; field?: string | null; text?: string | null }[],
): CopyMap {
  const map: CopyMap = new Map();
  for (const row of rows) {
    if (!row.source_table || !row.source_id || !row.field || !row.text?.trim()) continue;
    map.set(copyKey(row.source_table, row.source_id, row.field), row.text);
  }
  return map;
}

export function localizeBlockBody(body: unknown, translated: { markdown?: string | null; steps?: string | null }): unknown {
  if (!body || typeof body !== "object") return body;
  const next = { ...(body as Record<string, unknown>) };
  if (translated.markdown && typeof next.markdown === "string") next.markdown = translated.markdown;
  if (translated.steps) {
    try {
      const steps = JSON.parse(translated.steps) as unknown;
      if (Array.isArray(steps)) next.steps = steps;
    } catch {
      return body;
    }
  }
  return next;
}
