// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutSessionResponse extends CheckoutSessionResponse {
  @override
  final String checkoutUrl;
  @override
  final String sessionId;

  factory _$CheckoutSessionResponse(
          [void Function(CheckoutSessionResponseBuilder)? updates]) =>
      (new CheckoutSessionResponseBuilder()..update(updates))._build();

  _$CheckoutSessionResponse._(
      {required this.checkoutUrl, required this.sessionId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        checkoutUrl, r'CheckoutSessionResponse', 'checkoutUrl');
    BuiltValueNullFieldError.checkNotNull(
        sessionId, r'CheckoutSessionResponse', 'sessionId');
  }

  @override
  CheckoutSessionResponse rebuild(
          void Function(CheckoutSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSessionResponseBuilder toBuilder() =>
      new CheckoutSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSessionResponse &&
        checkoutUrl == other.checkoutUrl &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checkoutUrl.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutSessionResponse')
          ..add('checkoutUrl', checkoutUrl)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class CheckoutSessionResponseBuilder
    implements
        Builder<CheckoutSessionResponse, CheckoutSessionResponseBuilder> {
  _$CheckoutSessionResponse? _$v;

  String? _checkoutUrl;
  String? get checkoutUrl => _$this._checkoutUrl;
  set checkoutUrl(String? checkoutUrl) => _$this._checkoutUrl = checkoutUrl;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  CheckoutSessionResponseBuilder() {
    CheckoutSessionResponse._defaults(this);
  }

  CheckoutSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checkoutUrl = $v.checkoutUrl;
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutSessionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CheckoutSessionResponse;
  }

  @override
  void update(void Function(CheckoutSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSessionResponse build() => _build();

  _$CheckoutSessionResponse _build() {
    final _$result = _$v ??
        new _$CheckoutSessionResponse._(
            checkoutUrl: BuiltValueNullFieldError.checkNotNull(
                checkoutUrl, r'CheckoutSessionResponse', 'checkoutUrl'),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CheckoutSessionResponse', 'sessionId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
