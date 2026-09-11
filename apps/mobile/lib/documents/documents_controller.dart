import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;

class DocumentsController extends ChangeNotifier {
  DocumentsController({required DocumentsApiContract api}) : _api = api;

  final DocumentsApiContract _api;

  LoadStatus _status = LoadStatus.loading;
  LoadStatus get status => _status;

  List<DocumentListItem> _items = const [];
  List<DocumentListItem> get items => _items;

  String? _category;
  String? get category => _category;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _nextCursor;
  String? get nextCursor => _nextCursor;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  void start() {
    load();
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    notifyListeners();

    try {
      final page = await _api.getDocuments(
        category: _category,
        q: _searchQuery.isEmpty ? null : _searchQuery,
        limit: 25,
      );
      _items = page.items.toList();
      _nextCursor = page.nextCursor;
      _status = LoadStatus.ready;
    } catch (e) {
      debugPrint('[DocumentsController] load error: $e');
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  void setCategory(String? category) {
    if (_category == category) return;
    _category = category;
    load();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    load();
  }

  Future<void> loadMore() async {
    if (_loadingMore || _nextCursor == null) return;
    _loadingMore = true;
    notifyListeners();

    try {
      final page = await _api.getDocuments(
        category: _category,
        q: _searchQuery.isEmpty ? null : _searchQuery,
        cursor: _nextCursor,
        limit: 25,
      );
      _items = [..._items, ...page.items];
      _nextCursor = page.nextCursor;
    } catch (_) {}

    _loadingMore = false;
    notifyListeners();
  }

  Future<DocumentDetail?> createDocument(CreateDocumentRequest request) async {
    try {
      final created = await _api.createDocument(request);
      await load();
      return created;
    } catch (_) {
      rethrow;
    }
  }

  void retry() => load();
}
