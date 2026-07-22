import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

const auditPageSize = 20;
const auditDefaultWindowDays = 90;

/// Read-only company audit trail (list + filters + detail). Export is
/// admin-web-only for this phase (D-0xx: a downloadable compliance export
/// is a desktop workflow) -- see lib/audit/audit_screen.dart.
class AuditController extends ChangeNotifier {
  AuditController({required ApiContract api}) : _api = api {
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: auditDefaultWindowDays));
    toDate = DateTime(now.year, now.month, now.day);
  }

  final ApiContract _api;
  bool _disposed = false;
  int _requestId = 0;
  int _facetsRequestId = 0;

  LoadStatus listStatus = LoadStatus.loading;
  List<AuditLogEntry> items = const [];
  bool truncated = false;
  String? _nextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;

  LoadStatus facetsStatus = LoadStatus.loading;
  List<String> actions = const [];
  List<String> targetTypes = const [];

  late DateTime fromDate;
  late DateTime toDate;
  String? actorUid;
  String? action;
  String? targetType;
  String q = '';

  Future<void> start() {
    unawaited(_loadFacets());
    return _load();
  }

  Future<void> retry() => _load();

  Future<void> setDateRange(DateTime from, DateTime to) async {
    fromDate = from;
    toDate = to;
    await Future.wait([_loadFacets(), _load()]);
  }

  Future<void> setActionFilter(String? value) async {
    action = value;
    await _load();
  }

  Future<void> setTargetTypeFilter(String? value) async {
    targetType = value;
    await _load();
  }

  Future<void> setSearch(String value) async {
    q = value;
    await _load();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    listStatus = LoadStatus.loading;
    items = const [];
    _nextCursor = null;
    truncated = false;
    _notify();
    try {
      final page = await _api.getAuditLogs(
        fromDate: fromDate,
        toDate: toDate,
        actorUid: actorUid,
        action: action,
        targetType: targetType,
        q: q.trim().isEmpty ? null : q.trim(),
        limit: auditPageSize,
      );
      if (requestId != _requestId) return;
      items = page.items.toList();
      _nextCursor = page.nextCursor;
      truncated = page.truncated;
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
      final page = await _api.getAuditLogs(
        fromDate: fromDate,
        toDate: toDate,
        actorUid: actorUid,
        action: action,
        targetType: targetType,
        q: q.trim().isEmpty ? null : q.trim(),
        cursor: cursor,
        limit: auditPageSize,
      );
      items = [...items, ...page.items];
      _nextCursor = page.nextCursor;
      truncated = truncated || page.truncated;
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
    _notify();
  }

  Future<void> _loadFacets() async {
    final requestId = ++_facetsRequestId;
    facetsStatus = LoadStatus.loading;
    _notify();
    try {
      final facets = await _api.getAuditLogFacets(fromDate: fromDate, toDate: toDate);
      if (requestId != _facetsRequestId) return;
      actions = facets.actions.toList();
      targetTypes = facets.targetTypes.toList();
      facetsStatus = LoadStatus.ready;
    } catch (_) {
      if (requestId != _facetsRequestId) return;
      facetsStatus = LoadStatus.error;
    }
    _notify();
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
