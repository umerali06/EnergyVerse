// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignatureResponse extends SignatureResponse {
  @override
  final int inspectionRevision;
  @override
  final DateTime signedAt;
  @override
  final String signerName;
  @override
  final String signerRole;
  @override
  final String signerUid;
  @override
  final BuiltList<SignatureStrokeResponse> strokes;

  factory _$SignatureResponse(
          [void Function(SignatureResponseBuilder)? updates]) =>
      (new SignatureResponseBuilder()..update(updates))._build();

  _$SignatureResponse._(
      {required this.inspectionRevision,
      required this.signedAt,
      required this.signerName,
      required this.signerRole,
      required this.signerUid,
      required this.strokes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        inspectionRevision, r'SignatureResponse', 'inspectionRevision');
    BuiltValueNullFieldError.checkNotNull(
        signedAt, r'SignatureResponse', 'signedAt');
    BuiltValueNullFieldError.checkNotNull(
        signerName, r'SignatureResponse', 'signerName');
    BuiltValueNullFieldError.checkNotNull(
        signerRole, r'SignatureResponse', 'signerRole');
    BuiltValueNullFieldError.checkNotNull(
        signerUid, r'SignatureResponse', 'signerUid');
    BuiltValueNullFieldError.checkNotNull(
        strokes, r'SignatureResponse', 'strokes');
  }

  @override
  SignatureResponse rebuild(void Function(SignatureResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignatureResponseBuilder toBuilder() =>
      new SignatureResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignatureResponse &&
        inspectionRevision == other.inspectionRevision &&
        signedAt == other.signedAt &&
        signerName == other.signerName &&
        signerRole == other.signerRole &&
        signerUid == other.signerUid &&
        strokes == other.strokes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inspectionRevision.hashCode);
    _$hash = $jc(_$hash, signedAt.hashCode);
    _$hash = $jc(_$hash, signerName.hashCode);
    _$hash = $jc(_$hash, signerRole.hashCode);
    _$hash = $jc(_$hash, signerUid.hashCode);
    _$hash = $jc(_$hash, strokes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignatureResponse')
          ..add('inspectionRevision', inspectionRevision)
          ..add('signedAt', signedAt)
          ..add('signerName', signerName)
          ..add('signerRole', signerRole)
          ..add('signerUid', signerUid)
          ..add('strokes', strokes))
        .toString();
  }
}

class SignatureResponseBuilder
    implements Builder<SignatureResponse, SignatureResponseBuilder> {
  _$SignatureResponse? _$v;

  int? _inspectionRevision;
  int? get inspectionRevision => _$this._inspectionRevision;
  set inspectionRevision(int? inspectionRevision) =>
      _$this._inspectionRevision = inspectionRevision;

  DateTime? _signedAt;
  DateTime? get signedAt => _$this._signedAt;
  set signedAt(DateTime? signedAt) => _$this._signedAt = signedAt;

  String? _signerName;
  String? get signerName => _$this._signerName;
  set signerName(String? signerName) => _$this._signerName = signerName;

  String? _signerRole;
  String? get signerRole => _$this._signerRole;
  set signerRole(String? signerRole) => _$this._signerRole = signerRole;

  String? _signerUid;
  String? get signerUid => _$this._signerUid;
  set signerUid(String? signerUid) => _$this._signerUid = signerUid;

  ListBuilder<SignatureStrokeResponse>? _strokes;
  ListBuilder<SignatureStrokeResponse> get strokes =>
      _$this._strokes ??= new ListBuilder<SignatureStrokeResponse>();
  set strokes(ListBuilder<SignatureStrokeResponse>? strokes) =>
      _$this._strokes = strokes;

  SignatureResponseBuilder() {
    SignatureResponse._defaults(this);
  }

  SignatureResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inspectionRevision = $v.inspectionRevision;
      _signedAt = $v.signedAt;
      _signerName = $v.signerName;
      _signerRole = $v.signerRole;
      _signerUid = $v.signerUid;
      _strokes = $v.strokes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignatureResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignatureResponse;
  }

  @override
  void update(void Function(SignatureResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignatureResponse build() => _build();

  _$SignatureResponse _build() {
    _$SignatureResponse _$result;
    try {
      _$result = _$v ??
          new _$SignatureResponse._(
              inspectionRevision: BuiltValueNullFieldError.checkNotNull(
                  inspectionRevision,
                  r'SignatureResponse',
                  'inspectionRevision'),
              signedAt: BuiltValueNullFieldError.checkNotNull(
                  signedAt, r'SignatureResponse', 'signedAt'),
              signerName: BuiltValueNullFieldError.checkNotNull(
                  signerName, r'SignatureResponse', 'signerName'),
              signerRole: BuiltValueNullFieldError.checkNotNull(
                  signerRole, r'SignatureResponse', 'signerRole'),
              signerUid: BuiltValueNullFieldError.checkNotNull(
                  signerUid, r'SignatureResponse', 'signerUid'),
              strokes: strokes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'strokes';
        strokes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SignatureResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
