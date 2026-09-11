// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_plan_quotas_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingPlanQuotasResponse extends BillingPlanQuotasResponse {
  @override
  final int? assets;
  @override
  final int? facilities;
  @override
  final int? seats;

  factory _$BillingPlanQuotasResponse(
          [void Function(BillingPlanQuotasResponseBuilder)? updates]) =>
      (new BillingPlanQuotasResponseBuilder()..update(updates))._build();

  _$BillingPlanQuotasResponse._({this.assets, this.facilities, this.seats})
      : super._();

  @override
  BillingPlanQuotasResponse rebuild(
          void Function(BillingPlanQuotasResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingPlanQuotasResponseBuilder toBuilder() =>
      new BillingPlanQuotasResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingPlanQuotasResponse &&
        assets == other.assets &&
        facilities == other.facilities &&
        seats == other.seats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assets.hashCode);
    _$hash = $jc(_$hash, facilities.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingPlanQuotasResponse')
          ..add('assets', assets)
          ..add('facilities', facilities)
          ..add('seats', seats))
        .toString();
  }
}

class BillingPlanQuotasResponseBuilder
    implements
        Builder<BillingPlanQuotasResponse, BillingPlanQuotasResponseBuilder> {
  _$BillingPlanQuotasResponse? _$v;

  int? _assets;
  int? get assets => _$this._assets;
  set assets(int? assets) => _$this._assets = assets;

  int? _facilities;
  int? get facilities => _$this._facilities;
  set facilities(int? facilities) => _$this._facilities = facilities;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  BillingPlanQuotasResponseBuilder() {
    BillingPlanQuotasResponse._defaults(this);
  }

  BillingPlanQuotasResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assets = $v.assets;
      _facilities = $v.facilities;
      _seats = $v.seats;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingPlanQuotasResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BillingPlanQuotasResponse;
  }

  @override
  void update(void Function(BillingPlanQuotasResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingPlanQuotasResponse build() => _build();

  _$BillingPlanQuotasResponse _build() {
    final _$result = _$v ??
        new _$BillingPlanQuotasResponse._(
            assets: assets, facilities: facilities, seats: seats);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
