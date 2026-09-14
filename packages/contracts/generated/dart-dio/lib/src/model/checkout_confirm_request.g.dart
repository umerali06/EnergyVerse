// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_confirm_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutConfirmRequest extends CheckoutConfirmRequest {
  @override
  final String sessionId;

  factory _$CheckoutConfirmRequest(
          [void Function(CheckoutConfirmRequestBuilder)? updates]) =>
      (new CheckoutConfirmRequestBuilder()..update(updates))._build();

  _$CheckoutConfirmRequest._({required this.sessionId}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        sessionId, r'CheckoutConfirmRequest', 'sessionId');
  }

  @override
  CheckoutConfirmRequest rebuild(
          void Function(CheckoutConfirmRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutConfirmRequestBuilder toBuilder() =>
      new CheckoutConfirmRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutConfirmRequest && sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutConfirmRequest')
          ..add('sessionId', sessionId))
        .toString();
  }
}

class CheckoutConfirmRequestBuilder
    implements Builder<CheckoutConfirmRequest, CheckoutConfirmRequestBuilder> {
  _$CheckoutConfirmRequest? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  CheckoutConfirmRequestBuilder() {
    CheckoutConfirmRequest._defaults(this);
  }

  CheckoutConfirmRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutConfirmRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CheckoutConfirmRequest;
  }

  @override
  void update(void Function(CheckoutConfirmRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutConfirmRequest build() => _build();

  _$CheckoutConfirmRequest _build() {
    final _$result = _$v ??
        new _$CheckoutConfirmRequest._(
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CheckoutConfirmRequest', 'sessionId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
