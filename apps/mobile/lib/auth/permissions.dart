import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

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
  PermissionController({
    Iterable<String>? initialPermissions,
    http.Client? client,
  })  : _client = client,
        _access = PermissionAccess(initialPermissions ?? const <String>[]),
        _status = initialPermissions == null
            ? PermissionStatus.loading
            : PermissionStatus.ready;

  final http.Client? _client;
  PermissionAccess _access;
  PermissionStatus _status;
  bool _disposed = false;

  Set<String> get permissions => _access.permissions;
  PermissionStatus get status => _status;
  bool can(String key) => _access.can(key);
  bool hasAny(Iterable<String> keys) => _access.hasAny(keys);
  bool hasAll(Iterable<String> keys) => _access.hasAll(keys);

  Future<void> loadFromMe({String? idToken}) async {
    try {
      final baseUrl = apiBaseUrl.endsWith('/')
          ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
          : apiBaseUrl;
      final uri = Uri.parse('$baseUrl/api/v1/auth/me');
      final headers = idToken == null
          ? const <String, String>{}
          : <String, String>{'Authorization': 'Bearer $idToken'};
      final response = await (_client?.get(uri, headers: headers) ??
              http.get(uri, headers: headers))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 401) {
        _set(const <String>[], PermissionStatus.unauthenticated);
        return;
      }
      if (response.statusCode != 200) {
        throw StateError('/me returned HTTP ${response.statusCode}');
      }
      final currentUser = jsonDecode(response.body) as Map<String, dynamic>;
      final rawPermissions = currentUser['permissions'];
      if (rawPermissions is! List<dynamic> ||
          rawPermissions.any((permission) => permission is! String)) {
        throw const FormatException('/me returned invalid permissions');
      }
      _set(rawPermissions.cast<String>(), PermissionStatus.ready);
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
    final provider =
        context.dependOnInheritedWidgetOfExactType<PermissionProvider>();
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
