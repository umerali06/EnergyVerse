# Firebase Infrastructure

Firestore is server-only. The Firebase Admin SDK used by FastAPI bypasses
Firestore Security Rules; all direct client reads and writes are denied.
Phase 0.4 keeps this server-only policy unchanged; repositories in FastAPI remain
the only data-access boundary.

## Deploy the rules (PowerShell)

Install and authenticate the Firebase CLI, then run from this directory:

```powershell
npm install --global firebase-tools
firebase login
firebase deploy --only firestore:rules --project <firebase-project-id>
```

The deployment uses `firebase.json` to select `firestore.rules`.
