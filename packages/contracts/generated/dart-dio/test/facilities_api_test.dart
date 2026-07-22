import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for FacilitiesApi
void main() {
  final instance = FevApiClient().getFacilitiesApi();

  group(FacilitiesApi, () {
    // Create Facility
    //
    //Future<FacilityDetail> createFacility(CreateFacilityRequest createFacilityRequest) async
    test('test createFacility', () async {
      // TODO
    });

    // Delete Facility
    //
    //Future<FacilityDeleted> deleteFacility(String facilityId) async
    test('test deleteFacility', () async {
      // TODO
    });

    // Get Facility
    //
    //Future<FacilityDetail> getFacility(String facilityId) async
    test('test getFacility', () async {
      // TODO
    });

    // List Facilities
    //
    //Future<FacilityListPage> listFacilities({ String search, String status, String sort, String cursor, int limit }) async
    test('test listFacilities', () async {
      // TODO
    });

    // Update Facility
    //
    //Future<FacilityDetail> updateFacility(String facilityId, UpdateFacilityRequest updateFacilityRequest) async
    test('test updateFacility', () async {
      // TODO
    });
  });
}
