/**
 * Postgres rejects UPDATE ... FROM when the update target alias appears in a
 * JOIN ON clause (error 42P01). Those conditions belong in WHERE instead.
 */
export function unsafeUpdateFromJoinOns(sql: string): string[] {
  const issues: string[] = [];
  const updateRe = /update\s+public\.(\w+)\s+(?:as\s+)?(\w+)\s+set\b/gi;
  let match: RegExpExecArray | null;

  while ((match = updateRe.exec(sql))) {
    const table = match[1];
    const alias = match[2];
    const setStart = match.index + match[0].length;
    const rest = sql.slice(setStart);
    const end = rest.search(/;/);
    const statementBody = end === -1 ? rest : rest.slice(0, end);
    const fromMatch = /\bfrom\b([\s\S]*)/i.exec(statementBody);
    if (!fromMatch) continue;

    const fromClause = fromMatch[1].split(/\bwhere\b/i)[0] ?? "";
    const joinOnRe = /\bjoin\b[\s\S]*?\bon\b\s+([^\n]+)/gi;
    let joinMatch: RegExpExecArray | null;
    while ((joinMatch = joinOnRe.exec(fromClause))) {
      const onExpr = joinMatch[1].trim();
      if (new RegExp(`\\b${alias}\\.`, "i").test(onExpr)) {
        issues.push(
          `update public.${table} ${alias}: JOIN ON must not reference the update target (${onExpr})`,
        );
      }
    }
  }

  return issues;
}
