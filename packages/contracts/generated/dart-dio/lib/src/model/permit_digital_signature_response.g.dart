// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_digital_signature_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitDigitalSignatureResponse extends PermitDigitalSignatureResponse {
  @override
  final String meaning;
  @override
  final DateTime signedAt;
  @override
  final String signerId;

  factory _$PermitDigitalSignatureResponse(
          [void Function(PermitDigitalSignatureResponseBuilder)? updates]) =>
      (new PermitDigitalSignatureResponseBuilder()..update(updates))._build();

  _$PermitDigitalSignatureResponse._(
      {required this.meaning, required this.signedAt, required this.signerId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        meaning, r'PermitDigitalSignatureResponse', 'meaning');
    BuiltValueNullFieldError.checkNotNull(
        signedAt, r'PermitDigitalSignatureResponse', 'signedAt');
    BuiltValueNullFieldError.checkNotNull(
        signerId, r'PermitDigitalSignatureResponse', 'signerId');
  }

  @override
  PermitDigitalSignatureResponse rebuild(
          void Function(PermitDigitalSignatureResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitDigitalSignatureResponseBuilder toBuilder() =>
      new PermitDigitalSignatureResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitDigitalSignatureResponse &&
        meaning == other.meaning &&
        signedAt == other.signedAt &&
        signerId == other.signerId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meaning.hashCode);
    _$hash = $jc(_$hash, signedAt.hashCode);
    _$hash = $jc(_$hash, signerId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitDigitalSignatureResponse')
          ..add('meaning', meaning)
          ..add('signedAt', signedAt)
          ..add('signerId', signerId))
        .toString();
  }
}

class PermitDigitalSignatureResponseBuilder
    implements
        Builder<PermitDigitalSignatureResponse,
            PermitDigitalSignatureResponseBuilder> {
  _$PermitDigitalSignatureResponse? _$v;

  String? _meaning;
  String? get meaning => _$this._meaning;
  set meaning(String? meaning) => _$this._meaning = meaning;

  DateTime? _signedAt;
  DateTime? get signedAt => _$this._signedAt;
  set signedAt(DateTime? signedAt) => _$this._signedAt = signedAt;

  String? _signerId;
  String? get signerId => _$this._signerId;
  set signerId(String? signerId) => _$this._signerId = signerId;

  PermitDigitalSignatureResponseBuilder() {
    PermitDigitalSignatureResponse._defaults(this);
  }

  PermitDigitalSignatureResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meaning = $v.meaning;
      _signedAt = $v.signedAt;
      _signerId = $v.signerId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitDigitalSignatureResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitDigitalSignatureResponse;
  }

  @override
  void update(void Function(PermitDigitalSignatureResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitDigitalSignatureResponse build() => _build();

  _$PermitDigitalSignatureResponse _build() {
    final _$result = _$v ??
        new _$PermitDigitalSignatureResponse._(
            meaning: BuiltValueNullFieldError.checkNotNull(
                meaning, r'PermitDigitalSignatureResponse', 'meaning'),
            signedAt: BuiltValueNullFieldError.checkNotNull(
                signedAt, r'PermitDigitalSignatureResponse', 'signedAt'),
            signerId: BuiltValueNullFieldError.checkNotNull(
                signerId, r'PermitDigitalSignatureResponse', 'signerId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
