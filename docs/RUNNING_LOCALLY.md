# Running FEV Locally — Admin, Flutter Web, Flutter Mobile

End-to-end guide for bringing up the whole stack on a Windows dev machine:
FastAPI backend, Next.js admin dashboard, and the Flutter field app on web,
Windows desktop, and a real Android device / emulator.

Everything below is PowerShell. The three apps run in **three separate
terminals** and stay running.

---

## 0. Toolchain

| Tool | Required | Verified on this machine |
| --- | --- | --- |
| Python | 3.11+ | 3.12.10 |
| Poetry | 1.8+ | 2.4.1 |
| Node.js | 20+ | 22.22.0 |
| pnpm | 9+ | 11.13.0 |
| Flutter | 3.x stable | 3.44.6 (Dart 3.12.2) |

Check them:

```powershell
python --version; poetry --version; node -v; pnpm -v; flutter --version
flutter devices    # should list at least Chrome (web) and Windows (desktop)
```

---

## 1. One-time setup

### 1.1 Install dependencies

```powershell
cd "E:\freelancing projects\EnergyVerse"

cd apps\api    ; poetry install ; cd ..\..
cd apps\admin  ; pnpm install   ; cd ..\..
cd apps\mobile ; flutter pub get ; cd ..\..
```

> `apps/admin` has its own `pnpm-workspace.yaml`. Always run `pnpm` **from
> inside `apps/admin`** — running it from the repo root resolves the wrong
> workspace.

### 1.2 Environment files

Two env files drive local dev. On this machine both already exist and are
filled in — check before you recreate them:

```powershell
Test-Path apps\api\.env          # backend  (Firebase Admin creds, AI key)
Test-Path apps\admin\.env.local  # admin    (public Firebase web config)
```

If either is missing, copy the example and fill it:

```powershell
Copy-Item apps\api\.env.example apps\api\.env
Copy-Item apps\admin\.env.example apps\admin\.env.local
```

**`apps/api/.env`** (server-side, secret — never commit):

```
FIREBASE_PROJECT_ID=<project-id>
GOOGLE_APPLICATION_CREDENTIALS=C:\path\to\service-account.json
# or, instead of the path:  FIREBASE_CREDENTIALS_B64=<base64 of that json>
FIREBASE_STORAGE_BUCKET=<project>.firebasestorage.app
FIREBASE_WEB_API_KEY=<web-api-key>       # real-login integration tests only
SEED_DEMO_PASSWORD=<local dev password>  # password for the seeded demo users
ANTHROPIC_API_KEY=<key>                  # Phase 7.10 AI photo analysis
APP_BASE_URL=http://localhost:3000       # QR deep-link target
```

**`apps/admin/.env.local`** (browser-exposed, public identifiers only — never
put a service account here):

```
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
NEXT_PUBLIC_FIREBASE_API_KEY=...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=<project>.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=<project-id>
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=<project>.firebasestorage.app
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=...
NEXT_PUBLIC_FIREBASE_APP_ID=...
```

The Flutter app needs **no** env file: `apps/mobile/lib/firebase_options.dart`
and `apps/mobile/lib/config.dart` carry working defaults for the shared dev
Firebase project and `http://localhost:8000`. Override them with
`--dart-define` only when pointing at a different project or host (see §4/§5).

### 1.3 Seed the demo tenant

Run once (idempotent — safe to re-run):

```powershell
cd apps\api
poetry run python -m scripts.seed --with-auth-users
cd ..\..
```

This creates the permission catalog, two demo companies, the seven system
roles, and one demo user per role **in Firebase Auth** with the password from
`SEED_DEMO_PASSWORD`. Without `--with-auth-users` it only writes Firestore
records with placeholder `demo-` UIDs, which cannot log in.

Demo logins (password = `SEED_DEMO_PASSWORD`):

| Email | Role |
| --- | --- |
| `super_admin@acme.example.invalid` | Super Admin (all permissions) |
| `company_admin@acme.example.invalid` | Company Admin |
| `operations_manager@acme.example.invalid` | Operations Manager |
| `field_inspector@acme.example.invalid` | Field Inspector (mobile persona) |
| `maintenance_technician@acme.example.invalid` | Maintenance Technician |
| `hse_manager@acme.example.invalid` | HSE Manager |
| `executive@acme.example.invalid` | Executive (read-only) |
| `company_admin@beta.example.invalid` | Company Admin of the 2nd tenant |

Use the second tenant to eyeball multi-tenant isolation. Full account list,
per-role permissions, and a suggested test matrix: [TEST_ACCOUNTS.md](TEST_ACCOUNTS.md).

> Seeded users are created **unverified**, and every protected route sits behind
> `require_verified_email`. The `.invalid` demo domains can never receive a
> verification email, so mark them verified once — see the snippet in
> [TEST_ACCOUNTS.md](TEST_ACCOUNTS.md#email-verification).

---

## 2. Terminal 1 — Backend API

```powershell
cd "E:\freelancing projects\EnergyVerse\apps\api"
poetry run uvicorn app.main:app --reload
```

- API: <http://localhost:8000>
- Health: <http://localhost:8000/health> — 200 always; reports Firestore as
  `unconfigured` when no credentials, otherwise does a real timeout-bounded read.
- Swagger: <http://localhost:8000/docs>

CORS in dev allows **any** `localhost`/`127.0.0.1` origin
(`CORS_ALLOW_ALL_LOCALHOST=true` by default), so random Flutter web ports work
without touching the config.

Start this **first** — both clients call it on load.

---

## 3. Terminal 2 — Admin panel (Next.js)

```powershell
cd "E:\freelancing projects\EnergyVerse\apps\admin"
pnpm dev
```

- Public marketing site: <http://localhost:3000> — plus `/pricing` and `/about`.
  These need no sign-in, which is why opening the app in a browser now shows a
  landing page instead of the login form.
- Sign in: <http://localhost:3000/login> · create an organization:
  <http://localhost:3000/signup>
- Signed-in dashboard: <http://localhost:3000/dashboard>
- Design-system showcase (dev only): <http://localhost:3000/design-system>

Log in with any demo email above. Client route guards are UX only — the API's
`require_permission` + `require_verified_email` stay authoritative, so a
low-permission role sees a branded 403 page *and* gets a real 403 from the API.

Production-style run:

```powershell
pnpm build
pnpm start          # http://localhost:3000
```

---

## 4. Terminal 3 — Flutter **web**

```powershell
cd "E:\freelancing projects\EnergyVerse\apps\mobile"
flutter run -d chrome --web-port 8080
```

- App: <http://localhost:8080>
- Design-system showcase: add `--route=/design-system`

Fixing `--web-port 8080` keeps the origin stable (it is also in the API's
explicit CORS allowlist). In the terminal: `r` = hot reload, `R` = hot restart,
`q` = quit.

Pointing at a non-default backend or Firebase project:

```powershell
flutter run -d chrome --web-port 8080 `
  --dart-define=API_BASE_URL=http://localhost:8000 `
  --dart-define=FIREBASE_API_KEY=<web-api-key> `
  --dart-define=FIREBASE_AUTH_DOMAIN=<project>.firebaseapp.com `
  --dart-define=FIREBASE_PROJECT_ID=<project-id> `
  --dart-define=FIREBASE_STORAGE_BUCKET=<project>.firebasestorage.app `
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=<sender-id> `
  --dart-define=FIREBASE_APP_ID=<web-app-id>
```

`--dart-define` values are baked in at compile time, so changing one needs a
full restart — hot reload will not pick it up.

Release web build:

```powershell
flutter build web            # output: build\web
```

### Windows desktop (fastest non-web loop)

```powershell
flutter run -d windows
```

---

## 5. Flutter on a **real phone / emulator**

### 5.1 Android emulator

```powershell
flutter emulators                       # list AVDs
flutter emulators --launch <emulator-id>
cd "E:\freelancing projects\EnergyVerse\apps\mobile"
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

`10.0.2.2` is the emulator's alias for the host machine — plain `localhost`
points at the emulator itself and will fail to connect.

### 5.2 Physical Android device

1. Enable Developer options → USB debugging, plug in, accept the RSA prompt.
2. `flutter devices` should now list it.
3. Bridge the API port to the phone, then run:

```powershell
adb reverse tcp:8000 tcp:8000
flutter run -d <device-id>          # localhost:8000 now works on the phone
```

Alternative to `adb reverse` (needed over Wi-Fi and on iOS): bind uvicorn to
all interfaces and pass your LAN IP.

```powershell
# Terminal 1
poetry run uvicorn app.main:app --reload --host 0.0.0.0

# Terminal 3
ipconfig                                  # find the IPv4 address, e.g. 192.168.1.20
flutter run -d <device-id> --dart-define=API_BASE_URL=http://192.168.1.20:8000
```

Windows Firewall prompts on the first `--host 0.0.0.0` run — allow it on the
private network.

### 5.3 Android specifics

- `minSdk` is **28** (forced by `ar_flutter_plugin_2`). Older devices/AVDs will
  not install the app.
- The app initializes Firebase from `firebase_options.dart` (dart-defines /
  baked defaults), **not** from `google-services.json` — no native Firebase file
  is committed. If Firebase Auth misbehaves on a native build, register an
  Android app in the Firebase console and pass its app id via
  `--dart-define=FIREBASE_APP_ID=...`.
- Camera, microphone (voice notes), and GPS need real runtime permissions —
  grant them at the first prompt.
- **AR measurement** needs an ARCore-capable Android device. On web and Windows
  choose **Manual** in the "Add measurement" dialog instead.

### 5.4 iOS

Requires macOS + Xcode; not runnable from this Windows box. On a Mac:
`cd apps/mobile && flutter run -d <ios-device>` with the same
`--dart-define=API_BASE_URL=...`.

---

## 6. Release builds

```powershell
cd apps\admin  ; pnpm build                       # .next
cd ..\mobile   ; flutter build web                # build\web
                 flutter build apk --release      # build\app\outputs\flutter-apk
                 flutter build appbundle --release
```

The Android release build is currently signed with the **debug** keystore
(`apps/mobile/android/app/build.gradle.kts`) — replace the signing config
before any real distribution.

---

## 7. Checks before pushing

```powershell
cd apps\api    ; poetry run ruff check . ; poetry run mypy . ; poetry run pytest
cd ..\admin    ; pnpm lint ; pnpm test ; pnpm build
cd ..\mobile   ; flutter analyze ; flutter test
```

Run `ruff check .` over the whole package — per-file runs miss findings that CI
catches.

After changing an API route or model, regenerate both typed clients:

```powershell
cd apps\api
poetry run python -m scripts.export_openapi
cd ..\..\packages\contracts
pnpm install --frozen-lockfile
.\scripts\gen-clients.ps1
cd ..\..
git diff --exit-code -- packages\contracts
```

After changing `packages/design-tokens/tokens.json`:

```powershell
node packages\design-tokens\scripts\generate.mjs
```

---

## 8. Troubleshooting

**401 immediately after a successful sign-in.** Almost always Windows clock
drift — Firebase rejects tokens whose issue time is in the future. Fix in an
elevated PowerShell:

```powershell
w32tm /resync
```

**`flutter analyze` "fails" with only warnings.** It exits non-zero on warnings
too, so a non-zero exit does not by itself mean errors. Read the output before
assuming a break.

**Admin: `pnpm` installs nothing / wrong deps.** You ran it from the repo root.
`cd apps\admin` first.

**Flutter web CORS errors.** The backend allows all localhost origins in dev.
If `CORS_ALLOW_ALL_LOCALHOST` was disabled, re-enable it or run web on port
8080, which is in the explicit allowlist.

**Firestore "index required" errors right after a deploy.** Composite indexes
take a few minutes to build; retry rather than rewriting the query.

**`vitest` flake in `company-settings-page.test.tsx`** under a full `pnpm test`
on this Windows box is a known pre-existing flake, unrelated to current work.
Re-run that file alone to confirm.

**Port already in use.**

```powershell
netstat -ano | Select-String ":8000|:3000|:8080"
Stop-Process -Id <pid> -Force
```

**Stale Flutter build after dependency or dart-define changes.**

```powershell
flutter clean; flutter pub get
```

---

## 9. TL;DR — three terminals

```powershell
# 1  backend             -> http://localhost:8000
cd "E:\freelancing projects\EnergyVerse\apps\api"    ; poetry run uvicorn app.main:app --reload

# 2  admin panel         -> http://localhost:3000
cd "E:\freelancing projects\EnergyVerse\apps\admin"  ; pnpm dev

# 3  flutter web         -> http://localhost:8080
cd "E:\freelancing projects\EnergyVerse\apps\mobile" ; flutter run -d chrome --web-port 8080
```

Sign in as `company_admin@acme.example.invalid` on admin and
`field_inspector@acme.example.invalid` on mobile, using `SEED_DEMO_PASSWORD`.
