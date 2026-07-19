import 'package:flutter/material.dart';

import '../design_system/logo.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'app_routes.dart';
import 'auth_controller.dart';
import 'permissions.dart';

/// Branded loading state shown while a session is being restored or a guard
/// redirect is in flight. Prevents any flash of login or protected content.
class AuthSplashScreen extends StatelessWidget {
  const AuthSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('auth-splash'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandLogo(
              decorative: true,
              height: 40,
              variant: LogoVariant.mark,
            ),
            const SizedBox(height: DsSpacing.s6),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: DsSpacing.s4),
            Semantics(
              liveRegion: true,
              child: const Text('Restoring session'),
            ),
          ],
        ),
      ),
    );
  }
}

mixin _GuardRedirect<T extends StatefulWidget> on State<T> {
  bool _navigating = false;

  void redirect(String target) {
    if (_navigating) return;
    // Only the visible route decides where to go; covered routes stay put.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return;
    _navigating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Replace the whole stack so back-navigation cannot reveal a route the
      // current auth state no longer allows.
      Navigator.of(context).pushNamedAndRemoveUntil(target, (_) => false);
    });
  }

  void allow() => _navigating = false;
}

/// Guards protected routes: splash while restoring, login redirect that
/// remembers the intended destination, verify redirect for unverified users,
/// and a permission scope seeded from the authoritative `/me` payload.
class RequireAuthGuard extends StatefulWidget {
  const RequireAuthGuard({
    required this.routeName,
    required this.child,
    super.key,
  });

  final String routeName;
  final Widget child;

  @override
  State<RequireAuthGuard> createState() => _RequireAuthGuardState();
}

class _RequireAuthGuardState extends State<RequireAuthGuard>
    with _GuardRedirect {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    switch (auth.status) {
      case AuthStatus.authenticated:
        allow();
        return SessionPermissionScope(child: widget.child);
      case AuthStatus.signedOut:
        if (widget.routeName != AppRoutes.home) {
          auth.pendingRoute = widget.routeName;
        }
        redirect(AppRoutes.login);
        return const AuthSplashScreen();
      case AuthStatus.verificationRequired:
      case AuthStatus.checkingVerification:
        redirect(AppRoutes.verifyEmail);
        return const AuthSplashScreen();
      default:
        return const AuthSplashScreen();
    }
  }
}

/// Guards login/signup/forgot-password: already-authenticated users are sent
/// to their intended destination (or Home); unverified users to verify.
class PublicOnlyGuard extends StatefulWidget {
  const PublicOnlyGuard({required this.child, super.key});

  final Widget child;

  @override
  State<PublicOnlyGuard> createState() => _PublicOnlyGuardState();
}

class _PublicOnlyGuardState extends State<PublicOnlyGuard>
    with _GuardRedirect {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    switch (auth.status) {
      case AuthStatus.restoring:
        return const AuthSplashScreen();
      case AuthStatus.authenticated:
        if (!_navigating) {
          redirect(auth.takePendingRoute() ?? AppRoutes.home);
        }
        return const AuthSplashScreen();
      case AuthStatus.verificationRequired:
        redirect(AppRoutes.verifyEmail);
        return const AuthSplashScreen();
      default:
        allow();
        return widget.child;
    }
  }
}

/// Guards the verify-email route: only reachable while verification is
/// actually pending.
class VerifyEmailGuard extends StatefulWidget {
  const VerifyEmailGuard({required this.child, super.key});

  final Widget child;

  @override
  State<VerifyEmailGuard> createState() => _VerifyEmailGuardState();
}

class _VerifyEmailGuardState extends State<VerifyEmailGuard>
    with _GuardRedirect {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    switch (auth.status) {
      case AuthStatus.verificationRequired:
      case AuthStatus.checkingVerification:
        allow();
        return widget.child;
      case AuthStatus.signedOut:
        redirect(AppRoutes.login);
        return const AuthSplashScreen();
      case AuthStatus.authenticated:
        if (!_navigating) {
          redirect(auth.takePendingRoute() ?? AppRoutes.home);
        }
        return const AuthSplashScreen();
      default:
        return const AuthSplashScreen();
    }
  }
}

/// Provides the 0.6 permission helpers seeded from the session's `/me`
/// permissions, so PermissionGate works on any protected route.
class SessionPermissionScope extends StatefulWidget {
  const SessionPermissionScope({required this.child, super.key});

  final Widget child;

  @override
  State<SessionPermissionScope> createState() => _SessionPermissionScopeState();
}

class _SessionPermissionScopeState extends State<SessionPermissionScope> {
  PermissionController? _controller;
  Set<String>? _seeded;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final permissions =
        auth.currentUser?.permissions.toSet() ?? const <String>{};
    if (_controller == null || !_setEquals(_seeded!, permissions)) {
      final stale = _controller;
      if (stale != null) {
        // Dispose after this frame: the InheritedNotifier detaches from the
        // old controller during the current build.
        WidgetsBinding.instance.addPostFrameCallback((_) => stale.dispose());
      }
      _controller = PermissionController(initialPermissions: permissions);
      _seeded = permissions;
    }
    return PermissionProvider(controller: _controller!, child: widget.child);
  }

  static bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);
}

/// Branded 403 state rendered in place when the role lacks a permission.
/// UX only — FastAPI's require_permission stays authoritative.
class NoAccessScreen extends StatelessWidget {
  const NoAccessScreen({required this.permission, super.key});

  final String permission;

  @override
  Widget build(BuildContext context) {
    // Rendered inside the 2.1 app shell's content area, not full-screen.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DsSpacing.s6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: AppCard(
            padding: const EdgeInsets.all(DsSpacing.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: StatusPill(
                    label: '403 — No access',
                    status: AppStatus.critical,
                  ),
                ),
                const SizedBox(height: DsSpacing.s4),
                Text(
                  "You can't view this area",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: DsSpacing.s3),
                Text(
                  "Your role doesn't include the permission required for "
                  'this page ($permission). If you believe this is a '
                  'mistake, contact your company admin.',
                ),
                const SizedBox(height: DsSpacing.s6),
                AppButton(
                  label: 'Back to Home',
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (_) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
