import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../assets/asset_detail_screen.dart';
import '../assets/asset_form_screen.dart';
import '../assets/assets_screen.dart';
import '../audit/audit_screen.dart';
import '../company/company_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../design_system/motion.dart';
import '../inspections/inspection_detail_screen.dart';
import '../inspections/inspections_screen.dart';
import '../inspections/sync_queue_screen.dart';
import '../navigation/nav_config.dart';
import '../qr/qr_scan_result_screen.dart';
import '../qr/qr_scan_screen.dart';
import '../roles/roles_screen.dart';
import '../shell/app_shell.dart';
import '../users/users_screen.dart';
import 'auth_experience.dart';
import 'permissions.dart';
import 'route_guards.dart';

/// Named routes and their guard composition. Every protected route renders
/// inside AppShellScaffold (Phase 2.1); the nav contract lives in
/// lib/navigation/nav_config.dart and mirrors the admin app. Client guards
/// are UX only: the FastAPI require_permission / require_verified_email
/// dependencies remain authoritative for every protected operation.
class AppRoutes {
  static const home = AppNav.home;
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const rbacDemo = '/rbac-demo';
  static const users = AppNav.users;
  static const roles = AppNav.roles;
  static const settings = AppNav.settings;
  static const audit = AppNav.audit;
  static const assets = AppNav.assets;
  static const assetDetail = '/assets/detail';
  static const assetForm = '/assets/form';
  static const inspections = AppNav.inspections;
  static const inspectionDetail = '/inspections/detail';
  static const inspectionSyncQueue = '/inspections/sync-queue';
  static const qrScan = '/qr-scan';
  static const qrScanResult = '/qr-scan/result';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? home;
    return IndustrialPageRoute<void>(
      settings: settings,
      builder: _builderFor(name),
    );
  }

  static WidgetBuilder _builderFor(String name) {
    switch (name) {
      case login:
        return (_) => const PublicOnlyGuard(child: LoginScreen());
      case signup:
        return (_) => const PublicOnlyGuard(child: SignupScreen());
      case forgotPassword:
        return (_) => const PublicOnlyGuard(child: ForgotPasswordScreen());
      case verifyEmail:
        return (_) => const VerifyEmailGuard(child: VerifyEmailScreen());
      case home:
        return (_) => const RequireAuthGuard(
              routeName: home,
              child: AppShellScaffold(
                currentRoute: home,
                child: DashboardScreen(),
              ),
            );
      case rbacDemo:
        return (_) => const RequireAuthGuard(
              routeName: rbacDemo,
              child: AppShellScaffold(
                currentRoute: rbacDemo,
                child: PermissionGate(
                  permission: 'assets.write',
                  fallback: NoAccessScreen(permission: 'assets.write'),
                  child: RbacDemoScreen(),
                ),
              ),
            );
      case users:
        return (_) => const RequireAuthGuard(
              routeName: users,
              child: AppShellScaffold(
                currentRoute: users,
                child: PermissionGate(
                  permission: 'users.manage',
                  fallback: NoAccessScreen(permission: 'users.manage'),
                  child: UsersScreen(),
                ),
              ),
            );
      case roles:
        return (_) => const RequireAuthGuard(
              routeName: roles,
              child: AppShellScaffold(
                currentRoute: roles,
                child: PermissionGate(
                  permission: 'roles.manage',
                  fallback: NoAccessScreen(permission: 'roles.manage'),
                  child: RolesScreen(),
                ),
              ),
            );
      case settings:
        return (_) => const RequireAuthGuard(
              routeName: settings,
              child: AppShellScaffold(
                currentRoute: settings,
                child: PermissionGate(
                  permission: 'company.settings',
                  fallback: NoAccessScreen(permission: 'company.settings'),
                  child: CompanyProfileScreen(),
                ),
              ),
            );
      case audit:
        return (_) => const RequireAuthGuard(
              routeName: audit,
              child: AppShellScaffold(
                currentRoute: audit,
                child: PermissionGate(
                  permission: 'audit.read',
                  fallback: NoAccessScreen(permission: 'audit.read'),
                  child: AuditScreen(),
                ),
              ),
            );
      case assets:
        return (context) {
          final initialStatus = ModalRoute.of(context)!.settings.arguments as String?;
          return RequireAuthGuard(
            routeName: assets,
            child: AppShellScaffold(
              currentRoute: assets,
              child: PermissionGate(
                permission: 'assets.read',
                fallback: const NoAccessScreen(permission: 'assets.read'),
                child: AssetsScreen(initialStatus: initialStatus),
              ),
            ),
          );
        };
      case assetDetail:
        return (context) {
          final assetId = ModalRoute.of(context)!.settings.arguments as String;
          return RequireAuthGuard(
            routeName: assetDetail,
            child: AppShellScaffold(
              currentRoute: assets,
              child: PermissionGate(
                permission: 'assets.read',
                fallback: const NoAccessScreen(permission: 'assets.read'),
                child: AssetDetailScreen(assetId: assetId),
              ),
            ),
          );
        };
      case assetForm:
        return (context) {
          final assetId = ModalRoute.of(context)!.settings.arguments as String?;
          return RequireAuthGuard(
            routeName: assetForm,
            child: AppShellScaffold(
              currentRoute: assets,
              child: PermissionGate(
                permission: 'assets.write',
                fallback: const NoAccessScreen(permission: 'assets.write'),
                child: AssetFormScreen(assetId: assetId),
              ),
            ),
          );
        };
      case inspections:
        return (_) => const RequireAuthGuard(
              routeName: inspections,
              child: AppShellScaffold(
                currentRoute: inspections,
                child: PermissionGate(
                  permission: 'inspections.read',
                  fallback: NoAccessScreen(permission: 'inspections.read'),
                  child: InspectionsScreen(),
                ),
              ),
            );
      case inspectionDetail:
        return (context) {
          final inspectionId = ModalRoute.of(context)!.settings.arguments as String;
          return RequireAuthGuard(
            routeName: inspectionDetail,
            child: AppShellScaffold(
              currentRoute: inspections,
              child: PermissionGate(
                permission: 'inspections.read',
                fallback: const NoAccessScreen(permission: 'inspections.read'),
                child: InspectionDetailScreen(inspectionId: inspectionId),
              ),
            ),
          );
        };
      case inspectionSyncQueue:
        return (_) => const RequireAuthGuard(
              routeName: inspectionSyncQueue,
              child: AppShellScaffold(
                currentRoute: inspections,
                child: PermissionGate(
                  permission: 'inspections.read',
                  fallback: NoAccessScreen(permission: 'inspections.read'),
                  child: SyncQueueScreen(),
                ),
              ),
            );
      case qrScan:
        return (_) => const RequireAuthGuard(
              routeName: qrScan,
              child: AppShellScaffold(
                currentRoute: assets,
                child: PermissionGate(
                  permission: 'assets.read',
                  fallback: NoAccessScreen(permission: 'assets.read'),
                  child: QrScanScreen(),
                ),
              ),
            );
      case qrScanResult:
        return (context) {
          final result = ModalRoute.of(context)!.settings.arguments as QrScanResult;
          return RequireAuthGuard(
            routeName: qrScanResult,
            child: AppShellScaffold(
              currentRoute: assets,
              child: PermissionGate(
                permission: 'assets.read',
                fallback: const NoAccessScreen(permission: 'assets.read'),
                child: QrScanResultScreen(result: result),
              ),
            ),
          );
        };
    }
    final destination = AppNav.byRoute(name);
    if (destination != null && destination.comingSoon) {
      return (_) => RequireAuthGuard(
            routeName: name,
            child: AppShellScaffold(
              currentRoute: name,
              child: ComingSoonScreen(moduleName: destination.label),
            ),
          );
    }
    // Unknown route: branded 404 inside the shell (still auth-guarded).
    return (_) => RequireAuthGuard(
          routeName: name,
          child: AppShellScaffold(
            currentRoute: name,
            child: const NotFoundScreen(),
          ),
        );
  }
}
