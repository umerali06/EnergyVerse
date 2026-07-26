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
  AssetsController({required ApiContract api}) : _api = api;

  final ApiContract _api;
  bool _disposed = false;
  int _requestId = 0;

  LoadStatus listStatus = LoadStatus.loading;
  List<AssetListItem> items = const [];
  String? _nextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;

  LoadStatus facilitiesStatus = LoadStatus.loading;
  List<FacilityDetail> facilities = const [];
  LoadStatus areasStatus = LoadStatus.loading;
  List<AreaDetail> areas = const [];

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
    listStatus = LoadStatus.loading;
    items = const [];
    _nextCursor = null;
    _notify();
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
      listStatus = LoadStatus.ready;
    } catch (_) {
      if (requestId != _requestId) return;
      listStatus = LoadStatus.error;
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
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
    _notify();
  }

  Future<void> _loadFacilities() async {
    facilitiesStatus = LoadStatus.loading;
    _notify();
    try {
      final page = await _api.getFacilities(limit: _lookupLimit, sort: 'name');
      facilities = page.items.toList();
      facilitiesStatus = LoadStatus.ready;
    } catch (_) {
      facilitiesStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<void> _loadAreas() async {
    areasStatus = LoadStatus.loading;
    _notify();
    try {
      final page = await _api.getAreas(limit: _lookupLimit, sort: 'name');
      areas = page.items.toList();
      areasStatus = LoadStatus.ready;
    } catch (_) {
      areasStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<AssetDetail> getAsset(String assetId) => _api.getAsset(assetId);

  Future<AssetHistoryPage> getAssetHistory(String assetId) => _api.getAssetHistory(assetId);

  Future<List<AssetListItem>> getChildAssets(String parentAssetId) async {
    final page = await _api.getAssets(parentAssetId: parentAssetId, limit: _lookupLimit);
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
