import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals"),
  {
    // Dynamic-theming guard (Phase 2.1c): raw hex colors and raw font-family
    // declarations are only allowed inside the token layer. Everything else
    // must consume tokens so a brand change propagates from one place.
    files: ["src/**/*.{ts,tsx}"],
    ignores: [
      "src/design-system/tokens.generated.ts",
      "src/design-system/tokens.generated.css",
    ],
    rules: {
      "no-restricted-syntax": [
        "error",
        {
          selector: "Literal[value=/#[0-9a-fA-F]{3,8}([^0-9a-zA-Z]|$)/]",
          message:
            "Raw hex colors are banned outside packages/design-tokens. Use a design token (Tailwind class or CSS variable).",
        },
        {
          selector: "TemplateElement[value.raw=/#[0-9a-fA-F]{6}/]",
          message:
            "Raw hex colors are banned outside packages/design-tokens. Use a design token (Tailwind class or CSS variable).",
        },
        {
          selector: "Property[key.name='fontFamily'] Literal[value=/[A-Za-z]/]",
          message:
            "Raw font-family declarations are banned. Use the token-backed Tailwind font classes (font-sans/font-heading/font-mono).",
        },
      ],
    },
  },
];

export default eslintConfig;
