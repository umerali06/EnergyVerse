import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fev_mobile/billing/subscription_controller.dart';
import 'package:fev_mobile/navigation/nav_config.dart';

/// Every entitlement key the catalog defines, i.e. the Enterprise plan.
const _enterpriseFeatures = {
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
};

/// The base set every paid tier includes: Starter and Field (§22.1).
const _baseFeatures = {
  'assets',
  'inspections',
  'ai_media_analysis',
  'safety_reports',
  'documents',
  'reports',
  'digital_twin',
};

SubscriptionSnapshot _snapshot({
  Set<String> features = _enterpriseFeatures,
  bool isEntitled = true,
  String status = 'active',
  String tier = 'enterprise',
  String? planName = 'Enterprise',
  int? trialDaysRemaining,
}) {
  return SubscriptionSnapshot(
    tier: tier,
    planName: planName,
    status: status,
    isEntitled: isEntitled,
    features: features,
    trialDaysRemaining: trialDaysRemaining,
  );
}

void main() {
  group('SubscriptionController', () {
    test('grants only the keys the plan lists', () async {
      final controller = SubscriptionController(
        load: () async => _snapshot(features: _baseFeatures),
      );
      await controller.refresh();

      expect(controller.status, SubscriptionStatus.ready);
      expect(controller.hasFeature('assets'), isTrue);
      expect(controller.hasFeature('work_orders'), isFalse);
      expect(controller.hasFeature('permits'), isFalse);
      controller.dispose();
    });

    test('treats a null feature as part of every plan', () async {
      final controller = SubscriptionController(load: () async => _snapshot());
      await controller.refresh();

      expect(controller.hasFeature(null), isTrue);
      controller.dispose();
    });

    test('fails closed before the plan has loaded', () {
      final controller = SubscriptionController(
        load: () async => _snapshot(),
      );

      // Not yet refreshed. A client that guessed "true" here would show
      // modules the API will refuse with a 402.
      expect(controller.status, SubscriptionStatus.loading);
      expect(controller.hasFeature('assets'), isFalse);
      controller.dispose();
    });

    test('fails closed when the plan cannot be loaded', () async {
      final controller = SubscriptionController(
        load: () async => throw Exception('offline'),
      );
      await controller.refresh();

      expect(controller.status, SubscriptionStatus.error);
      expect(controller.hasFeature('assets'), isFalse);
      controller.dispose();
    });

    test('refuses everything when the subscription is not entitled', () async {
      // An unpaid company can list features and still be entitled to none.
      final controller = SubscriptionController(
        load: () async => _snapshot(
          features: _enterpriseFeatures,
          isEntitled: false,
          status: 'canceled',
        ),
      );
      await controller.refresh();

      expect(controller.hasFeature('assets'), isFalse);
      expect(controller.hasFeature('work_orders'), isFalse);
      controller.dispose();
    });

    test('a past-due company keeps its entitlements', () async {
      // Stripe retries for weeks; locking an operator out of its permit and
      // safety records over an expired card would be dangerous.
      final controller = SubscriptionController(
        load: () async => _snapshot(status: 'past_due'),
      );
      await controller.refresh();

      expect(controller.hasFeature('permits'), isTrue);
      controller.dispose();
    });

    test('reports the trial and notifies listeners once loaded', () async {
      var notifications = 0;
      final controller = SubscriptionController(
        load: () async => _snapshot(
          planName: 'Operations',
          status: 'trialing',
          tier: 'operations',
          trialDaysRemaining: 7,
        ),
      )..addListener(() => notifications += 1);

      await controller.refresh();

      expect(notifications, 1);
      expect(controller.snapshot!.isTrialing, isTrue);
      expect(controller.snapshot!.trialDaysRemaining, 7);
      controller.dispose();
    });

    test('an initial snapshot is ready without a load', () {
      final controller = SubscriptionController(
        initial: _snapshot(),
        load: () async => throw StateError('should not be called'),
      );

      expect(controller.status, SubscriptionStatus.ready);
      expect(controller.hasFeature('vr_training'), isTrue);
      controller.dispose();
    });

    test('a load resolving after dispose does not touch state', () async {
      final controller = SubscriptionController(
        load: () async => _snapshot(),
      );
      final pending = controller.refresh();
      controller.dispose();

      // Must not throw "used after being disposed".
      await pending;
    });
  });

  group('navigation gating', () {
    bool allPermissions(String permission) => true;

    test('hides Operations-and-above modules on a base plan', () {
      final controller = SubscriptionController(
        initial: _snapshot(features: _baseFeatures),
        load: () async => _snapshot(),
      );

      final labels = AppNav.visible(allPermissions, controller.hasFeature)
          .map((destination) => destination.label)
          .toList();

      // Permission alone is not enough — this caller holds everything.
      expect(labels, isNot(contains('Work')));
      expect(labels, isNot(contains('Permits')));
      expect(labels, contains('Assets'));
      expect(labels, contains('Inspections'));
      expect(labels, contains('Safety'));
      controller.dispose();
    });

    test('restores them on a plan that includes them', () {
      final controller = SubscriptionController(
        initial: _snapshot(),
        load: () async => _snapshot(),
      );

      final labels = AppNav.visible(allPermissions, controller.hasFeature)
          .map((destination) => destination.label)
          .toList();

      expect(labels, contains('Work'));
      expect(labels, contains('Permits'));
      controller.dispose();
    });

    test('drops Work from the bottom bar on a base plan', () {
      // Work is a primary destination, so plan gating has to reach the bottom
      // navigation bar and not just the "More" sheet.
      final controller = SubscriptionController(
        initial: _snapshot(features: _baseFeatures),
        load: () async => _snapshot(),
      );

      final primary =
          AppNav.primaryDestinations(allPermissions, controller.hasFeature)
              .map((destination) => destination.label)
              .toList();

      expect(primary, isNot(contains('Work')));
      expect(primary, contains('Home'));
      expect(primary, contains('Assets'));
      controller.dispose();
    });

    test('shows only ungated destinations until the plan is known', () {
      final controller = SubscriptionController(
        load: () async => _snapshot(),
      );

      final labels = AppNav.visible(allPermissions, controller.hasFeature)
          .map((destination) => destination.label)
          .toList();

      expect(labels, contains('Home'));
      for (final gated in ['Assets', 'Work', 'Inspections', 'Permits']) {
        expect(labels, isNot(contains(gated)));
      }
      controller.dispose();
    });

    test('keeps the permission gate independent of the plan', () {
      bool noPermissions(String permission) => false;
      final labels = AppNav.visible(noPermissions, (_) => true)
          .map((destination) => destination.label)
          .toList();

      // Home and Documents carry no requiredPermission by design.
      expect(labels, contains('Home'));
      expect(labels, isNot(contains('Assets')));
    });

    test('defaults to allowing every feature for pre-Phase-13 callers', () {
      final withDefault =
          AppNav.visible(allPermissions).map((d) => d.label).toList();
      final withAllFeatures = AppNav.visible(allPermissions, (_) => true)
          .map((d) => d.label)
          .toList();

      expect(withDefault, withAllFeatures);
    });
  });

  group('SessionSubscriptionScope', () {
    testWidgets('loads the plan and exposes it to descendants', (tester) async {
      late SubscriptionController seen;
      await tester.pumpWidget(
        SessionSubscriptionScope(
          companyId: 'cmp_acme',
          load: () async => _snapshot(features: _baseFeatures),
          child: Builder(
            builder: (context) {
              seen = SubscriptionScope.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(seen.status, SubscriptionStatus.ready);
      expect(seen.hasFeature('assets'), isTrue);
      expect(seen.hasFeature('work_orders'), isFalse);
    });

    testWidgets('maybeOf returns null outside the scope', (tester) async {
      SubscriptionController? seen;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            seen = SubscriptionScope.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(seen, isNull);
    });

    testWidgets('reloads when the signed-in company changes', (tester) async {
      final loadedFor = <String>[];
      Widget scopeFor(String companyId) => SessionSubscriptionScope(
        companyId: companyId,
        load: () async {
          loadedFor.add(companyId);
          return _snapshot();
        },
        child: const SizedBox.shrink(),
      );

      await tester.pumpWidget(scopeFor('cmp_one'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(scopeFor('cmp_two'));
      await tester.pumpAndSettle();

      // One tenant's plan must never persist into another's shell.
      expect(loadedFor, ['cmp_one', 'cmp_two']);
    });
  });
}
