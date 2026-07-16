import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api/api_service.dart';
import 'auth/permissions.dart';
import 'design_system/motion.dart';
import 'design_system/primitives.dart';
import 'design_system/showcase.dart';
import 'design_system/theme.dart';

void main() {
  runApp(const FevApp());
}

class FevApp extends StatefulWidget {
  const FevApp({
    this.api,
    this.getIdToken,
    this.initialRoute,
    this.onUnauthorized,
    super.key,
  });

  final ApiContract? api;
  final TokenProvider? getIdToken;
  final String? initialRoute;
  final UnauthorizedHook? onUnauthorized;

  @override
  State<FevApp> createState() => _FevAppState();
}

class _FevAppState extends State<FevApp> {
  late final AppThemeController _theme;
  late final ApiContract _api;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _theme = AppThemeController()..load();
    _api = widget.api ??
        ApiService(
          getIdToken: widget.getIdToken,
          onUnauthorized: widget.onUnauthorized,
          feedback: CallbackApiFeedback(
            (message) => _messengerKey.currentState?.showSnackBar(
              buildAppToast(message, status: AppStatus.critical),
            ),
          ),
        );
  }

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _theme,
      child: AnimatedBuilder(
        animation: _theme,
        builder: (context, _) => MaterialApp(
          title: 'FEV Field App',
          scaffoldMessengerKey: _messengerKey,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: _theme.mode,
          initialRoute: widget.initialRoute,
          onGenerateRoute: (settings) {
            if (kDebugMode && settings.name == DesignSystemShowcase.routeName) {
              return IndustrialPageRoute<void>(
                settings: settings,
                builder: (_) => const DesignSystemShowcase(),
              );
            }
            return null;
          },
          home: PermissionBootstrap(
            api: _api,
            child: HomePage(api: _api),
          ),
        ),
      ),
    );
  }
}

class PermissionBootstrap extends StatefulWidget {
  const PermissionBootstrap({
    required this.api,
    required this.child,
    super.key,
  });

  final ApiContract api;
  final Widget child;

  @override
  State<PermissionBootstrap> createState() => _PermissionBootstrapState();
}

class _PermissionBootstrapState extends State<PermissionBootstrap> {
  late final PermissionController _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = PermissionController(api: widget.api);
    _permissions.loadFromMe();
  }

  @override
  void dispose() {
    _permissions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PermissionProvider(controller: _permissions, child: widget.child);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.api, super.key});

  final ApiContract api;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _apiStatus = 'checking';
  String _firestoreStatus = 'checking';

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    try {
      final health = await widget.api.getHealth();

      if (mounted) {
        setState(() {
          _apiStatus = 'connected';
          _firestoreStatus = health.firestore.name;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _apiStatus = 'unavailable';
          _firestoreStatus = 'unavailable';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEV Field App')),
      body: Center(
        child: AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'API: $_apiStatus · Firestore: $_firestoreStatus',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const PermissionGate(
                permission: 'assets.write',
                fallback: Text(
                  'No access: assets.write required',
                  style: TextStyle(color: Colors.orange),
                ),
                child: Text(
                  'Asset write action available',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
