import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth/permissions.dart';
import 'config.dart';
import 'design_system/motion.dart';
import 'design_system/primitives.dart';
import 'design_system/showcase.dart';
import 'design_system/theme.dart';

void main() {
  runApp(const FevApp());
}

class FevApp extends StatefulWidget {
  const FevApp({this.initialRoute, super.key});

  final String? initialRoute;

  @override
  State<FevApp> createState() => _FevAppState();
}

class _FevAppState extends State<FevApp> {
  late final AppThemeController _theme;

  @override
  void initState() {
    super.initState();
    _theme = AppThemeController()..load();
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
          home: const PermissionBootstrap(child: HomePage()),
        ),
      ),
    );
  }
}

class PermissionBootstrap extends StatefulWidget {
  const PermissionBootstrap({required this.child, this.idToken, super.key});

  final Widget child;
  final String? idToken;

  @override
  State<PermissionBootstrap> createState() => _PermissionBootstrapState();
}

class _PermissionBootstrapState extends State<PermissionBootstrap> {
  late final PermissionController _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = PermissionController();
    _permissions.loadFromMe(idToken: widget.idToken);
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
  const HomePage({super.key});

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
      final baseUrl = apiBaseUrl.endsWith('/')
          ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
          : apiBaseUrl;
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw StateError('Health request returned HTTP ${response.statusCode}');
      }

      final health = jsonDecode(response.body) as Map<String, dynamic>;
      final firestore = health['firestore'];
      if (firestore != 'connected' &&
          firestore != 'unavailable' &&
          firestore != 'unconfigured') {
        throw const FormatException('Invalid Firestore health status');
      }

      if (mounted) {
        setState(() {
          _apiStatus = 'connected';
          _firestoreStatus = firestore as String;
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
