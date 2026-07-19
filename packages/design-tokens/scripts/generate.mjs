import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const root = resolve(here, "../../..");
const sourcePath = resolve(here, "../tokens.json");
const tokens = JSON.parse(await readFile(sourcePath, "utf8"));
const adminOutput = resolve(root, "apps/admin/src/design-system");
const mobileOutput = resolve(root, "apps/mobile/lib/design_system");
await Promise.all([
  mkdir(adminOutput, { recursive: true }),
  mkdir(mobileOutput, { recursive: true }),
]);

const tsOutput = `// GENERATED from packages/design-tokens/tokens.json. Do not edit.\nexport const designTokens = ${JSON.stringify(tokens, null, 2)} as const;\n`;

const variableLines = [];
for (const [name, scale] of Object.entries(tokens.color.primary)) {
  variableLines.push(`  --color-primary-${name}: ${scale};`);
}
for (const [name, scale] of Object.entries(tokens.color.accent)) {
  variableLines.push(`  --color-accent-${name}: ${scale};`);
}
for (const [name, value] of Object.entries(tokens.color.status)) {
  variableLines.push(`  --color-status-${name}: ${value};`);
}
for (const [name, value] of Object.entries(tokens.color.statusStrong)) {
  variableLines.push(`  --color-status-strong-${name}: ${value};`);
}
for (const [name, value] of Object.entries(tokens.color.statusSoft)) {
  variableLines.push(`  --color-status-soft-${name}: ${value};`);
}
for (const [name, value] of Object.entries(tokens.spacing)) {
  variableLines.push(`  --space-${name}: ${value}px;`);
}
for (const [name, value] of Object.entries(tokens.radius)) {
  variableLines.push(`  --radius-${name}: ${value}px;`);
}
for (const [name, value] of Object.entries(tokens.motion.duration)) {
  variableLines.push(`  --motion-${name}: ${value}ms;`);
}
for (const [name, value] of Object.entries(tokens.motion.easing)) {
  variableLines.push(`  --ease-${name}: cubic-bezier(${value.join(", ")});`);
}

const themeVariables = (theme) => Object.entries(tokens.color.theme[theme])
  .map(([name, value]) => `  --color-${name.replace(/[A-Z]/g, (letter) => `-${letter.toLowerCase()}`)}: ${value};`)
  .join("\n");

const cssOutput = `/* GENERATED from packages/design-tokens/tokens.json. Do not edit. */
:root {
${variableLines.join("\n")}
${themeVariables("dark")}
  color-scheme: dark;
}

:root[data-theme="light"] {
${themeVariables("light")}
  color-scheme: light;
}

:root[data-theme="dark"] {
${themeVariables("dark")}
  color-scheme: dark;
}
`;

const color = (hex) => `Color(0xFF${hex.slice(1).toUpperCase()})`;
const dartMap = (name, values, render) => Object.entries(values)
  .map(([key, value]) => `  static const ${name}${key[0].toUpperCase()}${key.slice(1)} = ${render(value)};`)
  .join("\n");
const durationLines = Object.entries(tokens.motion.duration)
  .map(([name, value]) => `  static const ${name} = Duration(milliseconds: ${value});`)
  .join("\n");
const easingLines = Object.entries(tokens.motion.easing)
  .map(([name, value]) => `  static const ${name} = Cubic(${value.join(", ")});`)
  .join("\n");

const dartOutput = `// GENERATED from packages/design-tokens/tokens.json. Do not edit.
import 'package:flutter/material.dart';

abstract final class DsColors {
${dartMap("primary", tokens.color.primary, color)}
${dartMap("accent", tokens.color.accent, color)}
${dartMap("status", tokens.color.status, color)}
${dartMap("statusStrong", tokens.color.statusStrong, color)}
${dartMap("statusSoft", tokens.color.statusSoft, color)}
${dartMap("dark", tokens.color.theme.dark, color)}
${dartMap("light", tokens.color.theme.light, color)}
}

abstract final class DsTypography {
${Object.entries(tokens.typography.fontFamily).map(([name, value]) => `  static const ${name} = '${value}';`).join("\n")}
${dartMap("size", tokens.typography.fontSize, (value) => `${value}.0`)}
}

abstract final class DsSpacing {
${Object.entries(tokens.spacing).map(([name, value]) => `  static const s${name} = ${value}.0;`).join("\n")}
}

abstract final class DsRadius {
${Object.entries(tokens.radius).map(([name, value]) => `  static const ${name === "2xl" ? "xl2" : name} = ${value}.0;`).join("\n")}
}

abstract final class DsZIndex {
${Object.entries(tokens.zIndex).map(([name, value]) => `  static const ${name} = ${value};`).join("\n")}
}

abstract final class DsMotion {
${durationLines}
${easingLines}
  static const stagger = Duration(milliseconds: ${tokens.motion.staggerMs});
}
`;

await Promise.all([
  writeFile(resolve(adminOutput, "tokens.generated.ts"), tsOutput),
  writeFile(resolve(adminOutput, "tokens.generated.css"), cssOutput),
  writeFile(resolve(mobileOutput, "tokens_generated.dart"), dartOutput),
]);

console.log("Generated admin TypeScript/CSS and Flutter Dart design-token bindings.");
