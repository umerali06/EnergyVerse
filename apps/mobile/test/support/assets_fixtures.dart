import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';

AssetListItem assetListItemFixture({
  String id = 'asset-1',
  String assetTag = 'PMP-001',
  String name = 'Feed Pump',
  String category = 'Pump',
  AssetListItemCurrentStatusEnum currentStatus = AssetListItemCurrentStatusEnum.healthy,
  String facilityId = 'facility-1',
  String? areaId = 'area-1',
  String? manufacturer = 'Acme Co',
  String? model = 'X200',
  String? parentAssetId,
  DateTime? updatedAt,
}) {
  return AssetListItem(
    (builder) => builder
      ..id = id
      ..assetTag = assetTag
      ..name = name
      ..category = category
      ..currentStatus = currentStatus
      ..facilityId = facilityId
      ..areaId = areaId
      ..manufacturer = manufacturer
      ..model = model
      ..parentAssetId = parentAssetId
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = updatedAt ?? DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

AssetListPage assetListPageFixture({List<AssetListItem>? items, String? nextCursor}) {
  return AssetListPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [assetListItemFixture()])
      ..nextCursor = nextCursor,
  );
}

AssetDetail assetDetailFixture({
  String id = 'asset-1',
  String assetTag = 'PMP-001',
  String name = 'Feed Pump',
  String category = 'Pump',
  AssetDetailCurrentStatusEnum currentStatus = AssetDetailCurrentStatusEnum.healthy,
  String facilityId = 'facility-1',
  String? areaId = 'area-1',
  String? manufacturer = 'Acme Co',
  String? model = 'X200',
  String? serialNumber = 'SN-42',
  String? description = 'Primary feed pump for Unit 12.',
  double? gpsLat = 29.7604,
  double? gpsLng = -95.3698,
  String? parentAssetId,
  List<String>? photos,
  List<String>? documents,
  List<String>? manuals,
}) {
  return AssetDetail(
    (builder) => builder
      ..id = id
      ..assetTag = assetTag
      ..name = name
      ..category = category
      ..currentStatus = currentStatus
      ..facilityId = facilityId
      ..areaId = areaId
      ..manufacturer = manufacturer
      ..model = model
      ..serialNumber = serialNumber
      ..description = description
      ..gpsLat = gpsLat
      ..gpsLng = gpsLng
      ..parentAssetId = parentAssetId
      ..photos = photos != null ? ListBuilder(photos) : null
      ..documents = documents != null ? ListBuilder(documents) : null
      ..manuals = manuals != null ? ListBuilder(manuals) : null
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = DateTime.utc(2026, 1, 5),
  );
}

AssetHistoryEvent assetHistoryEventFixture({
  String id = 'event-1',
  DateTime? occurredAt,
  String summary = 'Inspection completed',
  String type = 'inspection',
}) {
  return AssetHistoryEvent(
    (builder) => builder
      ..id = id
      ..occurredAt = occurredAt ?? DateTime.now().subtract(const Duration(hours: 2))
      ..summary = summary
      ..type = type,
  );
}

AssetHistoryPage assetHistoryPageFixture({List<AssetHistoryEvent>? items, String? nextCursor}) {
  return AssetHistoryPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [])
      ..nextCursor = nextCursor,
  );
}

FacilityDetail facilityFixture({
  String id = 'facility-1',
  String name = 'Acme Refinery',
  FacilityDetailStatusEnum status = FacilityDetailStatusEnum.active,
  String timezone = 'UTC',
}) {
  return FacilityDetail(
    (builder) => builder
      ..id = id
      ..name = name
      ..status = status
      ..timezone = timezone
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = DateTime.utc(2026, 1, 1),
  );
}

FacilityListPage facilityListPageFixture({List<FacilityDetail>? items, String? nextCursor}) {
  return FacilityListPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [facilityFixture()])
      ..nextCursor = nextCursor,
  );
}

AreaDetail areaFixture({
  String id = 'area-1',
  String facilityId = 'facility-1',
  String name = 'Unit 12',
}) {
  return AreaDetail(
    (builder) => builder
      ..id = id
      ..facilityId = facilityId
      ..name = name
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = DateTime.utc(2026, 1, 1),
  );
}

AreaListPage areaListPageFixture({List<AreaDetail>? items, String? nextCursor}) {
  return AreaListPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [areaFixture()])
      ..nextCursor = nextCursor,
  );
}
