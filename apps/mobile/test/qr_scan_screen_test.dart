import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/auth_controller.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/design_system/primitives.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/qr/qr_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'support/fake_qr_api.dart';

const session = AuthSession(
  uid: 'demo-acme-field_inspector',
  email: 'field_inspector@acme.example.invalid',
  emailVerified: true,
);

class FakeGateway implements AuthGateway {
  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(session);

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'id-token';

  @override
  Future<AuthSession> refreshSession() async => session;

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<AuthSession> signIn(String email, String password) async => session;

  @override
  Future<void> signOut() async {}
}

/// A scanner-slot stand-in with a button that simulates a detected code --
/// live camera scanning can't run in CI, so every widget test exercises this
/// instead of the real `MobileScanner` (verified on a physical device by hand).
Widget fakeScannerBuilder(BuildContext context, void Function(String code) onDetected) {
  return Center(
    child: ElevatedButton(
      onPressed: () => onDetected('https://app.example.com/qr/qr-code-1'),
      child: const Text('Simulate scan'),
    ),
  );
}

Future<void> pumpScanScreen(
  WidgetTester tester,
  FakeQrApi api, {
  Widget Function(BuildContext, void Function(String))? scannerBuilder,
}) async {
  final auth = AuthController(gateway: FakeGateway(), api: api, feedback: (_) {})..start();
  addTearDown(auth.dispose);
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: AuthProvider(
            controller: auth,
            child: QrScanScreen(scannerBuilder: scannerBuilder ?? fakeScannerBuilder),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('cameraErrorMessage', () {
    test('names camera permission denial specifically', () {
      expect(
        cameraErrorMessage(MobileScannerErrorCode.permissionDenied),
        contains('denied'),
      );
    });

    test('names an unsupported device specifically', () {
      expect(
        cameraErrorMessage(MobileScannerErrorCode.unsupported),
        contains('no usable camera'),
      );
    });

    test('falls back to a generic message for any other failure', () {
      expect(
        cameraErrorMessage(MobileScannerErrorCode.genericError),
        'Camera unavailable. Use manual entry below.',
      );
    });
  });

  testWidgets('renders the scanner slot and manual entry fallback', (tester) async {
    final api = FakeQrApi(resolveQrCode: (code) async => throw UnimplementedError());
    await pumpScanScreen(tester, api);

    expect(find.text('Simulate scan'), findsOneWidget);
    expect(find.text('Manual entry'), findsOneWidget);
    expect(find.text('Look up code'), findsOneWidget);
  });

  testWidgets('manual entry resolves through the same controller as a camera detect', (
    tester,
  ) async {
    String? received;
    final gate = Completer<QrScanResult>();
    final api = FakeQrApi(
      resolveQrCode: (code) {
        received = code;
        return gate.future;
      },
    );
    await pumpScanScreen(tester, api);

    await tester.enterText(find.byType(TextField), 'qr-code-1');
    await tester.tap(find.text('Look up code'));
    await tester.pump();

    // Still awaiting the fake's Completer, so the resolving state is
    // observable before it settles.
    expect(find.byType(AppLoader), findsOneWidget);
    expect(received, 'qr-code-1');

    gate.completeError(
      const ApiException(code: 'qr_code_not_found', message: 'not found', statusCode: 404),
    );
    await tester.pumpAndSettle();

    expect(find.text('Code not found'), findsOneWidget);
  });

  testWidgets('a simulated camera detection resolves and shows a network error state', (
    tester,
  ) async {
    final api = FakeQrApi(
      resolveQrCode: (code) async => throw const ApiException(
        code: 'network_error',
        message: 'Unable to reach the API',
      ),
    );
    await pumpScanScreen(tester, api);

    await tester.tap(find.text('Simulate scan'));
    await tester.pumpAndSettle();

    expect(
      find.text("Couldn't reach the network. Check your connection and try again."),
      findsOneWidget,
    );
  });

  testWidgets('renders whatever the injected scanner slot shows for a camera failure', (
    tester,
  ) async {
    final api = FakeQrApi(resolveQrCode: (code) async => throw UnimplementedError());
    await pumpScanScreen(
      tester,
      api,
      scannerBuilder: (context, onDetected) =>
          Center(child: Text(cameraErrorMessage(MobileScannerErrorCode.permissionDenied))),
    );

    expect(
      find.text('Camera access was denied. Enable it in system settings, or use manual entry below.'),
      findsOneWidget,
    );
  });
}
