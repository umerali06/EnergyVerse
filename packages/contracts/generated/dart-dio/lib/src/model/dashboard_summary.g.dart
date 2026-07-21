// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardSummary extends DashboardSummary {
  @override
  final int auditEvents;
  @override
  final DateTime companyCreatedAt;
  @override
  final String companyName;
  @override
  final int rolesTotal;
  @override
  final String subscriptionTier;
  @override
  final int usersActive;
  @override
  final int usersTotal;
  @override
  final int windowDays;

  factory _$DashboardSummary(
          [void Function(DashboardSummaryBuilder)? updates]) =>
      (new DashboardSummaryBuilder()..update(updates))._build();

  _$DashboardSummary._(
      {required this.auditEvents,
      required this.companyCreatedAt,
      required this.companyName,
      required this.rolesTotal,
      required this.subscriptionTier,
      required this.usersActive,
      required this.usersTotal,
      required this.windowDays})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        auditEvents, r'DashboardSummary', 'auditEvents');
    BuiltValueNullFieldError.checkNotNull(
        companyCreatedAt, r'DashboardSummary', 'companyCreatedAt');
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'DashboardSummary', 'companyName');
    BuiltValueNullFieldError.checkNotNull(
        rolesTotal, r'DashboardSummary', 'rolesTotal');
    BuiltValueNullFieldError.checkNotNull(
        subscriptionTier, r'DashboardSummary', 'subscriptionTier');
    BuiltValueNullFieldError.checkNotNull(
        usersActive, r'DashboardSummary', 'usersActive');
    BuiltValueNullFieldError.checkNotNull(
        usersTotal, r'DashboardSummary', 'usersTotal');
    BuiltValueNullFieldError.checkNotNull(
        windowDays, r'DashboardSummary', 'windowDays');
  }

  @override
  DashboardSummary rebuild(void Function(DashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardSummaryBuilder toBuilder() =>
      new DashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardSummary &&
        auditEvents == other.auditEvents &&
        companyCreatedAt == other.companyCreatedAt &&
        companyName == other.companyName &&
        rolesTotal == other.rolesTotal &&
        subscriptionTier == other.subscriptionTier &&
        usersActive == other.usersActive &&
        usersTotal == other.usersTotal &&
        windowDays == other.windowDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, auditEvents.hashCode);
    _$hash = $jc(_$hash, companyCreatedAt.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, rolesTotal.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, usersActive.hashCode);
    _$hash = $jc(_$hash, usersTotal.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardSummary')
          ..add('auditEvents', auditEvents)
          ..add('companyCreatedAt', companyCreatedAt)
          ..add('companyName', companyName)
          ..add('rolesTotal', rolesTotal)
          ..add('subscriptionTier', subscriptionTier)
          ..add('usersActive', usersActive)
          ..add('usersTotal', usersTotal)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class DashboardSummaryBuilder
    implements Builder<DashboardSummary, DashboardSummaryBuilder> {
  _$DashboardSummary? _$v;

  int? _auditEvents;
  int? get auditEvents => _$this._auditEvents;
  set auditEvents(int? auditEvents) => _$this._auditEvents = auditEvents;

  DateTime? _companyCreatedAt;
  DateTime? get companyCreatedAt => _$this._companyCreatedAt;
  set companyCreatedAt(DateTime? companyCreatedAt) =>
      _$this._companyCreatedAt = companyCreatedAt;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  int? _rolesTotal;
  int? get rolesTotal => _$this._rolesTotal;
  set rolesTotal(int? rolesTotal) => _$this._rolesTotal = rolesTotal;

  String? _subscriptionTier;
  String? get subscriptionTier => _$this._subscriptionTier;
  set subscriptionTier(String? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  int? _usersActive;
  int? get usersActive => _$this._usersActive;
  set usersActive(int? usersActive) => _$this._usersActive = usersActive;

  int? _usersTotal;
  int? get usersTotal => _$this._usersTotal;
  set usersTotal(int? usersTotal) => _$this._usersTotal = usersTotal;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  DashboardSummaryBuilder() {
    DashboardSummary._defaults(this);
  }

  DashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _auditEvents = $v.auditEvents;
      _companyCreatedAt = $v.companyCreatedAt;
      _companyName = $v.companyName;
      _rolesTotal = $v.rolesTotal;
      _subscriptionTier = $v.subscriptionTier;
      _usersActive = $v.usersActive;
      _usersTotal = $v.usersTotal;
      _windowDays = $v.windowDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardSummary;
  }

  @override
  void update(void Function(DashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardSummary build() => _build();

  _$DashboardSummary _build() {
    final _$result = _$v ??
        new _$DashboardSummary._(
            auditEvents: BuiltValueNullFieldError.checkNotNull(
                auditEvents, r'DashboardSummary', 'auditEvents'),
            companyCreatedAt: BuiltValueNullFieldError.checkNotNull(
                companyCreatedAt, r'DashboardSummary', 'companyCreatedAt'),
            companyName: BuiltValueNullFieldError.checkNotNull(
                companyName, r'DashboardSummary', 'companyName'),
            rolesTotal: BuiltValueNullFieldError.checkNotNull(
                rolesTotal, r'DashboardSummary', 'rolesTotal'),
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier, r'DashboardSummary', 'subscriptionTier'),
            usersActive: BuiltValueNullFieldError.checkNotNull(
                usersActive, r'DashboardSummary', 'usersActive'),
            usersTotal: BuiltValueNullFieldError.checkNotNull(
                usersTotal, r'DashboardSummary', 'usersTotal'),
            windowDays: BuiltValueNullFieldError.checkNotNull(
                windowDays, r'DashboardSummary', 'windowDays'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
