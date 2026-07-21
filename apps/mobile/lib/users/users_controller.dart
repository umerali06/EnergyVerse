import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

const usersPageSize = 25;

/// Read-only company user directory (list + detail). Invite/edit are
/// admin-web-only for this phase (D-0xx: field users rarely administer
/// accounts from mobile) — see lib/users/users_screen.dart.
class UsersController extends ChangeNotifier {
  UsersController({required ApiContract api}) : _api = api;

  final ApiContract _api;
  bool _disposed = false;
  int _requestId = 0;

  LoadStatus listStatus = LoadStatus.loading;
  List<UserListItem> items = const [];
  String? _nextCursor;
  String? get nextCursor => _nextCursor;
  bool loadingMore = false;

  String search = '';
  String? roleId;
  String? status;
  String sort = 'name';

  Future<void> start() => _load();
  Future<void> retry() => _load();

  Future<void> setSearch(String value) async {
    search = value;
    await _load();
  }

  Future<void> setRoleFilter(String? value) async {
    roleId = value;
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
      final page = await _api.getUsers(
        search: search.trim().isEmpty ? null : search.trim(),
        roleId: roleId,
        status: status,
        sort: sort,
        limit: usersPageSize,
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
      final page = await _api.getUsers(
        search: search.trim().isEmpty ? null : search.trim(),
        roleId: roleId,
        status: status,
        sort: sort,
        cursor: cursor,
        limit: usersPageSize,
      );
      items = [...items, ...page.items];
      _nextCursor = page.nextCursor;
    } catch (_) {
      // Keep the existing page; the user can tap "Load more" again.
    }
    loadingMore = false;
    _notify();
  }

  Future<UserDetail> getUser(String userId) => _api.getUser(userId);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
