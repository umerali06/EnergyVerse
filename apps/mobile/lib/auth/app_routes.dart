import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../design_system/motion.dart';
import '../navigation/nav_config.dart';
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
