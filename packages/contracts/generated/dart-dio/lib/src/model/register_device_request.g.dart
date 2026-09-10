// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterDeviceRequestPlatformEnum
    _$registerDeviceRequestPlatformEnum_android =
    const RegisterDeviceRequestPlatformEnum._('android');
const RegisterDeviceRequestPlatformEnum
    _$registerDeviceRequestPlatformEnum_ios =
    const RegisterDeviceRequestPlatformEnum._('ios');
const RegisterDeviceRequestPlatformEnum
    _$registerDeviceRequestPlatformEnum_web =
    const RegisterDeviceRequestPlatformEnum._('web');

RegisterDeviceRequestPlatformEnum _$registerDeviceRequestPlatformEnumValueOf(
    String name) {
  switch (name) {
    case 'android':
      return _$registerDeviceRequestPlatformEnum_android;
    case 'ios':
      return _$registerDeviceRequestPlatformEnum_ios;
    case 'web':
      return _$registerDeviceRequestPlatformEnum_web;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RegisterDeviceRequestPlatformEnum>
    _$registerDeviceRequestPlatformEnumValues = new BuiltSet<
        RegisterDeviceRequestPlatformEnum>(const <RegisterDeviceRequestPlatformEnum>[
  _$registerDeviceRequestPlatformEnum_android,
  _$registerDeviceRequestPlatformEnum_ios,
  _$registerDeviceRequestPlatformEnum_web,
]);

Serializer<RegisterDeviceRequestPlatformEnum>
    _$registerDeviceRequestPlatformEnumSerializer =
    new _$RegisterDeviceRequestPlatformEnumSerializer();

class _$RegisterDeviceRequestPlatformEnumSerializer
    implements PrimitiveSerializer<RegisterDeviceRequestPlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'android': 'android',
    'ios': 'ios',
    'web': 'web',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'android': 'android',
    'ios': 'ios',
    'web': 'web',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterDeviceRequestPlatformEnum];
  @override
  final String wireName = 'RegisterDeviceRequestPlatformEnum';

  @override
  Object serialize(
          Serializers serializers, RegisterDeviceRequestPlatformEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterDeviceRequestPlatformEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterDeviceRequestPlatformEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterDeviceRequest extends RegisterDeviceRequest {
  @override
  final RegisterDeviceRequestPlatformEnum platform;
  @override
  final String token;

  factory _$RegisterDeviceRequest(
          [void Function(RegisterDeviceRequestBuilder)? updates]) =>
      (new RegisterDeviceRequestBuilder()..update(updates))._build();

  _$RegisterDeviceRequest._({required this.platform, required this.token})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        platform, r'RegisterDeviceRequest', 'platform');
    BuiltValueNullFieldError.checkNotNull(
        token, r'RegisterDeviceRequest', 'token');
  }

  @override
  RegisterDeviceRequest rebuild(
          void Function(RegisterDeviceRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterDeviceRequestBuilder toBuilder() =>
      new RegisterDeviceRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterDeviceRequest &&
        platform == other.platform &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterDeviceRequest')
          ..add('platform', platform)
          ..add('token', token))
        .toString();
  }
}

class RegisterDeviceRequestBuilder
    implements Builder<RegisterDeviceRequest, RegisterDeviceRequestBuilder> {
  _$RegisterDeviceRequest? _$v;

  RegisterDeviceRequestPlatformEnum? _platform;
  RegisterDeviceRequestPlatformEnum? get platform => _$this._platform;
  set platform(RegisterDeviceRequestPlatformEnum? platform) =>
      _$this._platform = platform;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  RegisterDeviceRequestBuilder() {
    RegisterDeviceRequest._defaults(this);
  }

  RegisterDeviceRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterDeviceRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RegisterDeviceRequest;
  }

  @override
  void update(void Function(RegisterDeviceRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterDeviceRequest build() => _build();

  _$RegisterDeviceRequest _build() {
    final _$result = _$v ??
        new _$RegisterDeviceRequest._(
            platform: BuiltValueNullFieldError.checkNotNull(
                platform, r'RegisterDeviceRequest', 'platform'),
            token: BuiltValueNullFieldError.checkNotNull(
                token, r'RegisterDeviceRequest', 'token'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
