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
    // Send this user a branded verification email through SES.  Returns `sent=false` when the address is already verified -- that is a no-op, not a failure. A missing SES configuration is reported as a 503 rather than a 500: the caller asked for something the deployment cannot currently do, and the distinction is actionable.  A configured-but-refused SES is a 502, kept separate from both. Credentials can be *present* and still rejected -- a rotated key, an unverified sender, the wrong region, sandbox restrictions -- and `ses_configured` cannot see any of that, so this used to escape as an unhandled 500 saying \"the server is broken\" about a working server whose mail provider had refused it. It matters more since D-103, because registration now sends through this route rather than the provider's own unbranded sender; the admin client falls back to that sender on any failure here, and a truthful status is what lets it tell \"cannot send\" apart from a genuine fault.
    //
    //Future<VerificationEmailResponse> sendVerificationEmail() async
    test('test sendVerificationEmail', () async {
      // TODO
    });
  });
}
