import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for AssetsApi
void main() {
  final instance = FevApiClient().getAssetsApi();

  group(AssetsApi, () {
    // Create Asset
    //
    //Future<AssetDetail> createAsset(CreateAssetRequest createAssetRequest) async
    test('test createAsset', () async {
      // TODO
    });

    // Delete Asset
    //
    //Future<AssetDeleted> deleteAsset(String assetId) async
    test('test deleteAsset', () async {
      // TODO
    });

    // Get Asset
    //
    //Future<AssetDetail> getAsset(String assetId) async
    test('test getAsset', () async {
      // TODO
    });

    // Get Asset History
    //
    //Future<AssetHistoryPage> getAssetHistory(String assetId) async
    test('test getAssetHistory', () async {
      // TODO
    });

    // List Assets
    //
    //Future<AssetListPage> listAssets({ String facilityId, String areaId, String category, String currentStatus, String parentAssetId, String search, String sort, String cursor, int limit }) async
    test('test listAssets', () async {
      // TODO
    });

    // Update Asset
    //
    //Future<AssetDetail> updateAsset(String assetId, UpdateAssetRequest updateAssetRequest) async
    test('test updateAsset', () async {
      // TODO
    });
  });
}
