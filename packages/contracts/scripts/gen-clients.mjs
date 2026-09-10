import { readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import path from "node:path";

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const cli = path.join(
  packageRoot,
  "node_modules",
  "@openapitools",
  "openapi-generator-cli",
  "main.js",
);

for (const output of ["generated/typescript-fetch", "generated/dart-dio"]) {
  // maxRetries/retryDelay work around a documented Windows quirk where a
  // directory can briefly report EBUSY/ENOTEMPTY right after its contents
  // were just deleted, because the filesystem hasn't caught up yet.
  rmSync(path.join(packageRoot, output), {
    force: true,
    recursive: true,
    maxRetries: 10,
    retryDelay: 300,
  });
}

for (const config of ["configs/typescript-fetch.json", "configs/dart-dio.json"]) {
  const result = spawnSync(process.execPath, [cli, "generate", "--config", config], {
    cwd: packageRoot,
    encoding: "utf8",
    stdio: "inherit",
  });
  if (result.error) throw result.error;
  if (result.status !== 0) process.exit(result.status ?? 1);
}

const dartRoot = path.join(packageRoot, "generated", "dart-dio");
const pubspecPath = path.join(dartRoot, "pubspec.yaml");
let pubspec = readFileSync(pubspecPath, "utf8");
for (const [generated, pinned] of Object.entries({
  "dio: '^5.2.0'": "dio: 5.7.0",
  "one_of: '>=1.5.0 <2.0.0'": "one_of: 1.5.0",
  "one_of_serializer: '>=1.5.0 <2.0.0'": "one_of_serializer: 1.5.0",
  "built_value: '>=8.4.0 <9.0.0'": "built_value: 8.9.2",
  "built_collection: '>=5.1.1 <6.0.0'": "built_collection: 5.1.1",
  "built_value_generator: '>=8.4.0 <9.0.0'": "built_value_generator: 8.9.2",
  "build_runner: any": "build_runner: 2.4.13",
  "test: ^1.16.0": "test: 1.25.7",
})) {
  if (!pubspec.includes(generated)) {
    throw new Error(`Pinned Dart dependency source was not generated: ${generated}`);
  }
  pubspec = pubspec.replace(generated, pinned);
}
writeFileSync(pubspecPath, pubspec, "utf8");

const analysisPath = path.join(dartRoot, "analysis_options.yaml");
const analysis = readFileSync(analysisPath, "utf8");
writeFileSync(
  analysisPath,
  analysis.replace(
    "  errors:\n",
    "  errors:\n    # Imports are emitted by the pinned OpenAPI templates for response metadata.\n    unused_import: ignore\n",
  ),
  "utf8",
);

const dartGitignore = path.join(dartRoot, ".gitignore");
writeFileSync(
  dartGitignore,
  readFileSync(dartGitignore, "utf8")
    .split(/\r?\n/)
    .filter((line) => line !== "pubspec.lock")
    .join("\n"),
  "utf8",
);

function run(command, args, cwd) {
  const result = spawnSync(command, args, {
    cwd,
    encoding: "utf8",
    shell: process.platform === "win32",
    stdio: "inherit",
  });
  if (result.error) throw result.error;
  if (result.status !== 0) process.exit(result.status ?? 1);
}

run("dart", ["pub", "get"], dartRoot);
run("dart", ["run", "build_runner", "build", "--delete-conflicting-outputs"], dartRoot);
run("dart", ["format", "lib", "test"], dartRoot);

function normalizeGeneratedText(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      normalizeGeneratedText(target);
      continue;
    }
    if (!entry.isFile() || ![".md", ".ts"].includes(path.extname(entry.name))) continue;
    const source = readFileSync(target, "utf8");
    writeFileSync(target, `${source.replace(/[ \t]+$/gm, "").trimEnd()}\n`, "utf8");
  }
}

normalizeGeneratedText(path.join(packageRoot, "generated"));

/**
 * Strip the `...value` spread that openapi-generator emits in `*ToJSON` for
 * schemas declaring `additionalProperties: false`.
 *
 * The generator reads that keyword as "this model carries extra properties" and
 * passes the source object through verbatim, so the request body ends up with
 * both the wire names and the camelCase originals:
 *
 *     { companyName: "x", company_name: "x", ... }
 *
 * `additionalProperties: false` comes from the API's `StrictModel`
 * (`extra="forbid"`), so the server rejects those camelCase duplicates with a
 * 422 — meaning the strictest models were the only ones whose client could not
 * talk to them. It broke `POST /api/v1/auth/register` outright.
 *
 * The declared properties are exactly what should be sent, so removing the
 * spread is what the schema already says. Done here rather than by hand
 * because the clients are regenerated.
 */
function dropAdditionalPropertySpread(directory) {
  let patched = 0;
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      patched += dropAdditionalPropertySpread(target);
      continue;
    }
    if (!entry.isFile() || path.extname(entry.name) !== ".ts") continue;
    const source = readFileSync(target, "utf8");
    if (!source.includes("...value,")) continue;
    // Line-based rather than a regex so the intent stays obvious: the
    // generator always emits the spread on a line of its own.
    const lines = source.split("\n");
    const kept = lines.filter((line) => line.trim() !== "...value,");
    if (kept.length === lines.length) continue;
    const cleaned = kept.join("\n");
    writeFileSync(target, cleaned, "utf8");
    patched += 1;
  }
  return patched;
}

const spreadsRemoved = dropAdditionalPropertySpread(
  path.join(packageRoot, "generated", "typescript-fetch", "src"),
);
if (spreadsRemoved > 0) {
  console.log(
    `Removed the additionalProperties spread from ${spreadsRemoved} TypeScript model(s).`,
  );
}

console.log("Generated pinned TypeScript Fetch and Dart Dio clients.");
