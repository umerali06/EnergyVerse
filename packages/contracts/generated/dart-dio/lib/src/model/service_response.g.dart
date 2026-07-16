// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ServiceResponseServiceEnum _$serviceResponseServiceEnum_fevApi =
    const ServiceResponseServiceEnum._('fevApi');

ServiceResponseServiceEnum _$serviceResponseServiceEnumValueOf(String name) {
  switch (name) {
    case 'fevApi':
      return _$serviceResponseServiceEnum_fevApi;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ServiceResponseServiceEnum> _$serviceResponseServiceEnumValues =
    new BuiltSet<ServiceResponseServiceEnum>(const <ServiceResponseServiceEnum>[
  _$serviceResponseServiceEnum_fevApi,
]);

const ServiceResponseStatusEnum _$serviceResponseStatusEnum_ok =
    const ServiceResponseStatusEnum._('ok');

ServiceResponseStatusEnum _$serviceResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$serviceResponseStatusEnum_ok;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ServiceResponseStatusEnum> _$serviceResponseStatusEnumValues =
    new BuiltSet<ServiceResponseStatusEnum>(const <ServiceResponseStatusEnum>[
  _$serviceResponseStatusEnum_ok,
]);

Serializer<ServiceResponseServiceEnum> _$serviceResponseServiceEnumSerializer =
    new _$ServiceResponseServiceEnumSerializer();
Serializer<ServiceResponseStatusEnum> _$serviceResponseStatusEnumSerializer =
    new _$ServiceResponseStatusEnumSerializer();

class _$ServiceResponseServiceEnumSerializer
    implements PrimitiveSerializer<ServiceResponseServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fevApi': 'fev-api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fev-api': 'fevApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ServiceResponseServiceEnum];
  @override
  final String wireName = 'ServiceResponseServiceEnum';

  @override
  Object serialize(Serializers serializers, ServiceResponseServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ServiceResponseServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ServiceResponseServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ServiceResponseStatusEnumSerializer
    implements PrimitiveSerializer<ServiceResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[ServiceResponseStatusEnum];
  @override
  final String wireName = 'ServiceResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, ServiceResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ServiceResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ServiceResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ServiceResponse extends ServiceResponse {
  @override
  final ServiceResponseServiceEnum service;
  @override
  final ServiceResponseStatusEnum status;

  factory _$ServiceResponse([void Function(ServiceResponseBuilder)? updates]) =>
      (new ServiceResponseBuilder()..update(updates))._build();

  _$ServiceResponse._({required this.service, required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        service, r'ServiceResponse', 'service');
    BuiltValueNullFieldError.checkNotNull(status, r'ServiceResponse', 'status');
  }

  @override
  ServiceResponse rebuild(void Function(ServiceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ServiceResponseBuilder toBuilder() =>
      new ServiceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServiceResponse &&
        service == other.service &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, service.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ServiceResponse')
          ..add('service', service)
          ..add('status', status))
        .toString();
  }
}

class ServiceResponseBuilder
    implements Builder<ServiceResponse, ServiceResponseBuilder> {
  _$ServiceResponse? _$v;

  ServiceResponseServiceEnum? _service;
  ServiceResponseServiceEnum? get service => _$this._service;
  set service(ServiceResponseServiceEnum? service) => _$this._service = service;

  ServiceResponseStatusEnum? _status;
  ServiceResponseStatusEnum? get status => _$this._status;
  set status(ServiceResponseStatusEnum? status) => _$this._status = status;

  ServiceResponseBuilder() {
    ServiceResponse._defaults(this);
  }

  ServiceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _service = $v.service;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ServiceResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ServiceResponse;
  }

  @override
  void update(void Function(ServiceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ServiceResponse build() => _build();

  _$ServiceResponse _build() {
    final _$result = _$v ??
        new _$ServiceResponse._(
            service: BuiltValueNullFieldError.checkNotNull(
                service, r'ServiceResponse', 'service'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ServiceResponse', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
