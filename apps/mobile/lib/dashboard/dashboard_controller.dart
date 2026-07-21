import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';

enum LoadStatus { loading, error, ready }

const activityWindows = <int>[7, 30, 90];
const activityPageSize = 20;

/// Fetches the three real dashboard endpoints (summary, activity-series,
/// paginated activity) through the app's single ApiContract instance — so
/// token injection, 401 retry, and the unified error-envelope feedback all
/// come for free (see AuthController.api). Never invents a number: every
/// field here is either null (not loaded / errored) or a value that came
/// back from the API.
class DashboardController extends ChangeNotifier {
  DashboardController({required ApiContract api}) : _api = api;

  final ApiContract _api;
  bool _disposed = false;

  int _window = 30;
  int get window => _window;

  LoadStatus summaryStatus = LoadStatus.loading;
  DashboardSummary? summary;

  LoadStatus seriesStatus = LoadStatus.loading;
  List<DashboardSeriesPoint> series = const [];

  LoadStatus activityStatus = LoadStatus.loading;
  List<DashboardActivityItem> activityItems = const [];
  String? _nextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;
  String? actionFilter;

  int _summaryRequestId = 0;
  int _seriesRequestId = 0;
  int _activityRequestId = 0;

  Future<void> start() async {
    await Future.wait([_loadSummary(), _loadSeries(), _loadActivity()]);
  }

  Future<void> setWindow(int value) async {
    if (value == _window) return;
    _window = value;
    await Future.wait([_loadSummary(), _loadSeries()]);
  }

  Future<void> setActionFilter(String? action) async {
    actionFilter = action;
    await _loadActivity();
  }

  Future<void> retrySummary() => _loadSummary();
  Future<void> retrySeries() => _loadSeries();
  Future<void> retryActivity() => _loadActivity();

  Future<void> _loadSummary() async {
    final requestId = ++_summaryRequestId;
    summaryStatus = LoadStatus.loading;
    _notify();
    try {
      final result = await _api.getDashboardSummary(window: _window);
      if (requestId != _summaryRequestId) return;
      summary = result;
      summaryStatus = LoadStatus.ready;
    } catch (_) {
      if (requestId != _summaryRequestId) return;
      summaryStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<void> _loadSeries() async {
    final requestId = ++_seriesRequestId;
    seriesStatus = LoadStatus.loading;
    _notify();
    try {
      final result = await _api.getDashboardActivitySeries(window: _window);
      if (requestId != _seriesRequestId) return;
      series = result.points.toList();
      seriesStatus = LoadStatus.ready;
    } catch (_) {
      if (requestId != _seriesRequestId) return;
      seriesStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<void> _loadActivity() async {
    final requestId = ++_activityRequestId;
    activityStatus = LoadStatus.loading;
    activityItems = const [];
    _nextCursor = null;
    _notify();
    try {
      final page = await _api.getDashboardActivity(
        limit: activityPageSize,
        action: actionFilter,
      );
      if (requestId != _activityRequestId) return;
      activityItems = page.items.toList();
      _nextCursor = page.nextCursor;
      activityStatus = LoadStatus.ready;
    } catch (_) {
      if (requestId != _activityRequestId) return;
      activityStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<void> loadMoreActivity() async {
    final cursor = _nextCursor;
    if (cursor == null || loadingMore) return;
    loadingMore = true;
    _notify();
    try {
      final page = await _api.getDashboardActivity(
        limit: activityPageSize,
        cursor: cursor,
        action: actionFilter,
      );
      activityItems = [...activityItems, ...page.items];
      _nextCursor = page.nextCursor;
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
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
