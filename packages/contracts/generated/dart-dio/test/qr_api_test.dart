import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for QrApi
void main() {
  final instance = FevApiClient().getQrApi();

  group(QrApi, () {
    // Resolve Qr Code
    //
    //Future<QrScanResult> resolveQrCode(String code) async
    test('test resolveQrCode', () async {
      // TODO
    });
  });
}
