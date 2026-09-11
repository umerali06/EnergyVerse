// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ResumePermitRequestResumeAttestationEnum
    _$resumePermitRequestResumeAttestationEnum_true_ =
    const ResumePermitRequestResumeAttestationEnum._('true_');

ResumePermitRequestResumeAttestationEnum
    _$resumePermitRequestResumeAttestationEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$resumePermitRequestResumeAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ResumePermitRequestResumeAttestationEnum>
    _$resumePermitRequestResumeAttestationEnumValues = new BuiltSet<
        ResumePermitRequestResumeAttestationEnum>(const <ResumePermitRequestResumeAttestationEnum>[
  _$resumePermitRequestResumeAttestationEnum_true_,
]);

Serializer<ResumePermitRequestResumeAttestationEnum>
    _$resumePermitRequestResumeAttestationEnumSerializer =
    new _$ResumePermitRequestResumeAttestationEnumSerializer();

class _$ResumePermitRequestResumeAttestationEnumSerializer
    implements PrimitiveSerializer<ResumePermitRequestResumeAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ResumePermitRequestResumeAttestationEnum
  ];
  @override
  final String wireName = 'ResumePermitRequestResumeAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          ResumePermitRequestResumeAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ResumePermitRequestResumeAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ResumePermitRequestResumeAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ResumePermitRequest extends ResumePermitRequest {
  @override
  final int expectedRevision;
  @override
  final ResumePermitRequestResumeAttestationEnum resumeAttestation;

  factory _$ResumePermitRequest(
          [void Function(ResumePermitRequestBuilder)? updates]) =>
      (new ResumePermitRequestBuilder()..update(updates))._build();

  _$ResumePermitRequest._(
      {required this.expectedRevision, required this.resumeAttestation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'ResumePermitRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(
        resumeAttestation, r'ResumePermitRequest', 'resumeAttestation');
  }

  @override
  ResumePermitRequest rebuild(
          void Function(ResumePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResumePermitRequestBuilder toBuilder() =>
      new ResumePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResumePermitRequest &&
        expectedRevision == other.expectedRevision &&
        resumeAttestation == other.resumeAttestation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, resumeAttestation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResumePermitRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('resumeAttestation', resumeAttestation))
        .toString();
  }
}

class ResumePermitRequestBuilder
    implements Builder<ResumePermitRequest, ResumePermitRequestBuilder> {
  _$ResumePermitRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ResumePermitRequestResumeAttestationEnum? _resumeAttestation;
  ResumePermitRequestResumeAttestationEnum? get resumeAttestation =>
      _$this._resumeAttestation;
  set resumeAttestation(
          ResumePermitRequestResumeAttestationEnum? resumeAttestation) =>
      _$this._resumeAttestation = resumeAttestation;

  ResumePermitRequestBuilder() {
    ResumePermitRequest._defaults(this);
  }

  ResumePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _resumeAttestation = $v.resumeAttestation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResumePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ResumePermitRequest;
  }

  @override
  void update(void Function(ResumePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResumePermitRequest build() => _build();

  _$ResumePermitRequest _build() {
    final _$result = _$v ??
        new _$ResumePermitRequest._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision, r'ResumePermitRequest', 'expectedRevision'),
            resumeAttestation: BuiltValueNullFieldError.checkNotNull(
                resumeAttestation,
                r'ResumePermitRequest',
                'resumeAttestation'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
