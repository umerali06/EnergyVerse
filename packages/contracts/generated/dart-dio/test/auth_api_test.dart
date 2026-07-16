import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for AuthApi
void main() {
  final instance = FevApiClient().getAuthApi();

  group(AuthApi, () {
    // Me
    //
    //Future<CurrentUser> getCurrentUser() async
    test('test getCurrentUser', () async {
      // TODO
    });
  });
}
