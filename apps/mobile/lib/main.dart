import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api/api_service.dart';
import 'auth/auth_controller.dart';
import 'auth/auth_experience.dart';
import 'auth/firebase_gateway.dart';
import 'design_system/motion.dart';
import 'design_system/primitives.dart';
import 'design_system/showcase.dart';
import 'design_system/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseClientOptions);
  runApp(const FevApp());
}

class FevApp extends StatefulWidget {
  const FevApp({
    this.api,
    this.authGateway,
    this.initialRoute,
    super.key,
  });

  final ApiContract? api;
  final AuthGateway? authGateway;
  final String? initialRoute;

  @override
  State<FevApp> createState() => _FevAppState();
}

class _FevAppState extends State<FevApp> {
  late final AppThemeController _theme;
  late final AuthGateway _gateway;
  late final ApiContract _api;
  late final AuthController _auth;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _theme = AppThemeController()..load();
    _gateway = widget.authGateway ?? FirebaseAuthGateway();
    _api = widget.api ?? ApiService(getIdToken: _gateway.getIdToken);
    _auth = AuthController(
      gateway: _gateway,
      api: _api,
      feedback: (message) => _messengerKey.currentState?.showSnackBar(
        buildAppToast(message, status: AppStatus.critical),
      ),
    )..start();
  }

  @override
  void dispose() {
    _auth.dispose();
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
          home: AuthProvider(
            controller: _auth,
            child: const AuthExperience(),
          ),
        ),
      ),
    );
  }
}
