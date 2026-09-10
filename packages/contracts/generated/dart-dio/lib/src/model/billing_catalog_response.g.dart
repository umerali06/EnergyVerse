// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_catalog_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingCatalogResponse extends BillingCatalogResponse {
  @override
  final BuiltList<BillingPlanResponse> plans;
  @override
  final int trialDays;

  factory _$BillingCatalogResponse(
          [void Function(BillingCatalogResponseBuilder)? updates]) =>
      (new BillingCatalogResponseBuilder()..update(updates))._build();

  _$BillingCatalogResponse._({required this.plans, required this.trialDays})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        plans, r'BillingCatalogResponse', 'plans');
    BuiltValueNullFieldError.checkNotNull(
        trialDays, r'BillingCatalogResponse', 'trialDays');
  }

  @override
  BillingCatalogResponse rebuild(
          void Function(BillingCatalogResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingCatalogResponseBuilder toBuilder() =>
      new BillingCatalogResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingCatalogResponse &&
        plans == other.plans &&
        trialDays == other.trialDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, plans.hashCode);
    _$hash = $jc(_$hash, trialDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingCatalogResponse')
          ..add('plans', plans)
          ..add('trialDays', trialDays))
        .toString();
  }
}

class BillingCatalogResponseBuilder
    implements Builder<BillingCatalogResponse, BillingCatalogResponseBuilder> {
  _$BillingCatalogResponse? _$v;

  ListBuilder<BillingPlanResponse>? _plans;
  ListBuilder<BillingPlanResponse> get plans =>
      _$this._plans ??= new ListBuilder<BillingPlanResponse>();
  set plans(ListBuilder<BillingPlanResponse>? plans) => _$this._plans = plans;

  int? _trialDays;
  int? get trialDays => _$this._trialDays;
  set trialDays(int? trialDays) => _$this._trialDays = trialDays;

  BillingCatalogResponseBuilder() {
    BillingCatalogResponse._defaults(this);
  }

  BillingCatalogResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _plans = $v.plans.toBuilder();
      _trialDays = $v.trialDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingCatalogResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BillingCatalogResponse;
  }

  @override
  void update(void Function(BillingCatalogResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingCatalogResponse build() => _build();

  _$BillingCatalogResponse _build() {
    _$BillingCatalogResponse _$result;
    try {
      _$result = _$v ??
          new _$BillingCatalogResponse._(
              plans: plans.build(),
              trialDays: BuiltValueNullFieldError.checkNotNull(
                  trialDays, r'BillingCatalogResponse', 'trialDays'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'plans';
        plans.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'BillingCatalogResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
