import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for SystemApi
void main() {
  final instance = FevApiClient().getSystemApi();

  group(SystemApi, () {
    // Health
    //
    //Future<HealthResponse> getHealth() async
    test('test getHealth', () async {
      // TODO
    });

    // Root
    //
    //Future<ServiceResponse> getRoot() async
    test('test getRoot', () async {
      // TODO
    });
  });
}
