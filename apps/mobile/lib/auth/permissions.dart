import 'package:flutter/material.dart';

import '../api/api_service.dart';

enum PermissionStatus { loading, ready, unauthenticated, error }

class PermissionAccess {
  PermissionAccess(Iterable<String> permissions)
    : permissions = Set<String>.unmodifiable(permissions);

  final Set<String> permissions;

  bool can(String key) => permissions.contains(key);
  bool hasAny(Iterable<String> keys) => keys.any(can);
  bool hasAll(Iterable<String> keys) => keys.every(can);
}

class PermissionController extends ChangeNotifier {
  PermissionController({ApiContract? api, Iterable<String>? initialPermissions})
    : _api = api,
      _access = PermissionAccess(initialPermissions ?? const <String>[]),
      _status = initialPermissions == null
          ? PermissionStatus.loading
          : PermissionStatus.ready;

  final ApiContract? _api;
  PermissionAccess _access;
  PermissionStatus _status;
  bool _disposed = false;

  Set<String> get permissions => _access.permissions;
  PermissionStatus get status => _status;
  bool can(String key) => _access.can(key);
  bool hasAny(Iterable<String> keys) => _access.hasAny(keys);
  bool hasAll(Iterable<String> keys) => _access.hasAll(keys);

  Future<void> loadFromMe() async {
    final api = _api;
    if (api == null) {
      _set(const <String>[], PermissionStatus.error);
      return;
    }
    try {
      final currentUser = await api.getCurrentUser();
      _set(currentUser.permissions, PermissionStatus.ready);
    } on ApiException catch (error) {
      _set(
        const <String>[],
        error.statusCode == 401
            ? PermissionStatus.unauthenticated
            : PermissionStatus.error,
      );
    } catch (_) {
      _set(const <String>[], PermissionStatus.error);
    }
  }

  void _set(Iterable<String> permissions, PermissionStatus status) {
    if (_disposed) return;
    _access = PermissionAccess(permissions);
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class PermissionProvider extends InheritedNotifier<PermissionController> {
  const PermissionProvider({
    required PermissionController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static PermissionController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<PermissionProvider>();
    assert(provider != null, 'PermissionProvider is required');
    return provider!.notifier!;
  }
}

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    required this.permission,
    required this.child,
    required this.fallback,
    super.key,
  });

  final String permission;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return PermissionProvider.of(context).can(permission) ? child : fallback;
  }
}
