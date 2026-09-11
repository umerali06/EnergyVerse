// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acknowledge_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AcknowledgePermitRequestWorkerAttestationEnum
    _$acknowledgePermitRequestWorkerAttestationEnum_true_ =
    const AcknowledgePermitRequestWorkerAttestationEnum._('true_');

AcknowledgePermitRequestWorkerAttestationEnum
    _$acknowledgePermitRequestWorkerAttestationEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$acknowledgePermitRequestWorkerAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AcknowledgePermitRequestWorkerAttestationEnum>
    _$acknowledgePermitRequestWorkerAttestationEnumValues = new BuiltSet<
        AcknowledgePermitRequestWorkerAttestationEnum>(const <AcknowledgePermitRequestWorkerAttestationEnum>[
  _$acknowledgePermitRequestWorkerAttestationEnum_true_,
]);

Serializer<AcknowledgePermitRequestWorkerAttestationEnum>
    _$acknowledgePermitRequestWorkerAttestationEnumSerializer =
    new _$AcknowledgePermitRequestWorkerAttestationEnumSerializer();

class _$AcknowledgePermitRequestWorkerAttestationEnumSerializer
    implements
        PrimitiveSerializer<AcknowledgePermitRequestWorkerAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AcknowledgePermitRequestWorkerAttestationEnum
  ];
  @override
  final String wireName = 'AcknowledgePermitRequestWorkerAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          AcknowledgePermitRequestWorkerAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AcknowledgePermitRequestWorkerAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AcknowledgePermitRequestWorkerAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AcknowledgePermitRequest extends AcknowledgePermitRequest {
  @override
  final String clientMutationId;
  @override
  final DateTime clientSignedAt;
  @override
  final String? deviceId;
  @override
  final int expectedRevision;
  @override
  final AcknowledgePermitRequestWorkerAttestationEnum workerAttestation;

  factory _$AcknowledgePermitRequest(
          [void Function(AcknowledgePermitRequestBuilder)? updates]) =>
      (new AcknowledgePermitRequestBuilder()..update(updates))._build();

  _$AcknowledgePermitRequest._(
      {required this.clientMutationId,
      required this.clientSignedAt,
      this.deviceId,
      required this.expectedRevision,
      required this.workerAttestation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        clientMutationId, r'AcknowledgePermitRequest', 'clientMutationId');
    BuiltValueNullFieldError.checkNotNull(
        clientSignedAt, r'AcknowledgePermitRequest', 'clientSignedAt');
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'AcknowledgePermitRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(
        workerAttestation, r'AcknowledgePermitRequest', 'workerAttestation');
  }

  @override
  AcknowledgePermitRequest rebuild(
          void Function(AcknowledgePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcknowledgePermitRequestBuilder toBuilder() =>
      new AcknowledgePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcknowledgePermitRequest &&
        clientMutationId == other.clientMutationId &&
        clientSignedAt == other.clientSignedAt &&
        deviceId == other.deviceId &&
        expectedRevision == other.expectedRevision &&
        workerAttestation == other.workerAttestation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientMutationId.hashCode);
    _$hash = $jc(_$hash, clientSignedAt.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, workerAttestation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AcknowledgePermitRequest')
          ..add('clientMutationId', clientMutationId)
          ..add('clientSignedAt', clientSignedAt)
          ..add('deviceId', deviceId)
          ..add('expectedRevision', expectedRevision)
          ..add('workerAttestation', workerAttestation))
        .toString();
  }
}

class AcknowledgePermitRequestBuilder
    implements
        Builder<AcknowledgePermitRequest, AcknowledgePermitRequestBuilder> {
  _$AcknowledgePermitRequest? _$v;

  String? _clientMutationId;
  String? get clientMutationId => _$this._clientMutationId;
  set clientMutationId(String? clientMutationId) =>
      _$this._clientMutationId = clientMutationId;

  DateTime? _clientSignedAt;
  DateTime? get clientSignedAt => _$this._clientSignedAt;
  set clientSignedAt(DateTime? clientSignedAt) =>
      _$this._clientSignedAt = clientSignedAt;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  AcknowledgePermitRequestWorkerAttestationEnum? _workerAttestation;
  AcknowledgePermitRequestWorkerAttestationEnum? get workerAttestation =>
      _$this._workerAttestation;
  set workerAttestation(
          AcknowledgePermitRequestWorkerAttestationEnum? workerAttestation) =>
      _$this._workerAttestation = workerAttestation;

  AcknowledgePermitRequestBuilder() {
    AcknowledgePermitRequest._defaults(this);
  }

  AcknowledgePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientMutationId = $v.clientMutationId;
      _clientSignedAt = $v.clientSignedAt;
      _deviceId = $v.deviceId;
      _expectedRevision = $v.expectedRevision;
      _workerAttestation = $v.workerAttestation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcknowledgePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AcknowledgePermitRequest;
  }

  @override
  void update(void Function(AcknowledgePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AcknowledgePermitRequest build() => _build();

  _$AcknowledgePermitRequest _build() {
    final _$result = _$v ??
        new _$AcknowledgePermitRequest._(
            clientMutationId: BuiltValueNullFieldError.checkNotNull(
                clientMutationId,
                r'AcknowledgePermitRequest',
                'clientMutationId'),
            clientSignedAt: BuiltValueNullFieldError.checkNotNull(
                clientSignedAt, r'AcknowledgePermitRequest', 'clientSignedAt'),
            deviceId: deviceId,
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision,
                r'AcknowledgePermitRequest',
                'expectedRevision'),
            workerAttestation: BuiltValueNullFieldError.checkNotNull(
                workerAttestation,
                r'AcknowledgePermitRequest',
                'workerAttestation'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
