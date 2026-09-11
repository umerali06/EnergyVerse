// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_session_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutSessionRequest extends CheckoutSessionRequest {
  @override
  final String interval;
  @override
  final String tier;

  factory _$CheckoutSessionRequest(
          [void Function(CheckoutSessionRequestBuilder)? updates]) =>
      (new CheckoutSessionRequestBuilder()..update(updates))._build();

  _$CheckoutSessionRequest._({required this.interval, required this.tier})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        interval, r'CheckoutSessionRequest', 'interval');
    BuiltValueNullFieldError.checkNotNull(
        tier, r'CheckoutSessionRequest', 'tier');
  }

  @override
  CheckoutSessionRequest rebuild(
          void Function(CheckoutSessionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSessionRequestBuilder toBuilder() =>
      new CheckoutSessionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSessionRequest &&
        interval == other.interval &&
        tier == other.tier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, interval.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutSessionRequest')
          ..add('interval', interval)
          ..add('tier', tier))
        .toString();
  }
}

class CheckoutSessionRequestBuilder
    implements Builder<CheckoutSessionRequest, CheckoutSessionRequestBuilder> {
  _$CheckoutSessionRequest? _$v;

  String? _interval;
  String? get interval => _$this._interval;
  set interval(String? interval) => _$this._interval = interval;

  String? _tier;
  String? get tier => _$this._tier;
  set tier(String? tier) => _$this._tier = tier;

  CheckoutSessionRequestBuilder() {
    CheckoutSessionRequest._defaults(this);
  }

  CheckoutSessionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _interval = $v.interval;
      _tier = $v.tier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutSessionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CheckoutSessionRequest;
  }

  @override
  void update(void Function(CheckoutSessionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSessionRequest build() => _build();

  _$CheckoutSessionRequest _build() {
    final _$result = _$v ??
        new _$CheckoutSessionRequest._(
            interval: BuiltValueNullFieldError.checkNotNull(
                interval, r'CheckoutSessionRequest', 'interval'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'CheckoutSessionRequest', 'tier'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
