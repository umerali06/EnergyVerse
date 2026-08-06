import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/media/voice_recording_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A recorder-slot stand-in with buttons that simulate a finished recording,
/// a permission denial, or an unexpected device error -- live audio
/// recording can't run in CI, so every widget test exercises this instead
/// of the real `record` plugin, mirroring `MediaCaptureScreen`'s injectable
/// `captureBuilder` precedent (`media_capture_screen_test.dart`).
Widget fakeRecorderBuilder(
  BuildContext context,
  void Function(VoiceRecordingResult) onRecorded,
  void Function(String) onError,
) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => onRecorded(
            const VoiceRecordingResult(
              path: '/tmp/note.m4a',
              filename: 'note.m4a',
              sizeBytes: 5000,
              durationMs: 42000,
            ),
          ),
          child: const Text('Simulate finished recording'),
        ),
        ElevatedButton(
          onPressed: () => onError(voiceRecordingErrorMessage(Exception('permission denied'))),
          child: const Text('Simulate mic permission denied'),
        ),
      ],
    ),
  );
}

Future<void> pumpRecordingScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<VoiceRecordingResult>(
                  MaterialPageRoute(
                    builder: (_) =>
                        const VoiceRecordingScreen(recorderBuilder: fakeRecorderBuilder),
                  ),
                );
                recordedResult = result;
              },
              child: const Text('Open recorder'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open recorder'));
  await tester.pumpAndSettle();
}

VoiceRecordingResult? recordedResult;

void main() {
  setUp(() {
    recordedResult = null;
  });

  group('voiceRecordingErrorMessage', () {
    test('names microphone permission denial specifically', () {
      expect(
        voiceRecordingErrorMessage(Exception('permission denied')),
        contains('Microphone access was denied'),
      );
    });

    test('falls back to a generic message for any other failure', () {
      expect(
        voiceRecordingErrorMessage(Exception('boom')),
        "Couldn't record audio on this device.",
      );
    });
  });

  group('formatVoiceNoteDuration', () {
    test('formats as mm:ss, zero-padded', () {
      expect(formatVoiceNoteDuration(const Duration(seconds: 5)), '00:05');
      expect(formatVoiceNoteDuration(const Duration(minutes: 2, seconds: 3)), '02:03');
      expect(formatVoiceNoteDuration(const Duration(minutes: 10)), '10:00');
    });
  });

  group('normalizeVoiceAmplitude', () {
    test('clamps a silent/very quiet dBFS reading to 0', () {
      expect(normalizeVoiceAmplitude(-160), 0);
      expect(normalizeVoiceAmplitude(-45), 0);
    });

    test('clamps full-scale dBFS to 1', () {
      expect(normalizeVoiceAmplitude(0), 1);
      expect(normalizeVoiceAmplitude(10), 1);
    });

    test('maps a mid-range reading proportionally', () {
      expect(normalizeVoiceAmplitude(-22.5), closeTo(0.5, 0.01));
    });

    test('treats a NaN/infinite reading as silence rather than crashing', () {
      expect(normalizeVoiceAmplitude(double.nan), 0);
      expect(normalizeVoiceAmplitude(double.negativeInfinity), 0);
    });
  });

  testWidgets('renders the recorder slot', (tester) async {
    await pumpRecordingScreen(tester);

    expect(find.text('Simulate finished recording'), findsOneWidget);
    expect(find.text('Simulate mic permission denied'), findsOneWidget);
  });

  testWidgets('a simulated recording pops the screen with the VoiceRecordingResult',
      (tester) async {
    await pumpRecordingScreen(tester);

    await tester.tap(find.text('Simulate finished recording'));
    await tester.pumpAndSettle();

    expect(recordedResult?.path, '/tmp/note.m4a');
    expect(recordedResult?.durationMs, 42000);
    expect(find.text('Open recorder'), findsOneWidget); // back on the host screen
  });

  testWidgets('renders a graceful message when mic permission is denied', (tester) async {
    await pumpRecordingScreen(tester);

    await tester.tap(find.text('Simulate mic permission denied'));
    await tester.pump();

    expect(find.textContaining('Microphone access was denied'), findsOneWidget);
    // The screen stays open so the inspector can back out or try again --
    // a denial never pops with a result.
    expect(recordedResult, isNull);
  });
}
