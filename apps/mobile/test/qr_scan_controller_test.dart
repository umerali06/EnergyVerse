import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/qr/qr_scan_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_qr_api.dart';
import 'support/qr_fixtures.dart';

void main() {
  group('extractQrCode', () {
    test('returns the raw value unchanged when it is already a bare code', () {
      expect(extractQrCode('qr-code-1'), 'qr-code-1');
    });

    test('extracts the trailing path segment from a deep-link URL', () {
      expect(extractQrCode('https://app.example.com/qr/qr-code-1'), 'qr-code-1');
    });

    test('trims whitespace and a trailing slash', () {
      expect(extractQrCode('  https://app.example.com/qr/qr-code-1/  '), 'qr-code-1');
    });
  });

  group('QrScanController', () {
    test('resolves a code and exposes the scan result on success', () async {
      final result = qrScanResultFixture();
      final controller = QrScanController(
        api: FakeQrApi(resolveQrCode: (code) async => result),
      );

      await controller.resolve('https://app.example.com/qr/qr-code-1');

      expect(controller.state, QrScanState.success);
      expect(controller.result, result);
    });

    test('sets notFound state on a 404', () async {
      final controller = QrScanController(
        api: FakeQrApi(
          resolveQrCode: (code) async => throw const ApiException(
            code: 'qr_code_not_found',
            message: 'QR code was not found',
            statusCode: 404,
          ),
        ),
      );

      await controller.resolve('unknown-code');

      expect(controller.state, QrScanState.notFound);
      expect(controller.result, isNull);
    });

    test('sets error state on a network failure', () async {
      final controller = QrScanController(
        api: FakeQrApi(
          resolveQrCode: (code) async => throw const ApiException(
            code: 'network_error',
            message: 'Unable to reach the API',
          ),
        ),
      );

      await controller.resolve('qr-code-1');

      expect(controller.state, QrScanState.error);
      expect(controller.errorMessage, isNotNull);
    });

    test('reset returns to idle and clears the result', () async {
      final controller = QrScanController(
        api: FakeQrApi(resolveQrCode: (code) async => qrScanResultFixture()),
      );
      await controller.resolve('qr-code-1');
      expect(controller.state, QrScanState.success);

      controller.reset();

      expect(controller.state, QrScanState.idle);
      expect(controller.result, isNull);
    });

    test('ignores an empty manual-entry submission', () async {
      var callCount = 0;
      final controller = QrScanController(
        api: FakeQrApi(
          resolveQrCode: (code) async {
            callCount++;
            return qrScanResultFixture();
          },
        ),
      );

      await controller.resolve('   ');

      expect(callCount, 0);
      expect(controller.state, QrScanState.idle);
    });
  });
}
