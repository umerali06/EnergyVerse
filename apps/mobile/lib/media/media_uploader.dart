import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// One in-progress/completed upload attempt -- a thin, testable seam over
/// `firebase_storage`'s `UploadTask`. `UploadTask`'s own constructor is
/// private (only reachable via a real `Reference.putFile()` call against a
/// real `FirebaseStorage` instance, which itself requires
/// `Firebase.initializeApp()`), so it can't be faked directly without
/// standing up a three-layer platform-interface stack. This mirrors the
/// codebase's established pattern for hard-to-fake native/plugin surfaces
/// (e.g. `QrScanScreen`'s injectable `scannerBuilder`, `GeolocatorPlatform`'s
/// swapped-in double for 7.3) -- wrap the minimum surface actually used,
/// fake that instead.
abstract class MediaUpload {
  Stream<int> get bytesTransferred;
  Future<void> get done;
  Future<void> cancel();
}

/// Uploads a local file to a Storage path and can delete one back out.
/// [FirebaseMediaUploader] is the real implementation; tests use a fake.
abstract class MediaUploader {
  MediaUpload upload(String storagePath, File file, String contentType);
  Future<void> delete(String storagePath);
}

class FirebaseMediaUploader implements MediaUploader {
  FirebaseMediaUploader({FirebaseStorage? storage}) : _storageOverride = storage;

  /// Resolved lazily, only when `upload()`/`delete()` actually run --
  /// `FirebaseStorage.instance` throws without a real `Firebase.
  /// initializeApp()` call, and constructing a `FirebaseMediaUploader` (e.g.
  /// as `MediaUploadWorker`'s/`LocalMediaRepository`'s default) must stay
  /// safe under `flutter_test`, which never makes that call.
  final FirebaseStorage? _storageOverride;
  FirebaseStorage get _storage => _storageOverride ?? FirebaseStorage.instance;

  @override
  MediaUpload upload(String storagePath, File file, String contentType) {
    final task = _storage.ref(storagePath).putFile(
          file,
          SettableMetadata(contentType: contentType),
        );
    return _FirebaseMediaUpload(task);
  }

  @override
  Future<void> delete(String storagePath) => _storage.ref(storagePath).delete();
}

class _FirebaseMediaUpload implements MediaUpload {
  _FirebaseMediaUpload(this._task);

  final UploadTask _task;

  @override
  Stream<int> get bytesTransferred =>
      _task.snapshotEvents.map((snapshot) => snapshot.bytesTransferred);

  @override
  Future<void> get done => _task;

  @override
  Future<void> cancel() => _task.cancel();
}
