// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_email_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerificationEmailResponse extends VerificationEmailResponse {
  @override
  final bool sent;

  factory _$VerificationEmailResponse(
          [void Function(VerificationEmailResponseBuilder)? updates]) =>
      (new VerificationEmailResponseBuilder()..update(updates))._build();

  _$VerificationEmailResponse._({required this.sent}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        sent, r'VerificationEmailResponse', 'sent');
  }

  @override
  VerificationEmailResponse rebuild(
          void Function(VerificationEmailResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerificationEmailResponseBuilder toBuilder() =>
      new VerificationEmailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerificationEmailResponse && sent == other.sent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerificationEmailResponse')
          ..add('sent', sent))
        .toString();
  }
}

class VerificationEmailResponseBuilder
    implements
        Builder<VerificationEmailResponse, VerificationEmailResponseBuilder> {
  _$VerificationEmailResponse? _$v;

  bool? _sent;
  bool? get sent => _$this._sent;
  set sent(bool? sent) => _$this._sent = sent;

  VerificationEmailResponseBuilder() {
    VerificationEmailResponse._defaults(this);
  }

  VerificationEmailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sent = $v.sent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerificationEmailResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VerificationEmailResponse;
  }

  @override
  void update(void Function(VerificationEmailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerificationEmailResponse build() => _build();

  _$VerificationEmailResponse _build() {
    final _$result = _$v ??
        new _$VerificationEmailResponse._(
            sent: BuiltValueNullFieldError.checkNotNull(
                sent, r'VerificationEmailResponse', 'sent'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
