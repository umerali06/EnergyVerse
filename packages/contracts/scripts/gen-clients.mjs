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
  rmSync(path.join(packageRoot, output), { force: true, recursive: true });
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

console.log("Generated pinned TypeScript Fetch and Dart Dio clients.");
