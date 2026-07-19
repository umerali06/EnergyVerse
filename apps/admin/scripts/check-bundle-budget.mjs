import { readFileSync, statSync } from "node:fs";

// Phase 2.1c performance budget. Baseline (2026-07-19): 343 KB raw shared
// main bundle (102 KB First Load JS as reported by next build). The budget
// grants ~25% headroom; raising it requires a documented decision, not a
// casual bump.
const BUDGET_BYTES = 430 * 1024;

const manifest = JSON.parse(readFileSync(".next/build-manifest.json", "utf8"));
let total = 0;
for (const file of manifest.rootMainFiles) total += statSync(`.next/${file}`).size;

const kb = (total / 1024).toFixed(1);
if (total > BUDGET_BYTES) {
  console.error(
    `Bundle budget exceeded: shared main bundle is ${kb} KB (budget ${BUDGET_BYTES / 1024} KB).`,
  );
  process.exit(1);
}
console.log(`Bundle budget OK: shared main bundle ${kb} KB (budget ${BUDGET_BYTES / 1024} KB).`);
