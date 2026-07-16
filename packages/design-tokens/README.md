# FEV Design Tokens

`tokens.json` is the only editable source for shared visual and motion values. It
contains the locked brand scales, dark/light semantic colors, Inter and JetBrains
Mono typography, 4px spacing, radii, shadows, z-index, and motion timing/easing.

Regenerate client bindings from the repository root:

```powershell
node packages/design-tokens/scripts/generate.mjs
```

- Next.js consumes generated TypeScript in `tailwind.config.ts` and generated CSS
  custom properties in `globals.css`.
- Flutter consumes generated typed constants from
  `lib/design_system/tokens_generated.dart` when constructing `ThemeData` and
  motion primitives.

Generated files are committed so client builds never require the generator. Never
edit a generated binding directly; update `tokens.json` and regenerate both.

All future admin and mobile screens must reuse these tokens and the client design-
system primitives. Feature modules must not introduce parallel color, spacing,
typography, elevation, or motion constants.
