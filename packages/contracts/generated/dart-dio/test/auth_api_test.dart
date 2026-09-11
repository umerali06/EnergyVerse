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

    // Register Company Admin
    //
    //Future<CompanyRegistrationResponse> registerCompanyAdmin(CompanyRegistrationRequest companyRegistrationRequest) async
    test('test registerCompanyAdmin', () async {
      // TODO
    });

    // Request Verification Email
    //
    // Send this user a branded verification email through SES.  Returns `sent=false` when the address is already verified -- that is a no-op, not a failure. A missing SES configuration is reported as a 503 rather than a 500: the caller asked for something the deployment cannot currently do, and the distinction is actionable.
    //
    //Future<VerificationEmailResponse> sendVerificationEmail() async
    test('test sendVerificationEmail', () async {
      // TODO
    });
  });
}
