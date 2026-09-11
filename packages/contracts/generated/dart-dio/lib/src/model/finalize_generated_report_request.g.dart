// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finalize_generated_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinalizeGeneratedReportRequestFinalizationAttestationEnum
    _$finalizeGeneratedReportRequestFinalizationAttestationEnum_true_ =
    const FinalizeGeneratedReportRequestFinalizationAttestationEnum._('true_');

FinalizeGeneratedReportRequestFinalizationAttestationEnum
    _$finalizeGeneratedReportRequestFinalizationAttestationEnumValueOf(
        String name) {
  switch (name) {
    case 'true_':
      return _$finalizeGeneratedReportRequestFinalizationAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<FinalizeGeneratedReportRequestFinalizationAttestationEnum>
    _$finalizeGeneratedReportRequestFinalizationAttestationEnumValues =
    new BuiltSet<
        FinalizeGeneratedReportRequestFinalizationAttestationEnum>(const <FinalizeGeneratedReportRequestFinalizationAttestationEnum>[
  _$finalizeGeneratedReportRequestFinalizationAttestationEnum_true_,
]);

Serializer<FinalizeGeneratedReportRequestFinalizationAttestationEnum>
    _$finalizeGeneratedReportRequestFinalizationAttestationEnumSerializer =
    new _$FinalizeGeneratedReportRequestFinalizationAttestationEnumSerializer();

class _$FinalizeGeneratedReportRequestFinalizationAttestationEnumSerializer
    implements
        PrimitiveSerializer<
            FinalizeGeneratedReportRequestFinalizationAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FinalizeGeneratedReportRequestFinalizationAttestationEnum
  ];
  @override
  final String wireName =
      'FinalizeGeneratedReportRequestFinalizationAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          FinalizeGeneratedReportRequestFinalizationAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinalizeGeneratedReportRequestFinalizationAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinalizeGeneratedReportRequestFinalizationAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinalizeGeneratedReportRequest extends FinalizeGeneratedReportRequest {
  @override
  final int expectedRevision;
  @override
  final FinalizeGeneratedReportRequestFinalizationAttestationEnum
      finalizationAttestation;

  factory _$FinalizeGeneratedReportRequest(
          [void Function(FinalizeGeneratedReportRequestBuilder)? updates]) =>
      (new FinalizeGeneratedReportRequestBuilder()..update(updates))._build();

  _$FinalizeGeneratedReportRequest._(
      {required this.expectedRevision, required this.finalizationAttestation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(expectedRevision,
        r'FinalizeGeneratedReportRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(finalizationAttestation,
        r'FinalizeGeneratedReportRequest', 'finalizationAttestation');
  }

  @override
  FinalizeGeneratedReportRequest rebuild(
          void Function(FinalizeGeneratedReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinalizeGeneratedReportRequestBuilder toBuilder() =>
      new FinalizeGeneratedReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinalizeGeneratedReportRequest &&
        expectedRevision == other.expectedRevision &&
        finalizationAttestation == other.finalizationAttestation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, finalizationAttestation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinalizeGeneratedReportRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('finalizationAttestation', finalizationAttestation))
        .toString();
  }
}

class FinalizeGeneratedReportRequestBuilder
    implements
        Builder<FinalizeGeneratedReportRequest,
            FinalizeGeneratedReportRequestBuilder> {
  _$FinalizeGeneratedReportRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  FinalizeGeneratedReportRequestFinalizationAttestationEnum?
      _finalizationAttestation;
  FinalizeGeneratedReportRequestFinalizationAttestationEnum?
      get finalizationAttestation => _$this._finalizationAttestation;
  set finalizationAttestation(
          FinalizeGeneratedReportRequestFinalizationAttestationEnum?
              finalizationAttestation) =>
      _$this._finalizationAttestation = finalizationAttestation;

  FinalizeGeneratedReportRequestBuilder() {
    FinalizeGeneratedReportRequest._defaults(this);
  }

  FinalizeGeneratedReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _finalizationAttestation = $v.finalizationAttestation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinalizeGeneratedReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FinalizeGeneratedReportRequest;
  }

  @override
  void update(void Function(FinalizeGeneratedReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinalizeGeneratedReportRequest build() => _build();

  _$FinalizeGeneratedReportRequest _build() {
    final _$result = _$v ??
        new _$FinalizeGeneratedReportRequest._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision,
                r'FinalizeGeneratedReportRequest',
                'expectedRevision'),
            finalizationAttestation: BuiltValueNullFieldError.checkNotNull(
                finalizationAttestation,
                r'FinalizeGeneratedReportRequest',
                'finalizationAttestation'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
