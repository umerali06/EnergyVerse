import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

/// Read-only company profile (parity with the 3.1/3.2 read-only pattern) --
/// editing is admin-web-only, see lib/company/company_profile_screen.dart.
class CompanyController extends ChangeNotifier {
  CompanyController({required ApiContract api}) : _api = api;

  final ApiContract _api;
  bool _disposed = false;

  LoadStatus status = LoadStatus.loading;
  CompanyProfile? profile;

  Future<void> start() => _load();
  Future<void> retry() => _load();

  Future<void> _load() async {
    status = LoadStatus.loading;
    _notify();
    try {
      profile = await _api.getCompanyProfile();
      status = LoadStatus.ready;
    } catch (_) {
      status = LoadStatus.error;
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
