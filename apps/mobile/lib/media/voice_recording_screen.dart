import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../design_system/motion.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';

/// Field voice-note cap (D-0xx, Phase 7.6): 10 minutes of AAC/M4A -- long
/// enough for a detailed narrated walkthrough, short enough that a
/// forgotten recording doesn't produce an outsized upload over field
/// connectivity. Matches the backend's
/// `INSPECTION_VOICE_NOTE_MAX_DURATION_MS` (`apps/api/app/inspections/
/// service.py`).
const kMaxVoiceNoteDuration = Duration(minutes: 10);

/// Matches the backend's `INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES` -- rejecting
/// an oversized recording locally (should never happen at this cap/codec,
/// but guards a runaway encoder) saves a doomed upload + round trip.
const kMaxVoiceNoteSizeBytes = 20 * 1024 * 1024;

class VoiceRecordingResult {
  const VoiceRecordingResult({
    required this.path,
    required this.filename,
    required this.sizeBytes,
    required this.durationMs,
  });

  final String path;
  final String filename;
  final int sizeBytes;
  final int durationMs;
}

typedef VoiceRecorderViewBuilder = Widget Function(
  BuildContext context,
  void Function(VoiceRecordingResult result) onRecorded,
  void Function(String message) onError,
);

Widget defaultVoiceRecorderViewBuilder(
  BuildContext context,
  void Function(VoiceRecordingResult) onRecorded,
  void Function(String) onError,
) {
  return _AudioRecorderView(onRecorded: onRecorded, onError: onError);
}

/// Pulled out as a pure function for the same reason `cameraCaptureErrorMessage()`
/// is in `media_capture_screen.dart` -- unit-testable copy without mounting
/// the real `record` plugin, which can't run under `flutter_test`.
String voiceRecordingErrorMessage(Object error) {
  final message = error.toString();
  if (message.toLowerCase().contains('permission')) {
    return 'Microphone access was denied. Enable it in system settings to record a voice note.';
  }
  return "Couldn't record audio on this device.";
}

String formatVoiceNoteDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

double normalizeVoiceAmplitude(double dBFS) {
  // A level meter, not a measurement instrument: -45dB..0dB comfortably
  // spans a quiet room to a raised field voice without the meter pinning
  // full-scale on every syllable.
  const minDb = -45.0;
  const maxDb = 0.0;
  if (dBFS.isNaN || dBFS.isInfinite) return 0;
  return ((dBFS - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
}

/// Records, previews, re-records, or discards a single voice note during an
/// `in_progress` inspection (Phase 7.6). Mirrors `MediaCaptureScreen`'s
/// injectable-builder seam (`recorderBuilder`, defaulting to a real
/// `record`-plugin view) so widget tests never mount the real plugin; live
/// recording itself is verified on a physical device. Pops with a
/// [VoiceRecordingResult] on save, or `null` if the inspector backs out.
class VoiceRecordingScreen extends StatefulWidget {
  const VoiceRecordingScreen({
    this.recorderBuilder = defaultVoiceRecorderViewBuilder,
    super.key,
  });

  final VoiceRecorderViewBuilder recorderBuilder;

  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
  String? _errorMessage;

  void _onRecorded(VoiceRecordingResult result) => Navigator.of(context).pop(result);

  void _onError(String message) => setState(() => _errorMessage = message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record voice note')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: widget.recorderBuilder(context, _onRecorded, _onError)),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  DsSpacing.s4,
                  DsSpacing.s2,
                  DsSpacing.s4,
                  DsSpacing.s4,
                ),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _RecorderPhase { checkingPermission, denied, idle, recording, recorded }

class _AudioRecorderView extends StatefulWidget {
  const _AudioRecorderView({required this.onRecorded, required this.onError});

  final void Function(VoiceRecordingResult) onRecorded;
  final void Function(String) onError;

  @override
  State<_AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<_AudioRecorderView> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final Uuid _uuid = const Uuid();
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  Timer? _elapsedTimer;
  _RecorderPhase _phase = _RecorderPhase.checkingPermission;
  Duration _elapsed = Duration.zero;
  double _level = 0;
  bool _playing = false;
  String? _recordedPath;
  int? _recordedSizeBytes;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playing = state == PlayerState.playing);
    });
    unawaited(_checkPermission());
  }

  Future<void> _checkPermission() async {
    setState(() => _phase = _RecorderPhase.checkingPermission);
    try {
      final granted = await _recorder.hasPermission();
      if (!mounted) return;
      setState(() => _phase = granted ? _RecorderPhase.idle : _RecorderPhase.denied);
    } catch (error) {
      widget.onError(voiceRecordingErrorMessage(error));
      if (mounted) setState(() => _phase = _RecorderPhase.denied);
    }
  }

  Future<void> _start() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = p.join(directory.path, '${_uuid.v4()}.m4a');
      await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
      _amplitudeSubscription =
          _recorder.onAmplitudeChanged(const Duration(milliseconds: 200)).listen((amplitude) {
        if (!mounted) return;
        setState(() => _level = normalizeVoiceAmplitude(amplitude.current));
      });
      setState(() {
        _phase = _RecorderPhase.recording;
        _elapsed = Duration.zero;
      });
      _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsed += const Duration(seconds: 1));
        if (_elapsed >= kMaxVoiceNoteDuration) unawaited(_stop());
      });
    } catch (error) {
      widget.onError(voiceRecordingErrorMessage(error));
    }
  }

  Future<void> _stop() async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    unawaited(_amplitudeSubscription?.cancel());
    try {
      final path = await _recorder.stop();
      if (path == null) {
        widget.onError("Couldn't save the recording.");
        if (mounted) setState(() => _phase = _RecorderPhase.idle);
        return;
      }
      final size = await File(path).length();
      if (!mounted) return;
      setState(() {
        _recordedPath = path;
        _recordedSizeBytes = size;
        _phase = _RecorderPhase.recorded;
        _level = 0;
      });
    } catch (error) {
      widget.onError(voiceRecordingErrorMessage(error));
      if (mounted) setState(() => _phase = _RecorderPhase.idle);
    }
  }

  Future<void> _togglePlayback() async {
    final path = _recordedPath;
    if (path == null) return;
    if (_playing) {
      await _player.pause();
    } else {
      await _player.play(DeviceFileSource(path));
    }
  }

  Future<void> _reRecord() async {
    await _player.stop();
    final path = _recordedPath;
    if (path != null) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {
        // Best-effort local cleanup.
      }
    }
    if (!mounted) return;
    setState(() {
      _recordedPath = null;
      _recordedSizeBytes = null;
      _phase = _RecorderPhase.idle;
    });
  }

  void _save() {
    final path = _recordedPath;
    final size = _recordedSizeBytes;
    if (path == null || size == null) return;
    if (size > kMaxVoiceNoteSizeBytes) {
      widget.onError('That recording is too large (voice notes are capped at 10 minutes).');
      return;
    }
    widget.onRecorded(
      VoiceRecordingResult(
        path: path,
        filename: p.basename(path),
        sizeBytes: size,
        durationMs: _elapsed.inMilliseconds,
      ),
    );
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    unawaited(_amplitudeSubscription?.cancel());
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_recorder.dispose());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _RecorderPhase.checkingPermission:
        return const Center(child: AppLoader(label: 'Checking microphone access'));
      case _RecorderPhase.denied:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(DsSpacing.s5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mic_off_outlined, size: 40, color: context.semantic.textMuted),
                const SizedBox(height: DsSpacing.s3),
                Text(
                  'Microphone access was denied. Enable it in system settings to '
                  'record a voice note.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.semantic.textMuted),
                ),
                const SizedBox(height: DsSpacing.s3),
                AppButton(
                  label: 'Try again',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => unawaited(_checkPermission()),
                ),
              ],
            ),
          ),
        );
      case _RecorderPhase.idle:
        return Center(
          child: FloatingActionButton.large(
            key: const Key('start-recording'),
            onPressed: () => unawaited(_start()),
            child: const Icon(Icons.mic),
          ),
        );
      case _RecorderPhase.recording:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LevelMeter(level: _level),
              const SizedBox(height: DsSpacing.s4),
              Text(
                formatVoiceNoteDuration(_elapsed),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: DsSpacing.s5),
              FloatingActionButton.large(
                key: const Key('stop-recording'),
                backgroundColor: DsColors.statusCritical,
                onPressed: () => unawaited(_stop()),
                child: const Icon(Icons.stop),
              ),
            ],
          ),
        );
      case _RecorderPhase.recorded:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formatVoiceNoteDuration(_elapsed), style: const TextStyle(fontSize: 32)),
              const SizedBox(height: DsSpacing.s4),
              IconButton(
                key: const Key('preview-playback'),
                iconSize: 48,
                icon: Icon(_playing ? Icons.pause_circle_outline : Icons.play_circle_outline),
                onPressed: () => unawaited(_togglePlayback()),
              ),
              const SizedBox(height: DsSpacing.s5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    label: 'Re-record',
                    icon: Icons.refresh,
                    variant: AppButtonVariant.ghost,
                    onPressed: () => unawaited(_reRecord()),
                  ),
                  const SizedBox(width: DsSpacing.s3),
                  AppButton(
                    key: const Key('save-recording'),
                    label: 'Save',
                    icon: Icons.check,
                    onPressed: _save,
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }
}

/// A pulsing level meter (D-0xx, Phase 7.6) reacting to live input
/// amplitude -- gloves-on-field-friendly: one glanceable indicator rather
/// than a scrolling waveform history to parse mid-inspection. Under reduced
/// motion, the disc still resizes with [level] (still legible at a glance)
/// but without an animated transition between sizes.
class _LevelMeter extends StatelessWidget {
  const _LevelMeter({required this.level});

  final double level;

  @override
  Widget build(BuildContext context) {
    final size = 72.0 + level * 48;
    return SizedBox(
      width: 120,
      height: 120,
      child: Center(
        child: AnimatedContainer(
          duration: motionDuration(context, const Duration(milliseconds: 150)),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DsColors.accent500.withAlpha(60 + (level * 120).round()),
            border: Border.all(color: DsColors.accent500, width: 2),
          ),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      ),
    );
  }
}
