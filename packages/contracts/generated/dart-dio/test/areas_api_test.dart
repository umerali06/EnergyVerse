import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for AreasApi
void main() {
  final instance = FevApiClient().getAreasApi();

  group(AreasApi, () {
    // Create Area
    //
    //Future<AreaDetail> createArea(CreateAreaRequest createAreaRequest) async
    test('test createArea', () async {
      // TODO
    });

    // Delete Area
    //
    //Future<AreaDeleted> deleteArea(String areaId) async
    test('test deleteArea', () async {
      // TODO
    });

    // Get Area
    //
    //Future<AreaDetail> getArea(String areaId) async
    test('test getArea', () async {
      // TODO
    });

    // List Areas
    //
    //Future<AreaListPage> listAreas({ String facilityId, String search, String sort, String cursor, int limit }) async
    test('test listAreas', () async {
      // TODO
    });

    // Update Area
    //
    //Future<AreaDetail> updateArea(String areaId, UpdateAreaRequest updateAreaRequest) async
    test('test updateArea', () async {
      // TODO
    });
  });
}
