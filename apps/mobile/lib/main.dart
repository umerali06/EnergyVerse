import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import 'api/api_service.dart';
import 'auth/app_routes.dart';
import 'auth/auth_controller.dart';
import 'auth/firebase_gateway.dart';
import 'db/app_database.dart';
import 'design_system/motion.dart';
import 'design_system/primitives.dart';
import 'design_system/showcase.dart';
import 'design_system/theme.dart';
import 'firebase_options.dart';
import 'inspections/local_inspections_repository.dart';
import 'media/local_media_repository.dart';
import 'media/media_upload_worker.dart';
import 'sync/sync_engine.dart';
import 'work_orders/local_work_orders_repository.dart';
import 'work_orders/work_order_sync_engine.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await Firebase.initializeApp(options: firebaseClientOptions);
  runApp(const FevApp());
}

class FevApp extends StatefulWidget {
  const FevApp({this.api, this.authGateway, this.initialRoute, this.database, super.key});

  final ApiContract? api;
  final AuthGateway? authGateway;
  final String? initialRoute;

  /// Testing seam: widget tests inject an in-memory [AppDatabase] so they
  /// never touch real on-disk state.
  final AppDatabase? database;

  @override
  State<FevApp> createState() => _FevAppState();
}

class _FevAppState extends State<FevApp> with WidgetsBindingObserver {
  late final AppThemeController _theme;
  late final AuthGateway _gateway;
  late final ApiContract _api;
  late final AuthController _auth;
  late final AppDatabase _db;
  late final LocalInspectionsRepository _repository;
  late final SyncEngine _sync;
  late final LocalMediaRepository _mediaRepository;
  late final MediaUploadWorker _mediaWorker;
  late final LocalWorkOrdersRepository _workOrdersRepository;
  late final WorkOrderSyncEngine _workOrderSync;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _theme = AppThemeController()..load();
    _gateway = widget.authGateway ?? FirebaseAuthGateway();
    _api = widget.api ??
        ApiService(
          getIdToken: _gateway.getIdToken,
          refreshIdToken: () => _gateway.getIdToken(forceRefresh: true),
          // Evaluated lazily at call time, after _auth is initialized below.
          onUnauthorized: () => _auth.expireSession(),
        );
    _db = widget.database ?? AppDatabase();
    _repository = LocalInspectionsRepository(db: _db, api: _api);
    _mediaRepository = LocalMediaRepository(db: _db);
    _sync = SyncEngine(repository: _repository, api: _api, mediaRepository: _mediaRepository);
    _mediaWorker = MediaUploadWorker(
      mediaRepository: _mediaRepository,
      inspectionsRepository: _repository,
    );
    _workOrdersRepository = LocalWorkOrdersRepository(db: _db, api: _api);
    _workOrderSync =
        WorkOrderSyncEngine(repository: _workOrdersRepository, api: _api);
    _auth = AuthController(
      gateway: _gateway,
      api: _api,
      feedback: (message) => _messengerKey.currentState?.showSnackBar(
        buildAppToast(message, status: AppStatus.critical),
      ),
    )..start();
    _auth.addListener(_handleAuthChange);
  }

  void _handleAuthChange() {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      unawaited(_repository.reconcileSessionOwner(uid));
      unawaited(_workOrdersRepository.reconcileSessionOwner(uid));
      // Best-effort, so a field inspector who was online earlier today still
      // has checklist templates cached for fully-offline auto-selection
      // (Phase 7.3) even if they open the app in airplane mode next.
      unawaited(_repository.refreshChecklistTemplatesFromNetwork());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync.kick();
      _mediaWorker.kick();
      _workOrderSync.kick();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _auth.removeListener(_handleAuthChange);
    _sync.dispose();
    _mediaWorker.dispose();
    _workOrderSync.dispose();
    _auth.dispose();
    _theme.dispose();
    unawaited(_db.close());
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
          initialRoute: widget.initialRoute ?? AppRoutes.home,
          // Deep links resolve to exactly one guarded route; the default
          // behavior would also push every parent path segment.
          onGenerateInitialRoutes: (initial) => [
            AppRoutes.onGenerateRoute(RouteSettings(name: initial)) ??
                AppRoutes.onGenerateRoute(
                  const RouteSettings(name: AppRoutes.home),
                )!,
          ],
          // AuthProvider sits above the Navigator so every route's guards can
          // observe auth state; SyncProvider sits alongside it so any route
          // can read/watch the offline cache and trigger a sync.
          builder: (context, child) => AuthProvider(
            controller: _auth,
            child: SyncProvider(
              engine: _sync,
              repository: _repository,
              child: MediaProvider(
                worker: _mediaWorker,
                repository: _mediaRepository,
                child: WorkOrderSyncProvider(
                  engine: _workOrderSync,
                  repository: _workOrdersRepository,
                  child: child!,
                ),
              ),
            ),
          ),
          onGenerateRoute: (settings) {
            if (kDebugMode && settings.name == DesignSystemShowcase.routeName) {
              return IndustrialPageRoute<void>(
                settings: settings,
                builder: (_) => const DesignSystemShowcase(),
              );
            }
            return AppRoutes.onGenerateRoute(settings);
          },
        ),
      ),
    );
  }
}
