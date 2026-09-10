import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// Every entitlement key the catalog defines, i.e. the Enterprise plan.
const enterpriseFeatureKeys = <String>[
  'assets',
  'inspections',
  'ai_media_analysis',
  'safety_reports',
  'documents',
  'reports',
  'digital_twin',
  'ar_inspection',
  'permits',
  'work_orders',
  'vr_training',
  'sso',
  'audit_export',
];

/// The base set every paid tier includes: Starter and Field (§22.1).
const baseFeatureKeys = <String>[
  'assets',
  'inspections',
  'ai_media_analysis',
  'safety_reports',
  'documents',
  'reports',
  'digital_twin',
];

/// Fully-entitled subscription for suites that are not about billing.
///
/// Defaults to the richest plan on purpose: the shell filters navigation by the
/// company's plan (Phase 13.6, D-093), so anything narrower would hide modules
/// those suites assert on. Tests that *are* about plan gating pass a smaller
/// [features] list.
SubscriptionResponse subscriptionResponseFixture({
  String tier = 'enterprise',
  String? planName = 'Enterprise',
  String status = 'active',
  bool isEntitled = true,
  List<String> features = enterpriseFeatureKeys,
  int? trialDaysRemaining,
}) {
  return SubscriptionResponse(
    (builder) => builder
      ..tier = tier
      ..planName = planName
      ..status = status
      ..isEntitled = isEntitled
      ..features = ListBuilder<String>(features)
      ..trialEndsAt = null
      ..trialDaysRemaining = trialDaysRemaining
      ..currentPeriodEnd = null
      ..quotas = BillingPlanQuotasResponseBuilder()
        ..quotas.facilities = null
        ..quotas.assets = null
        ..quotas.seats = null,
  );
}
