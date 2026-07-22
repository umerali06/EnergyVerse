import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for CompanyApi
void main() {
  final instance = FevApiClient().getCompanyApi();

  group(CompanyApi, () {
    // Get Company
    //
    //Future<CompanyProfile> getCompany() async
    test('test getCompany', () async {
      // TODO
    });

    // Remove Company Logo
    //
    //Future<CompanyProfile> removeCompanyLogo() async
    test('test removeCompanyLogo', () async {
      // TODO
    });

    // Update Company
    //
    //Future<CompanyProfile> updateCompany(UpdateCompanyRequest updateCompanyRequest) async
    test('test updateCompany', () async {
      // TODO
    });

    // Upload Company Logo
    //
    //Future<CompanyProfile> uploadCompanyLogo(MultipartFile file) async
    test('test uploadCompanyLogo', () async {
      // TODO
    });
  });
}
