import { readdirSync, readFileSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { unsafeUpdateFromJoinOns } from "@/lib/content/sql-update-from";

const root = path.resolve(__dirname, "../../..");
const migrationsDir = path.join(root, "supabase/migrations");

describe("sql update from join safety", () => {
  it("flags JOIN ON clauses that reference the UPDATE target alias", () => {
    const bad = `
update public.property_recommendations pr
set guest_tags = '{}'
from public.properties stay
join public.recommendations place on place.id = pr.recommendation_id
where pr.property_id = stay.id;
`;
    expect(unsafeUpdateFromJoinOns(bad)).toEqual([
      "update public.property_recommendations pr: JOIN ON must not reference the update target (place.id = pr.recommendation_id)",
    ]);

    const good = `
update public.property_recommendations pr
set guest_tags = '{}'
from public.properties stay,
  public.recommendations place
where pr.property_id = stay.id
  and pr.recommendation_id = place.id;
`;
    expect(unsafeUpdateFromJoinOns(good)).toEqual([]);
  });

  it("scans every migration file for the UPDATE ... FROM JOIN ON bug", () => {
    const files = readdirSync(migrationsDir)
      .filter((name) => name.endsWith(".sql"))
      .sort();
    expect(files.length).toBeGreaterThan(0);

    const failures: string[] = [];
    for (const name of files) {
      const sql = readFileSync(path.join(migrationsDir, name), "utf8");
      for (const issue of unsafeUpdateFromJoinOns(sql)) {
        failures.push(`${name}: ${issue}`);
      }
    }

    expect(failures).toEqual([]);
  });
});
