import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

const inspectionsPageSize = 25;

/// Read-only inspection directory (list + detail). Mirrors [AssetsController]'s
/// shape; `initialAssetId`/`initialStatus` seed the filters once at
/// construction (e.g. the asset-detail Inspections tab scoping the list to
/// one asset) -- they are not kept in sync with the route afterward.
class InspectionsController extends ChangeNotifier {
  InspectionsController({
    required ApiContract api,
    String? initialAssetId,
    String? initialStatus,
  }) : _api = api,
       assetId = initialAssetId,
       status = initialStatus;

  final ApiContract _api;
  bool _disposed = false;
  int _requestId = 0;

  LoadStatus listStatus = LoadStatus.loading;
  List<InspectionListItem> items = const [];
  String? _nextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;

  String? assetId;
  String? status;

  Future<void> start() => _load();

  Future<void> retry() => _load();

  Future<void> setStatusFilter(String? value) async {
    status = value;
    await _load();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    listStatus = LoadStatus.loading;
    items = const [];
    _nextCursor = null;
    _notify();
    try {
      final page = await _api.getInspections(
        assetId: assetId,
        status: status,
        limit: inspectionsPageSize,
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
      final page = await _api.getInspections(
        assetId: assetId,
        status: status,
        cursor: cursor,
        limit: inspectionsPageSize,
      );
      items = [...items, ...page.items];
      _nextCursor = page.nextCursor;
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
    _notify();
  }

  Future<InspectionDetail> getInspection(String inspectionId) =>
      _api.getInspection(inspectionId);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
