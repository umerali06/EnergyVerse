import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for PlatformApi
void main() {
  final instance = FevApiClient().getPlatformApi();

  group(PlatformApi, () {
    // Get Platform Company
    //
    //Future<PlatformCompanyDetail> getPlatformCompany(String companyId) async
    test('test getPlatformCompany', () async {
      // TODO
    });

    // Get Platform Stats
    //
    //Future<PlatformStats> getPlatformStats() async
    test('test getPlatformStats', () async {
      // TODO
    });

    // List Platform Companies
    //
    //Future<PlatformCompanyPage> listPlatformCompanies({ String cursor, int limit }) async
    test('test listPlatformCompanies', () async {
      // TODO
    });

    // Update Platform Company
    //
    //Future<PlatformCompanyDetail> updatePlatformCompany(String companyId, UpdatePlatformCompanyRequest updatePlatformCompanyRequest) async
    test('test updatePlatformCompany', () async {
      // TODO
    });

    // Update Platform Company Status
    //
    //Future<PlatformCompanyDetail> updatePlatformCompanyStatus(String companyId, UpdateCompanyStatusRequest updateCompanyStatusRequest) async
    test('test updatePlatformCompanyStatus', () async {
      // TODO
    });
  });
}
