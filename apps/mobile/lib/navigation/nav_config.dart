import 'package:flutter/material.dart';

/// Single source of truth for the mobile application shell navigation.
///
/// This mirrors the admin contract in
/// apps/admin/src/navigation/nav-config.tsx — same items, same routes, same
/// `requiredPermission` keys from the Phase 0.4 catalog. Change them together.
///
/// `requiredPermission` is filtered through the Phase 0.6 permission helpers
/// with the authoritative permissions from `/api/v1/auth/me`. Items without a
/// permission (Dashboard, Documents — no `documents.*` key exists in the 0.4
/// catalog) are visible to every authenticated user. Visibility is UX only:
/// FastAPI's require_permission stays the security boundary.
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.route,
    this.requiredPermission,
    this.comingSoon = false,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final String route;
  final String? requiredPermission;

  /// Module exists on the roadmap but its screen is not built yet.
  final bool comingSoon;

  /// Shown in the bottom navigation bar (the infographic's Home / Assets /
  /// Work set); everything else lives behind "More".
  final bool primary;
}

class AppNav {
  static const home = '/';
  static const assets = '/assets';
  static const inspections = '/inspections';
  static const workOrders = '/work-orders';
  static const permits = '/permits';
  static const safety = '/safety';
  static const reports = '/reports';
  static const documents = '/documents';
  static const users = '/users';
  static const roles = '/roles';
  static const settings = '/settings';
  static const audit = '/audit';

  static const destinations = <NavDestination>[
    NavDestination(
      label: 'Home',
      icon: Icons.dashboard_outlined,
      route: home,
      primary: true,
    ),
    NavDestination(
      label: 'Assets',
      icon: Icons.inventory_2_outlined,
      route: assets,
      requiredPermission: 'assets.read',
      comingSoon: true,
      primary: true,
    ),
    NavDestination(
      label: 'Work',
      icon: Icons.build_outlined,
      route: workOrders,
      requiredPermission: 'work_orders.read',
      comingSoon: true,
      primary: true,
    ),
    NavDestination(
      label: 'Inspections',
      icon: Icons.fact_check_outlined,
      route: inspections,
      requiredPermission: 'inspections.read',
      comingSoon: true,
    ),
    NavDestination(
      label: 'Permits',
      icon: Icons.description_outlined,
      route: permits,
      requiredPermission: 'permits.read',
      comingSoon: true,
    ),
    NavDestination(
      label: 'Safety',
      icon: Icons.health_and_safety_outlined,
      route: safety,
      requiredPermission: 'safety.read',
      comingSoon: true,
    ),
    NavDestination(
      label: 'Reports',
      icon: Icons.insert_chart_outlined,
      route: reports,
      requiredPermission: 'reports.read',
      comingSoon: true,
    ),
    NavDestination(
      label: 'Documents',
      icon: Icons.folder_outlined,
      route: documents,
      comingSoon: true,
    ),
    NavDestination(
      label: 'Users',
      icon: Icons.people_outline,
      route: users,
      requiredPermission: 'users.manage',
    ),
    NavDestination(
      label: 'Roles',
      icon: Icons.shield_outlined,
      route: roles,
      requiredPermission: 'roles.manage',
    ),
    NavDestination(
      label: 'Admin & Settings',
      icon: Icons.settings_outlined,
      route: settings,
      requiredPermission: 'company.settings',
    ),
    NavDestination(
      label: 'Audit Log',
      icon: Icons.history_outlined,
      route: audit,
      requiredPermission: 'audit.read',
    ),
  ];

  static List<NavDestination> visible(bool Function(String permission) can) {
    return destinations
        .where(
          (destination) =>
              destination.requiredPermission == null ||
              can(destination.requiredPermission!),
        )
        .toList();
  }

  /// Bottom-bar items: the permitted primary destinations.
  static List<NavDestination> primaryDestinations(
    bool Function(String permission) can,
  ) =>
      visible(can).where((destination) => destination.primary).toList();

  /// "More"-sheet items: every permitted secondary destination.
  static List<NavDestination> secondaryDestinations(
    bool Function(String permission) can,
  ) =>
      visible(can).where((destination) => !destination.primary).toList();

  static NavDestination? byRoute(String route) {
    for (final destination in destinations) {
      if (destination.route == route) return destination;
    }
    return null;
  }
}
