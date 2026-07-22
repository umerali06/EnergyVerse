import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

/// Read-only company role catalog (list + detail, incl. its permission set).
/// Editing is admin-web-only for this phase — see lib/roles/roles_screen.dart.
class RolesController extends ChangeNotifier {
  RolesController({required ApiContract api}) : _api = api;

  final ApiContract _api;
  bool _disposed = false;

  LoadStatus listStatus = LoadStatus.loading;
  List<RoleSummary> items = const [];

  Future<void> start() => _load();
  Future<void> retry() => _load();

  Future<void> _load() async {
    listStatus = LoadStatus.loading;
    _notify();
    try {
      final page = await _api.getRoles();
      items = page.items.toList();
      listStatus = LoadStatus.ready;
    } catch (_) {
      listStatus = LoadStatus.error;
    }
    _notify();
  }

  Future<RoleDetail> getRole(String roleId) => _api.getRole(roleId);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
