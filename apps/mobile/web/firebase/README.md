# Vendored Firebase Web modules

These ESM files are copied from the Apache-2.0 licensed `firebase` npm package
version 12.15.0, the exact Firebase JS SDK version supported by the pinned
FlutterFire packages:

- `firebase-app.js`
- `firebase-auth.js`
- `firebase-storage.js`

FlutterFire otherwise downloads the same modules from `gstatic.com` during app
startup. Keeping them under Flutter's `web/` assets allows the field client to
start on restricted or intermittently connected networks. The Auth and Storage
module imports are mechanically rewritten from the CDN app-module URL to
`./firebase-app.js`.

When FlutterFire's supported Firebase JS SDK version changes, recopy all three
files together from that exact npm package version, rewrite those two imports,
and run `flutter build web` before committing.
