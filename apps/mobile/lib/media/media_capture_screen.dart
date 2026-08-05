import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';

/// Field video capture caps (D-0xx): 3 minutes / ~1080p. Long enough to show
/// a running fault or a leak, short enough that a forgotten recording
/// doesn't produce an unusably huge upload over field connectivity.
/// `ResolutionPreset.veryHigh` is the `camera` plugin's ~1080p tier.
const kMaxVideoDuration = Duration(minutes: 3);
const kCaptureResolutionPreset = ResolutionPreset.veryHigh;

/// Matches the backend's `INSPECTION_MEDIA_RULES` (`apps/api/app/
/// inspections/service.py`) -- rejecting an oversized gallery-pick locally
/// saves a doomed upload + a round trip just to get a 413 back.
const kMaxPhotoSizeBytes = 15 * 1024 * 1024;
const kMaxVideoSizeBytes = 500 * 1024 * 1024;

class MediaCaptureResult {
  const MediaCaptureResult({
    required this.kind,
    required this.path,
    required this.filename,
    required this.sizeBytes,
  });

  /// 'photo' | 'video'.
  final String kind;
  final String path;
  final String filename;
  final int sizeBytes;
}

typedef MediaCaptureViewBuilder = Widget Function(
  BuildContext context,
  void Function(MediaCaptureResult result) onCaptured,
  void Function(String message) onError,
);

Widget defaultMediaCaptureViewBuilder(
  BuildContext context,
  void Function(MediaCaptureResult) onCaptured,
  void Function(String) onError,
) {
  return _CameraCaptureView(onCaptured: onCaptured, onError: onError);
}

/// Pulled out as a pure function for the same reason `cameraErrorMessage()`
/// is in `qr_scan_screen.dart` (Phase 4.5) -- unit-testable copy without
/// mounting the real `camera` plugin, which can't run under `flutter_test`.
String cameraCaptureErrorMessage(Object error) {
  final message = error.toString();
  if (message.contains('CameraAccessDenied') || message.contains('permission')) {
    return 'Camera access was denied. Enable it in system settings, or choose a '
        'photo/video from your gallery below.';
  }
  if (message.contains('cameras') || message.contains('No cameras')) {
    return 'No usable camera on this device. Choose a photo/video from your gallery below.';
  }
  return "Couldn't use the camera. Choose a photo/video from your gallery below.";
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Photo/video capture during an `in_progress` inspection (Phase 7.4).
/// Mirrors `QrScanScreen`'s injectable-builder seam (`captureBuilder`,
/// defaulting to a real `camera`-plugin view) so widget tests never mount
/// the real plugin; live capture itself is verified on a physical device.
/// Pops with a [MediaCaptureResult] on success, or `null` if the inspector
/// backs out.
class MediaCaptureScreen extends StatefulWidget {
  const MediaCaptureScreen({
    this.captureBuilder = defaultMediaCaptureViewBuilder,
    super.key,
  });

  final MediaCaptureViewBuilder captureBuilder;

  @override
  State<MediaCaptureScreen> createState() => _MediaCaptureScreenState();
}

class _MediaCaptureScreenState extends State<MediaCaptureScreen> {
  String? _errorMessage;

  Future<void> _pickFromGallery({required bool video}) async {
    final picker = ImagePicker();
    final file = video
        ? await picker.pickVideo(source: ImageSource.gallery, maxDuration: kMaxVideoDuration)
        : await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null) return;
    final size = await file.length();
    final cap = video ? kMaxVideoSizeBytes : kMaxPhotoSizeBytes;
    if (size > cap) {
      setState(() {
        _errorMessage = video
            ? 'That video is too large (field video is capped at 3 minutes).'
            : 'That photo is too large.';
      });
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop(
      MediaCaptureResult(
        kind: video ? 'video' : 'photo',
        path: file.path,
        filename: file.name,
        sizeBytes: size,
      ),
    );
  }

  void _onCaptured(MediaCaptureResult result) => Navigator.of(context).pop(result);

  void _onError(String message) => setState(() => _errorMessage = message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture media')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: widget.captureBuilder(context, _onCaptured, _onError)),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  DsSpacing.s4,
                  DsSpacing.s2,
                  DsSpacing.s4,
                  0,
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(DsSpacing.s4),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Photo from gallery',
                      variant: AppButtonVariant.ghost,
                      onPressed: () => unawaited(_pickFromGallery(video: false)),
                    ),
                  ),
                  const SizedBox(width: DsSpacing.s3),
                  Expanded(
                    child: AppButton(
                      label: 'Video from gallery',
                      variant: AppButtonVariant.ghost,
                      onPressed: () => unawaited(_pickFromGallery(video: true)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraCaptureView extends StatefulWidget {
  const _CameraCaptureView({required this.onCaptured, required this.onError});

  final void Function(MediaCaptureResult) onCaptured;
  final void Function(String) onError;

  @override
  State<_CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<_CameraCaptureView> {
  CameraController? _controller;
  bool _recording = false;
  Duration _recordedDuration = Duration.zero;
  Timer? _recordTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_initCamera());
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        widget.onError(
          'No usable camera on this device. Choose a photo/video from your gallery below.',
        );
        return;
      }
      final controller = CameraController(
        cameras.first,
        kCaptureResolutionPreset,
        enableAudio: true,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (error) {
      widget.onError(cameraCaptureErrorMessage(error));
    }
  }

  Future<void> _takePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      final file = await controller.takePicture();
      final size = await file.length();
      widget.onCaptured(
        MediaCaptureResult(kind: 'photo', path: file.path, filename: file.name, sizeBytes: size),
      );
    } catch (error) {
      widget.onError(cameraCaptureErrorMessage(error));
    }
  }

  Future<void> _toggleVideo() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      if (_recording) {
        _recordTimer?.cancel();
        final file = await controller.stopVideoRecording();
        if (mounted) setState(() => _recording = false);
        final size = await file.length();
        widget.onCaptured(
          MediaCaptureResult(kind: 'video', path: file.path, filename: file.name, sizeBytes: size),
        );
        return;
      }
      await controller.startVideoRecording();
      setState(() {
        _recording = true;
        _recordedDuration = Duration.zero;
      });
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _recordedDuration += const Duration(seconds: 1));
        if (_recordedDuration >= kMaxVideoDuration) {
          _recordTimer?.cancel();
          unawaited(_toggleVideo());
        }
      });
    } catch (error) {
      widget.onError(cameraCaptureErrorMessage(error));
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: AppLoader(label: 'Starting camera'));
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(child: CameraPreview(controller)),
        if (_recording)
          Positioned(
            top: DsSpacing.s4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DsSpacing.s3,
                vertical: DsSpacing.s1,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(DsRadius.md),
              ),
              child: Text(
                _formatDuration(_recordedDuration),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(DsSpacing.s5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'capture-photo',
                onPressed: _recording ? null : _takePhoto,
                child: const Icon(Icons.camera_alt),
              ),
              const SizedBox(width: DsSpacing.s5),
              FloatingActionButton(
                heroTag: 'capture-video',
                backgroundColor: _recording ? Colors.red : null,
                onPressed: _toggleVideo,
                child: Icon(_recording ? Icons.stop : Icons.videocam),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
