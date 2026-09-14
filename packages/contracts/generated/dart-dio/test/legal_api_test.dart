import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for LegalApi
void main() {
  final instance = FevApiClient().getLegalApi();

  group(LegalApi, () {
    // What this user accepted, and whether it is still current
    //
    //Future<LegalAcceptanceResponse> getLegalAcceptance() async
    test('test getLegalAcceptance', () async {
      // TODO
    });

    // Send a message to Flacron Energy support
    //
    //Future<ContactResponse> submitContactMessage(ContactRequest contactRequest) async
    test('test submitContactMessage', () async {
      // TODO
    });
  });
}
