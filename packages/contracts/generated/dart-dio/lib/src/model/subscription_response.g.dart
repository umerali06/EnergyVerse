// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionResponse extends SubscriptionResponse {
  @override
  final DateTime? currentPeriodEnd;
  @override
  final BuiltList<String> features;
  @override
  final bool isEntitled;
  @override
  final String? planName;
  @override
  final BillingPlanQuotasResponse quotas;
  @override
  final String status;
  @override
  final String tier;
  @override
  final int? trialDaysRemaining;
  @override
  final DateTime? trialEndsAt;

  factory _$SubscriptionResponse(
          [void Function(SubscriptionResponseBuilder)? updates]) =>
      (new SubscriptionResponseBuilder()..update(updates))._build();

  _$SubscriptionResponse._(
      {this.currentPeriodEnd,
      required this.features,
      required this.isEntitled,
      this.planName,
      required this.quotas,
      required this.status,
      required this.tier,
      this.trialDaysRemaining,
      this.trialEndsAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        features, r'SubscriptionResponse', 'features');
    BuiltValueNullFieldError.checkNotNull(
        isEntitled, r'SubscriptionResponse', 'isEntitled');
    BuiltValueNullFieldError.checkNotNull(
        quotas, r'SubscriptionResponse', 'quotas');
    BuiltValueNullFieldError.checkNotNull(
        status, r'SubscriptionResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(
        tier, r'SubscriptionResponse', 'tier');
  }

  @override
  SubscriptionResponse rebuild(
          void Function(SubscriptionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionResponseBuilder toBuilder() =>
      new SubscriptionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionResponse &&
        currentPeriodEnd == other.currentPeriodEnd &&
        features == other.features &&
        isEntitled == other.isEntitled &&
        planName == other.planName &&
        quotas == other.quotas &&
        status == other.status &&
        tier == other.tier &&
        trialDaysRemaining == other.trialDaysRemaining &&
        trialEndsAt == other.trialEndsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPeriodEnd.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, isEntitled.hashCode);
    _$hash = $jc(_$hash, planName.hashCode);
    _$hash = $jc(_$hash, quotas.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, trialDaysRemaining.hashCode);
    _$hash = $jc(_$hash, trialEndsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionResponse')
          ..add('currentPeriodEnd', currentPeriodEnd)
          ..add('features', features)
          ..add('isEntitled', isEntitled)
          ..add('planName', planName)
          ..add('quotas', quotas)
          ..add('status', status)
          ..add('tier', tier)
          ..add('trialDaysRemaining', trialDaysRemaining)
          ..add('trialEndsAt', trialEndsAt))
        .toString();
  }
}

class SubscriptionResponseBuilder
    implements Builder<SubscriptionResponse, SubscriptionResponseBuilder> {
  _$SubscriptionResponse? _$v;

  DateTime? _currentPeriodEnd;
  DateTime? get currentPeriodEnd => _$this._currentPeriodEnd;
  set currentPeriodEnd(DateTime? currentPeriodEnd) =>
      _$this._currentPeriodEnd = currentPeriodEnd;

  ListBuilder<String>? _features;
  ListBuilder<String> get features =>
      _$this._features ??= new ListBuilder<String>();
  set features(ListBuilder<String>? features) => _$this._features = features;

  bool? _isEntitled;
  bool? get isEntitled => _$this._isEntitled;
  set isEntitled(bool? isEntitled) => _$this._isEntitled = isEntitled;

  String? _planName;
  String? get planName => _$this._planName;
  set planName(String? planName) => _$this._planName = planName;

  BillingPlanQuotasResponseBuilder? _quotas;
  BillingPlanQuotasResponseBuilder get quotas =>
      _$this._quotas ??= new BillingPlanQuotasResponseBuilder();
  set quotas(BillingPlanQuotasResponseBuilder? quotas) =>
      _$this._quotas = quotas;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _tier;
  String? get tier => _$this._tier;
  set tier(String? tier) => _$this._tier = tier;

  int? _trialDaysRemaining;
  int? get trialDaysRemaining => _$this._trialDaysRemaining;
  set trialDaysRemaining(int? trialDaysRemaining) =>
      _$this._trialDaysRemaining = trialDaysRemaining;

  DateTime? _trialEndsAt;
  DateTime? get trialEndsAt => _$this._trialEndsAt;
  set trialEndsAt(DateTime? trialEndsAt) => _$this._trialEndsAt = trialEndsAt;

  SubscriptionResponseBuilder() {
    SubscriptionResponse._defaults(this);
  }

  SubscriptionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPeriodEnd = $v.currentPeriodEnd;
      _features = $v.features.toBuilder();
      _isEntitled = $v.isEntitled;
      _planName = $v.planName;
      _quotas = $v.quotas.toBuilder();
      _status = $v.status;
      _tier = $v.tier;
      _trialDaysRemaining = $v.trialDaysRemaining;
      _trialEndsAt = $v.trialEndsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubscriptionResponse;
  }

  @override
  void update(void Function(SubscriptionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionResponse build() => _build();

  _$SubscriptionResponse _build() {
    _$SubscriptionResponse _$result;
    try {
      _$result = _$v ??
          new _$SubscriptionResponse._(
              currentPeriodEnd: currentPeriodEnd,
              features: features.build(),
              isEntitled: BuiltValueNullFieldError.checkNotNull(
                  isEntitled, r'SubscriptionResponse', 'isEntitled'),
              planName: planName,
              quotas: quotas.build(),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'SubscriptionResponse', 'status'),
              tier: BuiltValueNullFieldError.checkNotNull(
                  tier, r'SubscriptionResponse', 'tier'),
              trialDaysRemaining: trialDaysRemaining,
              trialEndsAt: trialEndsAt);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();

        _$failedField = 'quotas';
        quotas.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SubscriptionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
