import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../auth/permissions.dart';
import '../design_system/logo.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../navigation/nav_config.dart';

/// Persistent authenticated shell: app bar with user menu and theme toggle,
/// permission-filtered bottom navigation (Home / Assets / Work / More), and a
/// "More" sheet for secondary destinations. Every protected route renders its
/// content inside this scaffold. The nav contract mirrors
/// apps/admin/src/navigation/nav-config.tsx.
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.currentRoute,
    required this.child,
    super.key,
  });

  final String currentRoute;
  final Widget child;

  void _goTo(BuildContext context, String route) {
    if (route == currentRoute) return;
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }

  Future<void> _openMoreSheet(
    BuildContext context,
    List<NavDestination> secondary,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DsSpacing.s5,
                DsSpacing.s2,
                DsSpacing.s5,
                DsSpacing.s3,
              ),
              child: Text(
                'More modules',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            for (final destination in secondary)
              ListTile(
                key: Key('more-${destination.route}'),
                leading: Icon(destination.icon),
                title: Text(destination.label),
                trailing: destination.route == currentRoute
                    ? const Icon(Icons.check, size: 18)
                    : null,
                selected: destination.route == currentRoute,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _goTo(context, destination.route);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final permissions = PermissionProvider.of(context);
    final theme = AppThemeScope.of(context);
    final user = auth.currentUser;
    final primary = AppNav.primaryDestinations(permissions.can);
    final secondary = AppNav.secondaryDestinations(permissions.can);
    final title = AppNav.byRoute(currentRoute)?.label ??
        (currentRoute == '/rbac-demo' ? 'Assets demo' : 'Not found');

    final primaryIndex =
        primary.indexWhere((destination) => destination.route == currentRoute);
    final onSecondary =
        secondary.any((destination) => destination.route == currentRoute);
    final selectedIndex =
        primaryIndex >= 0 ? primaryIndex : (onSecondary ? primary.length : 0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandLogo(
              decorative: true,
              height: 22,
              variant: LogoVariant.mark,
            ),
            const SizedBox(width: DsSpacing.s3),
            Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('theme-toggle'),
            tooltip: 'Toggle theme',
            icon: Icon(
              theme.mode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: theme.toggle,
          ),
          if (user != null)
            PopupMenuButton<String>(
              key: const Key('user-menu'),
              tooltip: 'User menu',
              onSelected: (action) {
                if (action == 'refresh') auth.refreshSession();
                if (action == 'sign-out') auth.signOut();
              },
              itemBuilder: (menuContext) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _displayName(user.email),
                        style: Theme.of(menuContext).textTheme.titleMedium,
                      ),
                      const SizedBox(height: DsSpacing.s1),
                      Text(
                        user.email,
                        style: Theme.of(menuContext).textTheme.bodySmall,
                      ),
                      const SizedBox(height: DsSpacing.s2),
                      Wrap(
                        spacing: DsSpacing.s2,
                        runSpacing: DsSpacing.s1,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppBadge(label: user.roleKey),
                          Text(
                            user.companyName,
                            style: Theme.of(menuContext).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  key: Key('refresh-session'),
                  value: 'refresh',
                  child: Text('Refresh session'),
                ),
                const PopupMenuItem<String>(
                  key: Key('sign-out'),
                  value: 'sign-out',
                  child: Text('Sign out'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: DsSpacing.s3),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: DsColors.primary500.withAlpha(60),
                  child: Text(
                    _initials(user.email),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index < primary.length) {
            _goTo(context, primary[index].route);
          } else {
            _openMoreSheet(context, secondary);
          }
        },
        destinations: [
          for (final destination in primary)
            NavigationDestination(
              key: Key('nav-${destination.route}'),
              icon: Icon(destination.icon),
              label: destination.label,
            ),
          const NavigationDestination(
            key: Key('nav-more'),
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  static String _initials(String email) {
    final name = email.split('@').first;
    final parts =
        name.split(RegExp(r'[._-]+')).where((part) => part.isNotEmpty).toList();
    final first = parts.isNotEmpty ? parts.first[0] : '?';
    final second = parts.length > 1
        ? parts[1][0]
        : (name.length > 1 ? name[1] : '');
    return '$first$second'.toUpperCase();
  }

  static String _displayName(String email) {
    final words = email
        .split('@')
        .first
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) => part[0].toUpperCase() + part.substring(1),
        );
    return words.join(' ');
  }
}

/// Branded placeholder for modules that exist on the roadmap but are not
/// built yet. Deliberately fakes nothing.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.moduleName, super.key});

  final String moduleName;

  @override
  Widget build(BuildContext context) {
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
                  child: StatusPill(label: 'On the roadmap', status: AppStatus.info),
                ),
                const SizedBox(height: DsSpacing.s4),
                Text(
                  '$moduleName is coming soon',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: DsSpacing.s3),
                const Text(
                  'This module is planned and will be built in an upcoming '
                  'phase. Nothing here is functional yet — no data has been '
                  'faked.',
                ),
                const SizedBox(height: DsSpacing.s6),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppNav.home, (_) => false),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Branded 404 rendered inside the shell.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    label: '404 — Not found',
                    status: AppStatus.critical,
                  ),
                ),
                const SizedBox(height: DsSpacing.s4),
                Text(
                  "This page doesn't exist",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: DsSpacing.s3),
                const Text('Check the address, or head back to Home.'),
                const SizedBox(height: DsSpacing.s6),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppNav.home, (_) => false),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
