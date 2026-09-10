// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_corrective_action_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancelCorrectiveActionRequest extends CancelCorrectiveActionRequest {
  @override
  final String reason;

  factory _$CancelCorrectiveActionRequest(
          [void Function(CancelCorrectiveActionRequestBuilder)? updates]) =>
      (new CancelCorrectiveActionRequestBuilder()..update(updates))._build();

  _$CancelCorrectiveActionRequest._({required this.reason}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        reason, r'CancelCorrectiveActionRequest', 'reason');
  }

  @override
  CancelCorrectiveActionRequest rebuild(
          void Function(CancelCorrectiveActionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancelCorrectiveActionRequestBuilder toBuilder() =>
      new CancelCorrectiveActionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancelCorrectiveActionRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancelCorrectiveActionRequest')
          ..add('reason', reason))
        .toString();
  }
}

class CancelCorrectiveActionRequestBuilder
    implements
        Builder<CancelCorrectiveActionRequest,
            CancelCorrectiveActionRequestBuilder> {
  _$CancelCorrectiveActionRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CancelCorrectiveActionRequestBuilder() {
    CancelCorrectiveActionRequest._defaults(this);
  }

  CancelCorrectiveActionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancelCorrectiveActionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CancelCorrectiveActionRequest;
  }

  @override
  void update(void Function(CancelCorrectiveActionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancelCorrectiveActionRequest build() => _build();

  _$CancelCorrectiveActionRequest _build() {
    final _$result = _$v ??
        new _$CancelCorrectiveActionRequest._(
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'CancelCorrectiveActionRequest', 'reason'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
