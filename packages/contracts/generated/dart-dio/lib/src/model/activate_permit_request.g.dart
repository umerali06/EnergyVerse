// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activate_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ActivatePermitRequestActivationAttestationEnum
    _$activatePermitRequestActivationAttestationEnum_true_ =
    const ActivatePermitRequestActivationAttestationEnum._('true_');

ActivatePermitRequestActivationAttestationEnum
    _$activatePermitRequestActivationAttestationEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$activatePermitRequestActivationAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ActivatePermitRequestActivationAttestationEnum>
    _$activatePermitRequestActivationAttestationEnumValues = new BuiltSet<
        ActivatePermitRequestActivationAttestationEnum>(const <ActivatePermitRequestActivationAttestationEnum>[
  _$activatePermitRequestActivationAttestationEnum_true_,
]);

Serializer<ActivatePermitRequestActivationAttestationEnum>
    _$activatePermitRequestActivationAttestationEnumSerializer =
    new _$ActivatePermitRequestActivationAttestationEnumSerializer();

class _$ActivatePermitRequestActivationAttestationEnumSerializer
    implements
        PrimitiveSerializer<ActivatePermitRequestActivationAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ActivatePermitRequestActivationAttestationEnum
  ];
  @override
  final String wireName = 'ActivatePermitRequestActivationAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          ActivatePermitRequestActivationAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ActivatePermitRequestActivationAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ActivatePermitRequestActivationAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ActivatePermitRequest extends ActivatePermitRequest {
  @override
  final ActivatePermitRequestActivationAttestationEnum activationAttestation;
  @override
  final int expectedRevision;

  factory _$ActivatePermitRequest(
          [void Function(ActivatePermitRequestBuilder)? updates]) =>
      (new ActivatePermitRequestBuilder()..update(updates))._build();

  _$ActivatePermitRequest._(
      {required this.activationAttestation, required this.expectedRevision})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(activationAttestation,
        r'ActivatePermitRequest', 'activationAttestation');
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'ActivatePermitRequest', 'expectedRevision');
  }

  @override
  ActivatePermitRequest rebuild(
          void Function(ActivatePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ActivatePermitRequestBuilder toBuilder() =>
      new ActivatePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ActivatePermitRequest &&
        activationAttestation == other.activationAttestation &&
        expectedRevision == other.expectedRevision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activationAttestation.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ActivatePermitRequest')
          ..add('activationAttestation', activationAttestation)
          ..add('expectedRevision', expectedRevision))
        .toString();
  }
}

class ActivatePermitRequestBuilder
    implements Builder<ActivatePermitRequest, ActivatePermitRequestBuilder> {
  _$ActivatePermitRequest? _$v;

  ActivatePermitRequestActivationAttestationEnum? _activationAttestation;
  ActivatePermitRequestActivationAttestationEnum? get activationAttestation =>
      _$this._activationAttestation;
  set activationAttestation(
          ActivatePermitRequestActivationAttestationEnum?
              activationAttestation) =>
      _$this._activationAttestation = activationAttestation;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ActivatePermitRequestBuilder() {
    ActivatePermitRequest._defaults(this);
  }

  ActivatePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activationAttestation = $v.activationAttestation;
      _expectedRevision = $v.expectedRevision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ActivatePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ActivatePermitRequest;
  }

  @override
  void update(void Function(ActivatePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ActivatePermitRequest build() => _build();

  _$ActivatePermitRequest _build() {
    final _$result = _$v ??
        new _$ActivatePermitRequest._(
            activationAttestation: BuiltValueNullFieldError.checkNotNull(
                activationAttestation,
                r'ActivatePermitRequest',
                'activationAttestation'),
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision,
                r'ActivatePermitRequest',
                'expectedRevision'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
