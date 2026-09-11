// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SubmitPermitRequestIssuerAttestationEnum
    _$submitPermitRequestIssuerAttestationEnum_true_ =
    const SubmitPermitRequestIssuerAttestationEnum._('true_');

SubmitPermitRequestIssuerAttestationEnum
    _$submitPermitRequestIssuerAttestationEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$submitPermitRequestIssuerAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<SubmitPermitRequestIssuerAttestationEnum>
    _$submitPermitRequestIssuerAttestationEnumValues = new BuiltSet<
        SubmitPermitRequestIssuerAttestationEnum>(const <SubmitPermitRequestIssuerAttestationEnum>[
  _$submitPermitRequestIssuerAttestationEnum_true_,
]);

Serializer<SubmitPermitRequestIssuerAttestationEnum>
    _$submitPermitRequestIssuerAttestationEnumSerializer =
    new _$SubmitPermitRequestIssuerAttestationEnumSerializer();

class _$SubmitPermitRequestIssuerAttestationEnumSerializer
    implements PrimitiveSerializer<SubmitPermitRequestIssuerAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SubmitPermitRequestIssuerAttestationEnum
  ];
  @override
  final String wireName = 'SubmitPermitRequestIssuerAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          SubmitPermitRequestIssuerAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SubmitPermitRequestIssuerAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SubmitPermitRequestIssuerAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SubmitPermitRequest extends SubmitPermitRequest {
  @override
  final BuiltList<String> completedChecklistItemIds;
  @override
  final int expectedRevision;
  @override
  final SubmitPermitRequestIssuerAttestationEnum issuerAttestation;

  factory _$SubmitPermitRequest(
          [void Function(SubmitPermitRequestBuilder)? updates]) =>
      (new SubmitPermitRequestBuilder()..update(updates))._build();

  _$SubmitPermitRequest._(
      {required this.completedChecklistItemIds,
      required this.expectedRevision,
      required this.issuerAttestation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(completedChecklistItemIds,
        r'SubmitPermitRequest', 'completedChecklistItemIds');
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'SubmitPermitRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(
        issuerAttestation, r'SubmitPermitRequest', 'issuerAttestation');
  }

  @override
  SubmitPermitRequest rebuild(
          void Function(SubmitPermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubmitPermitRequestBuilder toBuilder() =>
      new SubmitPermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitPermitRequest &&
        completedChecklistItemIds == other.completedChecklistItemIds &&
        expectedRevision == other.expectedRevision &&
        issuerAttestation == other.issuerAttestation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completedChecklistItemIds.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, issuerAttestation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitPermitRequest')
          ..add('completedChecklistItemIds', completedChecklistItemIds)
          ..add('expectedRevision', expectedRevision)
          ..add('issuerAttestation', issuerAttestation))
        .toString();
  }
}

class SubmitPermitRequestBuilder
    implements Builder<SubmitPermitRequest, SubmitPermitRequestBuilder> {
  _$SubmitPermitRequest? _$v;

  ListBuilder<String>? _completedChecklistItemIds;
  ListBuilder<String> get completedChecklistItemIds =>
      _$this._completedChecklistItemIds ??= new ListBuilder<String>();
  set completedChecklistItemIds(
          ListBuilder<String>? completedChecklistItemIds) =>
      _$this._completedChecklistItemIds = completedChecklistItemIds;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  SubmitPermitRequestIssuerAttestationEnum? _issuerAttestation;
  SubmitPermitRequestIssuerAttestationEnum? get issuerAttestation =>
      _$this._issuerAttestation;
  set issuerAttestation(
          SubmitPermitRequestIssuerAttestationEnum? issuerAttestation) =>
      _$this._issuerAttestation = issuerAttestation;

  SubmitPermitRequestBuilder() {
    SubmitPermitRequest._defaults(this);
  }

  SubmitPermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completedChecklistItemIds = $v.completedChecklistItemIds.toBuilder();
      _expectedRevision = $v.expectedRevision;
      _issuerAttestation = $v.issuerAttestation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitPermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubmitPermitRequest;
  }

  @override
  void update(void Function(SubmitPermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitPermitRequest build() => _build();

  _$SubmitPermitRequest _build() {
    _$SubmitPermitRequest _$result;
    try {
      _$result = _$v ??
          new _$SubmitPermitRequest._(
              completedChecklistItemIds: completedChecklistItemIds.build(),
              expectedRevision: BuiltValueNullFieldError.checkNotNull(
                  expectedRevision, r'SubmitPermitRequest', 'expectedRevision'),
              issuerAttestation: BuiltValueNullFieldError.checkNotNull(
                  issuerAttestation,
                  r'SubmitPermitRequest',
                  'issuerAttestation'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'completedChecklistItemIds';
        completedChecklistItemIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SubmitPermitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
