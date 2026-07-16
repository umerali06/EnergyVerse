# FEV API contracts

`openapi.json` is the committed FastAPI contract. Generated clients are checked in:

- `generated/typescript-fetch` — admin client (`typescript-fetch`)
- `generated/dart-dio` — mobile client (`dart-dio`)

OpenAPI Generator CLI `2.15.3` and generator/templates `7.10.0` are pinned in
`package.json` and `openapitools.json`. Generated Dart runtime/build dependencies are
also pinned by the generation script. CI uses Node 22.22.0, pnpm 9.15.9, Temurin
Java 17.0.16+8, and Flutter 3.44.6 (Dart 3.12.2), matching the generation toolchain.

## Regenerate (PowerShell)

From the repository root, after changing an API route or model:

```powershell
cd apps/api
python -m poetry run python -m scripts.export_openapi
cd ..\..\packages\contracts
corepack pnpm install --frozen-lockfile
.\scripts\gen-clients.ps1
cd ..\..
git diff --exit-code -- packages/contracts
```

The last command exits non-zero when the exported spec or either generated client
is stale. Generated files must not be edited manually.

## Success and error conventions

- A single resource is returned directly as its typed response model.
- A future list returns `{ "items": [...], "next_cursor": string | null }`.
  The cursor is opaque: clients only return it to the API. `null` means there are
  no more pages. Total counts are not returned by default because Firestore counts
  can require additional cost/work; a future endpoint must opt in explicitly.
- Every failure uses `{ error, message, details?, request_id }`. `request_id` is
  also returned in `X-Request-ID` for correlation.
