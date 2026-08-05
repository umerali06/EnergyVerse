import 'dart:async';
import 'dart:io';

import 'package:fev_mobile/media/media_uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A controllable [MediaUpload] the test drives directly -- no platform
/// channel, no real bytes. [complete]/[fail] resolve [done] and emit a
/// terminal `bytesTransferred` event; [emitProgress] simulates an
/// intermediate progress tick.
class FakeMediaUpload implements MediaUpload {
  final _controller = StreamController<int>.broadcast();
  final _completer = Completer<void>();
  bool cancelled = false;

  @override
  Stream<int> get bytesTransferred => _controller.stream;

  @override
  Future<void> get done => _completer.future;

  @override
  Future<void> cancel() async {
    cancelled = true;
    if (!_completer.isCompleted) {
      _completer.completeError(
        FirebaseException(plugin: 'firebase_storage', code: 'cancelled', message: 'cancelled'),
      );
    }
  }

  void emitProgress(int bytesTransferred) => _controller.add(bytesTransferred);

  void complete() {
    if (!_completer.isCompleted) _completer.complete();
  }

  void fail(String code, String message) {
    if (!_completer.isCompleted) {
      _completer.completeError(FirebaseException(plugin: 'firebase_storage', code: code, message: message));
    }
  }
}

typedef UploadFn = FakeMediaUpload Function(String storagePath, File file, String contentType);

/// A configurable [MediaUploader] double -- every call to [upload] is
/// recorded and, by default, returns a fresh auto-completing
/// [FakeMediaUpload]; pass [onUpload] to control specific attempts
/// (fail the first, succeed the second, etc.).
class FakeMediaUploader implements MediaUploader {
  FakeMediaUploader({UploadFn? onUpload}) : _onUpload = onUpload;

  final UploadFn? _onUpload;
  final List<String> uploadedPaths = [];
  final List<String> deletedPaths = [];

  @override
  MediaUpload upload(String storagePath, File file, String contentType) {
    uploadedPaths.add(storagePath);
    final handler = _onUpload;
    if (handler != null) return handler(storagePath, file, contentType);
    final upload = FakeMediaUpload();
    scheduleMicrotask(upload.complete);
    return upload;
  }

  @override
  Future<void> delete(String storagePath) async {
    deletedPaths.add(storagePath);
  }
}
