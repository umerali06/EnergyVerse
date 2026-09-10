// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_worker_acknowledgement_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitWorkerAcknowledgementResponse
    extends PermitWorkerAcknowledgementResponse {
  @override
  final String clientMutationId;
  @override
  final DateTime clientSignedAt;
  @override
  final String? deviceId;
  @override
  final String meaning;
  @override
  final DateTime receivedAt;
  @override
  final DateTime signedAt;
  @override
  final String workerId;

  factory _$PermitWorkerAcknowledgementResponse(
          [void Function(PermitWorkerAcknowledgementResponseBuilder)?
              updates]) =>
      (new PermitWorkerAcknowledgementResponseBuilder()..update(updates))
          ._build();

  _$PermitWorkerAcknowledgementResponse._(
      {required this.clientMutationId,
      required this.clientSignedAt,
      this.deviceId,
      required this.meaning,
      required this.receivedAt,
      required this.signedAt,
      required this.workerId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(clientMutationId,
        r'PermitWorkerAcknowledgementResponse', 'clientMutationId');
    BuiltValueNullFieldError.checkNotNull(clientSignedAt,
        r'PermitWorkerAcknowledgementResponse', 'clientSignedAt');
    BuiltValueNullFieldError.checkNotNull(
        meaning, r'PermitWorkerAcknowledgementResponse', 'meaning');
    BuiltValueNullFieldError.checkNotNull(
        receivedAt, r'PermitWorkerAcknowledgementResponse', 'receivedAt');
    BuiltValueNullFieldError.checkNotNull(
        signedAt, r'PermitWorkerAcknowledgementResponse', 'signedAt');
    BuiltValueNullFieldError.checkNotNull(
        workerId, r'PermitWorkerAcknowledgementResponse', 'workerId');
  }

  @override
  PermitWorkerAcknowledgementResponse rebuild(
          void Function(PermitWorkerAcknowledgementResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitWorkerAcknowledgementResponseBuilder toBuilder() =>
      new PermitWorkerAcknowledgementResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitWorkerAcknowledgementResponse &&
        clientMutationId == other.clientMutationId &&
        clientSignedAt == other.clientSignedAt &&
        deviceId == other.deviceId &&
        meaning == other.meaning &&
        receivedAt == other.receivedAt &&
        signedAt == other.signedAt &&
        workerId == other.workerId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientMutationId.hashCode);
    _$hash = $jc(_$hash, clientSignedAt.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, meaning.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, signedAt.hashCode);
    _$hash = $jc(_$hash, workerId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitWorkerAcknowledgementResponse')
          ..add('clientMutationId', clientMutationId)
          ..add('clientSignedAt', clientSignedAt)
          ..add('deviceId', deviceId)
          ..add('meaning', meaning)
          ..add('receivedAt', receivedAt)
          ..add('signedAt', signedAt)
          ..add('workerId', workerId))
        .toString();
  }
}

class PermitWorkerAcknowledgementResponseBuilder
    implements
        Builder<PermitWorkerAcknowledgementResponse,
            PermitWorkerAcknowledgementResponseBuilder> {
  _$PermitWorkerAcknowledgementResponse? _$v;

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

  String? _meaning;
  String? get meaning => _$this._meaning;
  set meaning(String? meaning) => _$this._meaning = meaning;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(DateTime? receivedAt) => _$this._receivedAt = receivedAt;

  DateTime? _signedAt;
  DateTime? get signedAt => _$this._signedAt;
  set signedAt(DateTime? signedAt) => _$this._signedAt = signedAt;

  String? _workerId;
  String? get workerId => _$this._workerId;
  set workerId(String? workerId) => _$this._workerId = workerId;

  PermitWorkerAcknowledgementResponseBuilder() {
    PermitWorkerAcknowledgementResponse._defaults(this);
  }

  PermitWorkerAcknowledgementResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientMutationId = $v.clientMutationId;
      _clientSignedAt = $v.clientSignedAt;
      _deviceId = $v.deviceId;
      _meaning = $v.meaning;
      _receivedAt = $v.receivedAt;
      _signedAt = $v.signedAt;
      _workerId = $v.workerId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitWorkerAcknowledgementResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitWorkerAcknowledgementResponse;
  }

  @override
  void update(
      void Function(PermitWorkerAcknowledgementResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitWorkerAcknowledgementResponse build() => _build();

  _$PermitWorkerAcknowledgementResponse _build() {
    final _$result = _$v ??
        new _$PermitWorkerAcknowledgementResponse._(
            clientMutationId: BuiltValueNullFieldError.checkNotNull(
                clientMutationId,
                r'PermitWorkerAcknowledgementResponse',
                'clientMutationId'),
            clientSignedAt: BuiltValueNullFieldError.checkNotNull(
                clientSignedAt,
                r'PermitWorkerAcknowledgementResponse',
                'clientSignedAt'),
            deviceId: deviceId,
            meaning: BuiltValueNullFieldError.checkNotNull(
                meaning, r'PermitWorkerAcknowledgementResponse', 'meaning'),
            receivedAt: BuiltValueNullFieldError.checkNotNull(
                receivedAt, r'PermitWorkerAcknowledgementResponse', 'receivedAt'),
            signedAt: BuiltValueNullFieldError.checkNotNull(
                signedAt, r'PermitWorkerAcknowledgementResponse', 'signedAt'),
            workerId: BuiltValueNullFieldError.checkNotNull(
                workerId, r'PermitWorkerAcknowledgementResponse', 'workerId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
