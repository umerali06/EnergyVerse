import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

const assetsPageSize = 25;
const _lookupLimit = 100;

/// Read-only asset directory (list + detail), plus a one-shot facility/area
/// lookup used both as filter options and as an id -> name resolver for the
/// list/detail breadcrumb — the asset payloads only carry facilityId/areaId,
/// never names. Mirrors the Phase 3.1 users controller.
class AssetsController extends ChangeNotifier {
  static List<AssetListItem>? _staticCachedItems;
  static String? _staticCachedNextCursor;
  static List<FacilityDetail>? _staticCachedFacilities;
  static List<AreaDetail>? _staticCachedAreas;

  static void clearCache() {
    _staticCachedItems = null;
    _staticCachedNextCursor = null;
  }

  /// `initialStatus` seeds the status filter once at construction (e.g. the
  /// dashboard's Critical Assets widget deep-linking in with an argument) --
  /// it is read once, not kept in sync with the route afterward.
  AssetsController({required ApiContract api, String? initialStatus})
      : _api = api,
        status = initialStatus {
    if (_staticCachedFacilities != null) {
      facilities = _staticCachedFacilities!;
      facilitiesStatus = LoadStatus.ready;
    }
    if (_staticCachedAreas != null) {
      areas = _staticCachedAreas!;
      areasStatus = LoadStatus.ready;
    }
    if (_staticCachedItems != null && _staticCachedItems!.isNotEmpty) {
      items = _staticCachedItems!;
      _nextCursor = _staticCachedNextCursor;
      listStatus = LoadStatus.ready;
    } else {
      items = const [];
      listStatus = LoadStatus.loading;
    }
  }

  final ApiContract _api;
  bool _disposed = false;
  int _requestId = 0;

  late LoadStatus listStatus =
      (_staticCachedItems != null && _staticCachedItems!.isNotEmpty)
          ? LoadStatus.ready
          : LoadStatus.loading;
  List<AssetListItem> items =
      (_staticCachedItems != null && _staticCachedItems!.isNotEmpty)
          ? _staticCachedItems!
          : const [];
  String? _nextCursor = _staticCachedNextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;

  late LoadStatus facilitiesStatus =
      _staticCachedFacilities != null ? LoadStatus.ready : LoadStatus.loading;
  List<FacilityDetail> facilities = _staticCachedFacilities ?? const [];
  late LoadStatus areasStatus =
      _staticCachedAreas != null ? LoadStatus.ready : LoadStatus.loading;
  List<AreaDetail> areas = _staticCachedAreas ?? const [];

  String search = '';
  String? facilityId;
  String? areaId;
  String? category;
  String? status;
  String sort = '-created_at';

  Future<void> start() {
    unawaited(loadLookups());
    return _load();
  }

  /// Fetches the facility/area directory used for filter options and
  /// id -> name resolution. Called by the list screen's [start] and,
  /// independently, by the detail screen (which has its own controller
  /// instance since it's reached via a separate pushed route).
  Future<void> loadLookups() => Future.wait([_loadFacilities(), _loadAreas()]);

  Future<void> retry() => _load();

  Future<void> resetFilters() async {
    search = '';
    facilityId = null;
    areaId = null;
    category = null;
    status = null;
    await _load();
  }

  Future<void> setSearch(String value) async {
    search = value;
    await _load();
  }

  Future<void> setFacilityFilter(String? value) async {
    facilityId = value;
    areaId = null;
    await _load();
  }

  Future<void> setAreaFilter(String? value) async {
    areaId = value;
    await _load();
  }

  Future<void> setCategoryFilter(String? value) async {
    category = value;
    await _load();
  }

  Future<void> setStatusFilter(String? value) async {
    status = value;
    await _load();
  }

  Future<void> setSort(String value) async {
    sort = value;
    await _load();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    if (items.isEmpty) {
      listStatus = LoadStatus.loading;
      _notify();
    }
    try {
      final page = await _api.getAssets(
        search: search.trim().isEmpty ? null : search.trim(),
        facilityId: facilityId,
        areaId: areaId,
        category: category,
        currentStatus: status,
        sort: sort,
        limit: assetsPageSize,
      );
      if (requestId != _requestId) return;
      items = page.items.toList();
      _nextCursor = page.nextCursor;
      if (items.isNotEmpty) {
        _staticCachedItems = items;
        _staticCachedNextCursor = _nextCursor;
      } else {
        _staticCachedItems = null;
        _staticCachedNextCursor = null;
      }
      listStatus = LoadStatus.ready;
    } catch (e, st) {
      // ignore: avoid_print
      print('[AssetsController._load] ERROR: $e\n$st');
      if (requestId != _requestId) return;
      if (items.isEmpty) {
        listStatus = LoadStatus.error;
      }
    }
    _notify();
  }

  Future<void> loadMore() async {
    final cursor = _nextCursor;
    if (cursor == null || loadingMore) return;
    loadingMore = true;
    _notify();
    try {
      final page = await _api.getAssets(
        search: search.trim().isEmpty ? null : search.trim(),
        facilityId: facilityId,
        areaId: areaId,
        category: category,
        currentStatus: status,
        sort: sort,
        cursor: cursor,
        limit: assetsPageSize,
      );
      items = [...items, ...page.items];
      _nextCursor = page.nextCursor;
      _staticCachedItems = items;
      _staticCachedNextCursor = _nextCursor;
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
    _notify();
  }

  Future<void> _loadFacilities() async {
    if (facilities.isEmpty) {
      facilitiesStatus = LoadStatus.loading;
      _notify();
    }
    try {
      final page = await _api.getFacilities(limit: _lookupLimit, sort: 'name');
      facilities = page.items.toList();
      _staticCachedFacilities = facilities;
      facilitiesStatus = LoadStatus.ready;
    } catch (_) {
      if (facilities.isEmpty) facilitiesStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<void> _loadAreas() async {
    if (areas.isEmpty) {
      areasStatus = LoadStatus.loading;
      _notify();
    }
    try {
      final page = await _api.getAreas(limit: _lookupLimit, sort: 'name');
      areas = page.items.toList();
      _staticCachedAreas = areas;
      areasStatus = LoadStatus.ready;
    } catch (_) {
      if (areas.isEmpty) areasStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<AssetDetail> getAsset(String assetId) => _api.getAsset(assetId);

  Future<AssetHistoryPage> getAssetHistory(String assetId) =>
      _api.getAssetHistory(assetId);

  Future<InspectionListPage> getInspections(String assetId) =>
      _api.getInspections(assetId: assetId);

  Future<WorkOrderListPage> getWorkOrders(String assetId) =>
      _api.getWorkOrders(assetId: assetId);

  Future<List<AssetListItem>> getChildAssets(String parentAssetId) async {
    final page =
        await _api.getAssets(parentAssetId: parentAssetId, limit: _lookupLimit);
    return page.items.toList();
  }

  String facilityName(String facilityId) {
    final match = facilities.where((facility) => facility.id == facilityId);
    return match.isEmpty ? facilityId : match.first.name;
  }

  String? areaName(String? areaId) {
    if (areaId == null) return null;
    final match = areas.where((area) => area.id == areaId);
    return match.isEmpty ? areaId : match.first.name;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
