// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HealthResponseFirestoreEnum _$healthResponseFirestoreEnum_connected =
    const HealthResponseFirestoreEnum._('connected');
const HealthResponseFirestoreEnum _$healthResponseFirestoreEnum_unavailable =
    const HealthResponseFirestoreEnum._('unavailable');
const HealthResponseFirestoreEnum _$healthResponseFirestoreEnum_unconfigured =
    const HealthResponseFirestoreEnum._('unconfigured');

HealthResponseFirestoreEnum _$healthResponseFirestoreEnumValueOf(String name) {
  switch (name) {
    case 'connected':
      return _$healthResponseFirestoreEnum_connected;
    case 'unavailable':
      return _$healthResponseFirestoreEnum_unavailable;
    case 'unconfigured':
      return _$healthResponseFirestoreEnum_unconfigured;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<HealthResponseFirestoreEnum>
    _$healthResponseFirestoreEnumValues = new BuiltSet<
        HealthResponseFirestoreEnum>(const <HealthResponseFirestoreEnum>[
  _$healthResponseFirestoreEnum_connected,
  _$healthResponseFirestoreEnum_unavailable,
  _$healthResponseFirestoreEnum_unconfigured,
]);

const HealthResponseServiceEnum _$healthResponseServiceEnum_fevApi =
    const HealthResponseServiceEnum._('fevApi');

HealthResponseServiceEnum _$healthResponseServiceEnumValueOf(String name) {
  switch (name) {
    case 'fevApi':
      return _$healthResponseServiceEnum_fevApi;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<HealthResponseServiceEnum> _$healthResponseServiceEnumValues =
    new BuiltSet<HealthResponseServiceEnum>(const <HealthResponseServiceEnum>[
  _$healthResponseServiceEnum_fevApi,
]);

const HealthResponseStatusEnum _$healthResponseStatusEnum_ok =
    const HealthResponseStatusEnum._('ok');

HealthResponseStatusEnum _$healthResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$healthResponseStatusEnum_ok;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<HealthResponseStatusEnum> _$healthResponseStatusEnumValues =
    new BuiltSet<HealthResponseStatusEnum>(const <HealthResponseStatusEnum>[
  _$healthResponseStatusEnum_ok,
]);

Serializer<HealthResponseFirestoreEnum>
    _$healthResponseFirestoreEnumSerializer =
    new _$HealthResponseFirestoreEnumSerializer();
Serializer<HealthResponseServiceEnum> _$healthResponseServiceEnumSerializer =
    new _$HealthResponseServiceEnumSerializer();
Serializer<HealthResponseStatusEnum> _$healthResponseStatusEnumSerializer =
    new _$HealthResponseStatusEnumSerializer();

class _$HealthResponseFirestoreEnumSerializer
    implements PrimitiveSerializer<HealthResponseFirestoreEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'connected': 'connected',
    'unavailable': 'unavailable',
    'unconfigured': 'unconfigured',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'connected': 'connected',
    'unavailable': 'unavailable',
    'unconfigured': 'unconfigured',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthResponseFirestoreEnum];
  @override
  final String wireName = 'HealthResponseFirestoreEnum';

  @override
  Object serialize(Serializers serializers, HealthResponseFirestoreEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthResponseFirestoreEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthResponseFirestoreEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthResponseServiceEnumSerializer
    implements PrimitiveSerializer<HealthResponseServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fevApi': 'fev-api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fev-api': 'fevApi',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthResponseServiceEnum];
  @override
  final String wireName = 'HealthResponseServiceEnum';

  @override
  Object serialize(Serializers serializers, HealthResponseServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthResponseServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthResponseServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthResponseStatusEnumSerializer
    implements PrimitiveSerializer<HealthResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthResponseStatusEnum];
  @override
  final String wireName = 'HealthResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, HealthResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthResponse extends HealthResponse {
  @override
  final HealthResponseFirestoreEnum firestore;
  @override
  final HealthResponseServiceEnum service;
  @override
  final HealthResponseStatusEnum status;
  @override
  final DateTime timestamp;

  factory _$HealthResponse([void Function(HealthResponseBuilder)? updates]) =>
      (new HealthResponseBuilder()..update(updates))._build();

  _$HealthResponse._(
      {required this.firestore,
      required this.service,
      required this.status,
      required this.timestamp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestore, r'HealthResponse', 'firestore');
    BuiltValueNullFieldError.checkNotNull(
        service, r'HealthResponse', 'service');
    BuiltValueNullFieldError.checkNotNull(status, r'HealthResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(
        timestamp, r'HealthResponse', 'timestamp');
  }

  @override
  HealthResponse rebuild(void Function(HealthResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthResponseBuilder toBuilder() =>
      new HealthResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthResponse &&
        firestore == other.firestore &&
        service == other.service &&
        status == other.status &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firestore.hashCode);
    _$hash = $jc(_$hash, service.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthResponse')
          ..add('firestore', firestore)
          ..add('service', service)
          ..add('status', status)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class HealthResponseBuilder
    implements Builder<HealthResponse, HealthResponseBuilder> {
  _$HealthResponse? _$v;

  HealthResponseFirestoreEnum? _firestore;
  HealthResponseFirestoreEnum? get firestore => _$this._firestore;
  set firestore(HealthResponseFirestoreEnum? firestore) =>
      _$this._firestore = firestore;

  HealthResponseServiceEnum? _service;
  HealthResponseServiceEnum? get service => _$this._service;
  set service(HealthResponseServiceEnum? service) => _$this._service = service;

  HealthResponseStatusEnum? _status;
  HealthResponseStatusEnum? get status => _$this._status;
  set status(HealthResponseStatusEnum? status) => _$this._status = status;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  HealthResponseBuilder() {
    HealthResponse._defaults(this);
  }

  HealthResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firestore = $v.firestore;
      _service = $v.service;
      _status = $v.status;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HealthResponse;
  }

  @override
  void update(void Function(HealthResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthResponse build() => _build();

  _$HealthResponse _build() {
    final _$result = _$v ??
        new _$HealthResponse._(
            firestore: BuiltValueNullFieldError.checkNotNull(
                firestore, r'HealthResponse', 'firestore'),
            service: BuiltValueNullFieldError.checkNotNull(
                service, r'HealthResponse', 'service'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'HealthResponse', 'status'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'HealthResponse', 'timestamp'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
