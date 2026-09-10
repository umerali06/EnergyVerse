import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

class ReportsController extends ChangeNotifier {
  static List<GeneratedReportListItem>? _staticCachedItems;
  static String? _staticCachedNextCursor;

  ReportsController({required GeneratedReportsApiContract api}) : _api = api {
    if (_staticCachedItems != null) {
      _items.addAll(_staticCachedItems!);
      nextCursor = _staticCachedNextCursor;
      status = LoadStatus.ready;
    }
  }

  final GeneratedReportsApiContract _api;
  final List<GeneratedReportListItem> _items = [];
  late LoadStatus status =
      _staticCachedItems != null ? LoadStatus.ready : LoadStatus.loading;
  String? reportType;
  String? reportStatus;
  String? nextCursor = _staticCachedNextCursor;
  bool loadingMore = false;
  String? exportingKey;

  List<GeneratedReportListItem> get items => List.unmodifiable(_items);

  Future<void> start() => _load(reset: true);

  Future<void> setReportType(String? value) async {
    if (reportType == value) return;
    reportType = value;
    await _load(reset: true);
  }

  Future<void> setStatus(String? value) async {
    if (reportStatus == value) return;
    reportStatus = value;
    await _load(reset: true);
  }

  Future<void> retry() => _load(reset: true);

  Future<void> loadMore() async {
    if (nextCursor == null || loadingMore) return;
    loadingMore = true;
    notifyListeners();
    await _load(reset: false);
  }

  Future<GeneratedReportExportResponse?> export(
      GeneratedReportListItem report, String format) async {
    final key = '${report.id}:$format';
    if (exportingKey != null) return null;
    exportingKey = key;
    notifyListeners();
    try {
      return await _api.exportGeneratedReport(report.id, format);
    } finally {
      exportingKey = null;
      notifyListeners();
    }
  }

  Future<GeneratedReportDetail> createReport(
      CreateGeneratedReportRequest request) async {
    final created = await _api.generateReport(request);
    await _load(reset: true);
    return created;
  }

  Future<GeneratedReportDetail> getReport(String reportId) =>
      _api.getGeneratedReport(reportId);

  Future<GeneratedReportDetail> updateReport(
      String reportId, UpdateGeneratedReportRequest request) async {
    final updated = await _api.updateGeneratedReport(reportId, request);
    await _load(reset: true);
    return updated;
  }

  Future<GeneratedReportDetail> regenerateReport(
      String reportId, RegenerateGeneratedReportRequest request) async {
    final updated = await _api.regenerateGeneratedReport(reportId, request);
    await _load(reset: true);
    return updated;
  }

  Future<GeneratedReportDetail> finalizeReport(
      String reportId, FinalizeGeneratedReportRequest request) async {
    final finalized = await _api.finalizeGeneratedReport(reportId, request);
    await _load(reset: true);
    return finalized;
  }

  Future<void> deleteReport(String reportId) async {
    await _api.deleteGeneratedReport(reportId);
    await _load(reset: true);
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      if (_items.isEmpty) {
        status = LoadStatus.loading;
        notifyListeners();
      }
    }
    try {
      final page = await _api.getGeneratedReports(
        reportType: reportType,
        status: reportStatus,
        cursor: reset ? null : nextCursor,
      );
      if (reset) {
        _items.clear();
      }
      _items.addAll(page.items);
      nextCursor = page.nextCursor;
      _staticCachedItems = List.from(_items);
      _staticCachedNextCursor = nextCursor;
      status = LoadStatus.ready;
    } catch (_) {
      if (reset && _items.isEmpty) status = LoadStatus.error;
    } finally {
      loadingMore = false;
      notifyListeners();
    }
  }
}
