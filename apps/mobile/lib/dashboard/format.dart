import 'package:flutter/material.dart';

/// Human-readable formatting for real audit_logs data. No fabricated copy —
/// every string here describes an actual field on a real event; unknown
/// action strings fall back to a de-slugified label rather than being
/// silently dropped, so future audit actions never render blank. Mirrors
/// apps/admin/src/dashboard/format.ts.
const _knownActions = <String, String>{
  'company.created': 'created the company',
  'company.updated': 'updated the company',
  'company.deleted': 'deleted the company',
  'company.self_registered': 'registered the company',
  'user.provisioned': 'provisioned a user',
  'user.migrated_to_auth_uid': 'migrated a user record',
  'access.denied': 'was denied access',
};

String describeAction(String action) =>
    _knownActions[action] ?? action.replaceAll(RegExp('[._]'), ' ');

enum ActionIcon { company, user, access, generic }

ActionIcon actionIconFor(String action) {
  if (action.startsWith('company.')) return ActionIcon.company;
  if (action.startsWith('user.')) return ActionIcon.user;
  if (action.startsWith('access.')) return ActionIcon.access;
  return ActionIcon.generic;
}

IconData iconFor(ActionIcon icon) => switch (icon) {
      ActionIcon.company => Icons.apartment_outlined,
      ActionIcon.user => Icons.person_outline,
      ActionIcon.access => Icons.shield_outlined,
      ActionIcon.generic => Icons.bolt_outlined,
    };

// Approximate thresholds for a compact display label — not a duration
// library. After weeks, everything collapses to "Xmo ago".
const _relativeUnits = <(int, String)>[
  (60, 's'),
  (60, 'm'),
  (24, 'h'),
  (7, 'd'),
  (4, 'w'),
];

/// Compact relative time (e.g. "3m ago", "5h ago") for the dense mono feed.
String formatRelativeTime(DateTime then, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  var deltaSeconds = reference.difference(then).inSeconds.clamp(0, 1 << 31);
  if (deltaSeconds < 5) return 'just now';
  for (final (amount, unit) in _relativeUnits) {
    if (deltaSeconds < amount) return '$deltaSeconds$unit ago';
    deltaSeconds = (deltaSeconds / amount).floor();
  }
  return '${deltaSeconds}mo ago';
}

String formatChartDay(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String formatCompanyDate(DateTime date) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
