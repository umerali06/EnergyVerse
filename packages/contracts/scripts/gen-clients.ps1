$ErrorActionPreference = "Stop"
$packageRoot = Split-Path -Parent $PSScriptRoot
Push-Location $packageRoot
try {
    corepack pnpm run generate
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
    Pop-Location
}
