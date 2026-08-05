import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/media/media_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A capture-slot stand-in with buttons that simulate a photo/error --
/// live camera capture can't run in CI, so every widget test exercises this
/// instead of the real `camera` plugin (verified on a physical device by
/// hand), mirroring `QrScanScreen`'s injectable `scannerBuilder` precedent.
Widget fakeCaptureBuilder(
  BuildContext context,
  void Function(MediaCaptureResult) onCaptured,
  void Function(String) onError,
) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => onCaptured(
            const MediaCaptureResult(
              kind: 'photo',
              path: '/tmp/photo.jpg',
              filename: 'photo.jpg',
              sizeBytes: 1000,
            ),
          ),
          child: const Text('Simulate photo capture'),
        ),
        ElevatedButton(
          onPressed: () => onError('Camera access was denied.'),
          child: const Text('Simulate camera error'),
        ),
      ],
    ),
  );
}

Future<void> pumpCaptureScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<MediaCaptureResult>(
                  MaterialPageRoute(
                    builder: (_) => const MediaCaptureScreen(captureBuilder: fakeCaptureBuilder),
                  ),
                );
                capturedResult = result;
              },
              child: const Text('Open capture'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open capture'));
  await tester.pumpAndSettle();
}

MediaCaptureResult? capturedResult;

void main() {
  setUp(() {
    capturedResult = null;
  });

  group('cameraCaptureErrorMessage', () {
    test('names camera permission denial specifically', () {
      expect(
        cameraCaptureErrorMessage(Exception('CameraAccessDenied')),
        contains('denied'),
      );
    });

    test('names a missing camera specifically', () {
      expect(
        cameraCaptureErrorMessage(Exception('No cameras available')),
        contains('No usable camera'),
      );
    });

    test('falls back to a generic message for any other failure', () {
      expect(
        cameraCaptureErrorMessage(Exception('boom')),
        "Couldn't use the camera. Choose a photo/video from your gallery below.",
      );
    });
  });

  testWidgets('renders the capture slot and gallery fallback buttons', (tester) async {
    await pumpCaptureScreen(tester);

    expect(find.text('Simulate photo capture'), findsOneWidget);
    expect(find.text('Photo from gallery'), findsOneWidget);
    expect(find.text('Video from gallery'), findsOneWidget);
  });

  testWidgets('a simulated capture pops the screen with the MediaCaptureResult', (tester) async {
    await pumpCaptureScreen(tester);

    await tester.tap(find.text('Simulate photo capture'));
    await tester.pumpAndSettle();

    expect(capturedResult?.kind, 'photo');
    expect(capturedResult?.path, '/tmp/photo.jpg');
    expect(find.text('Open capture'), findsOneWidget); // back on the host screen
  });

  testWidgets('renders whatever error the injected capture slot reports', (tester) async {
    await pumpCaptureScreen(tester);

    await tester.tap(find.text('Simulate camera error'));
    await tester.pump();

    expect(find.text('Camera access was denied.'), findsOneWidget);
  });
}
