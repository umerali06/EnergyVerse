import 'package:flutter/widgets.dart';

/// The company's plan, loaded once for the whole shell.
///
/// Mirrors the admin portal's `SubscriptionProvider` (D-093) so both clients
/// answer "may this company use this module" the same way:
///
/// * The feature list comes from `GET /api/v1/billing/subscription` verbatim.
///   Neither client maps a tier to features itself — that would put the mapping
///   in three languages and let a repricing make a client disagree with the
///   server about what a customer bought.
/// * [hasFeature] fails closed while loading and on error, matching the API's
///   402. Showing a module and then retracting it would flash capabilities a
///   Starter tenant does not have.
enum SubscriptionStatus { loading, ready, error }

/// The subset of the subscription payload the app acts on. Deliberately not the
/// generated model: this controller is constructed in tests from literals, and
/// the shell only needs these fields.
@immutable
class SubscriptionSnapshot {
  const SubscriptionSnapshot({
    required this.tier,
    required this.status,
    required this.isEntitled,
    required this.features,
    this.planName,
    this.trialDaysRemaining,
  });

  final String tier;
  final String? planName;

  /// Stripe's subscription status, or `incomplete` before checkout.
  final String status;

  /// Whether the plan grants anything at all. A `past_due` company is still
  /// entitled — Stripe retries for weeks, and locking an operator out of its
  /// permit and safety records over an expired card would be dangerous.
  final bool isEntitled;

  final Set<String> features;
  final int? trialDaysRemaining;

  bool get isTrialing => status == 'trialing';
}

/// Loads and exposes the plan. Fetching is injected so widget tests never need
/// a network or a signed-in Firebase session.
class SubscriptionController extends ChangeNotifier {
  SubscriptionController({
    required Future<SubscriptionSnapshot> Function() load,
    SubscriptionSnapshot? initial,
  }) : _load = load,
       _snapshot = initial,
       _status = initial == null
           ? SubscriptionStatus.loading
           : SubscriptionStatus.ready;

  final Future<SubscriptionSnapshot> Function() _load;

  SubscriptionSnapshot? _snapshot;
  SubscriptionStatus _status;
  bool _disposed = false;

  SubscriptionSnapshot? get snapshot => _snapshot;
  SubscriptionStatus get status => _status;

  Future<void> refresh() async {
    if (_disposed) return;
    try {
      final next = await _load();
      if (_disposed) return;
      _snapshot = next;
      _status = SubscriptionStatus.ready;
    } catch (_) {
      if (_disposed) return;
      // A failed load is not an entitlement decision; `hasFeature` already
      // fails closed, and the plan card says access is unaffected.
      _status = SubscriptionStatus.error;
    }
    notifyListeners();
  }

  /// Whether the company's plan includes [feature].
  ///
  /// A null feature is an ungated module, present on every plan. Anything else
  /// requires a resolved, entitled subscription that lists the key.
  bool hasFeature(String? feature) {
    if (feature == null) return true;
    if (_status != SubscriptionStatus.ready) return false;
    final current = _snapshot;
    if (current == null || !current.isEntitled) return false;
    return current.features.contains(feature);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class SubscriptionScope extends InheritedNotifier<SubscriptionController> {
  const SubscriptionScope({
    required SubscriptionController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static SubscriptionController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SubscriptionScope>();
    assert(scope != null, 'SubscriptionScope is required');
    return scope!.notifier!;
  }

  /// Returns null instead of asserting, for widgets that render both inside and
  /// outside the authenticated shell.
  static SubscriptionController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SubscriptionScope>()?.notifier;
}

/// Mounts a [SubscriptionController] for the authenticated session.
///
/// Sits inside the auth guard because only a signed-in session can read a
/// subscription, and above the shell because the shell's navigation is filtered
/// by the company's plan. Mirrors `SessionPermissionScope`: one controller per
/// company, rebuilt if the signed-in company changes.
class SessionSubscriptionScope extends StatefulWidget {
  const SessionSubscriptionScope({
    required this.load,
    required this.child,
    this.companyId,
    super.key,
  });

  /// Injected so widget tests supply a literal instead of a network call.
  final Future<SubscriptionSnapshot> Function() load;

  /// Rebuilds the controller when the signed-in company changes, so one
  /// tenant's plan can never leak into another's shell.
  final String? companyId;

  final Widget child;

  @override
  State<SessionSubscriptionScope> createState() =>
      _SessionSubscriptionScopeState();
}

class _SessionSubscriptionScopeState extends State<SessionSubscriptionScope> {
  SubscriptionController? _controller;
  String? _seededCompanyId;

  @override
  void initState() {
    super.initState();
    _seed();
  }

  @override
  void didUpdateWidget(SessionSubscriptionScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.companyId != _seededCompanyId) _seed();
  }

  void _seed() {
    final stale = _controller;
    if (stale != null) {
      // Dispose after this frame: the InheritedNotifier is still attached to
      // the old controller during the current build.
      WidgetsBinding.instance.addPostFrameCallback((_) => stale.dispose());
    }
    final controller = SubscriptionController(load: widget.load);
    _controller = controller;
    _seededCompanyId = widget.companyId;
    // Fire after the frame so the first build is not blocked on the network;
    // `hasFeature` fails closed until it lands.
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.refresh());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SubscriptionScope(controller: _controller!, child: widget.child);
}
