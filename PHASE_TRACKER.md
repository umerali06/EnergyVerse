# FEV Phase Tracker

## Status Definitions

- **Not started:** implementation has not begun.
- **In progress:** the current micro-task is actively being built or documented.
- **Testing:** implementation is complete and its focused verification is underway.
- **Done:** the focused result has been shown, accepted as tested, and its architecture connection has been recorded.

Only one micro-task may be active at a time.

| Phase | Scope | Status |
|---|---|---|
| 0 | Foundation and project definition | **COMPLETE** |
| 0.1 | Project bootstrap and persistent context setup | Done |
| 0.2 | Monorepo scaffold — apps/api (FastAPI), apps/admin (Next.js), apps/mobile (Flutter), packages/contracts placeholder, infra/ci (GitHub Actions), infra/firebase placeholder, root config | Done |
| 0.3 | FastAPI ↔ Firebase Admin SDK, Firestore-aware `/health`, and client connectivity indicators | Done |
| 0.4 | Firestore data foundation — tenancy, companies, users, roles, permissions, role mappings, and audit logs | Done |
| 0.5 | Backend auth foundation — Firebase token verification, typed current user, claims, provisioning/link services, auth-user seed migration, and protected `/api/v1/auth/me` | Done |
| 0.6 | RBAC enforcement — permission/role dependencies, demo route gates, denial audits, and admin/mobile guard helpers | Done |
| 0.7 | Shared design system — framework-neutral tokens, dark/light theming, reusable admin/mobile primitives, and reduced-motion-aware animation | Done |
| 0.8 | API contract, generated TypeScript/Dart clients, unified errors/request IDs, typed client wrappers, and toast infrastructure | Done |
| 1 | User-facing authentication and application flows | **COMPLETE** |
| 1.1 | Login screen | Done |
| 1.2 | Signup and email verification | Done |
| 1.3 | Forgot password and password reset | Done |
| 1.4 | Session, token refresh, and route guards | Done |
| 2 | To be defined | In progress |
| 2.1 | To be defined — awaiting supplied scope | **In progress** |
| 3 | To be defined | Not started |
| 4 | To be defined | Not started |
| 5 | To be defined | Not started |
| 6 | To be defined | Not started |
| 7 | To be defined | Not started |
| 8 | To be defined | Not started |
| 9 | To be defined | Not started |
| 10 | To be defined | Not started |
| 11 | To be defined | Not started |
| 12 | To be defined | Not started |
| 13 | To be defined | Not started |
| 14 | To be defined | Not started |
| 15 | To be defined | Not started |
| 16 | To be defined | Not started |
| 17 | To be defined | Not started |
| 18 | To be defined | Not started |
| 19 | To be defined | Not started |
| 20 | To be defined | Not started |

Detailed scopes after Phase 1.2 have not been fully supplied and must not be invented.
