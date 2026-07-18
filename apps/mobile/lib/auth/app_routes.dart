import 'package:flutter/material.dart';

import '../design_system/motion.dart';
import 'auth_experience.dart';
import 'permissions.dart';
import 'route_guards.dart';

/// Named routes and their guard composition. Client guards are UX only: the
/// FastAPI require_permission / require_verified_email dependencies remain
/// authoritative for every protected operation.
class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const rbacDemo = '/rbac-demo';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = _builderFor(settings.name ?? home);
    if (builder == null) return null;
    return IndustrialPageRoute<void>(settings: settings, builder: builder);
  }

  static WidgetBuilder? _builderFor(String name) {
    switch (name) {
      case home:
        return (_) => const RequireAuthGuard(
              routeName: home,
              child: AuthenticatedHome(),
            );
      case rbacDemo:
        return (_) => const RequireAuthGuard(
              routeName: rbacDemo,
              child: PermissionGate(
                permission: 'assets.write',
                fallback: NoAccessScreen(permission: 'assets.write'),
                child: RbacDemoScreen(),
              ),
            );
      case login:
        return (_) => const PublicOnlyGuard(child: LoginScreen());
      case signup:
        return (_) => const PublicOnlyGuard(child: SignupScreen());
      case forgotPassword:
        return (_) => const PublicOnlyGuard(child: ForgotPasswordScreen());
      case verifyEmail:
        return (_) => const VerifyEmailGuard(child: VerifyEmailScreen());
    }
    return null;
  }
}
