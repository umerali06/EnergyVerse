//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_device_request.g.dart';

/// RegisterDeviceRequest
///
/// Properties:
/// * [platform]
/// * [token]
@BuiltValue()
abstract class RegisterDeviceRequest
    implements Built<RegisterDeviceRequest, RegisterDeviceRequestBuilder> {
  @BuiltValueField(wireName: r'platform')
  RegisterDeviceRequestPlatformEnum get platform;
  // enum platformEnum {  android,  ios,  web,  };

  @BuiltValueField(wireName: r'token')
  String get token;

  RegisterDeviceRequest._();

  factory RegisterDeviceRequest(
      [void updates(RegisterDeviceRequestBuilder b)]) = _$RegisterDeviceRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterDeviceRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterDeviceRequest> get serializer =>
      _$RegisterDeviceRequestSerializer();
}

class _$RegisterDeviceRequestSerializer
    implements PrimitiveSerializer<RegisterDeviceRequest> {
  @override
  final Iterable<Type> types = const [
    RegisterDeviceRequest,
    _$RegisterDeviceRequest
  ];

  @override
  final String wireName = r'RegisterDeviceRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterDeviceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(RegisterDeviceRequestPlatformEnum),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterDeviceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterDeviceRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterDeviceRequestPlatformEnum),
          ) as RegisterDeviceRequestPlatformEnum;
          result.platform = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterDeviceRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterDeviceRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class RegisterDeviceRequestPlatformEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'android')
  static const RegisterDeviceRequestPlatformEnum android =
      _$registerDeviceRequestPlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'ios')
  static const RegisterDeviceRequestPlatformEnum ios =
      _$registerDeviceRequestPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'web')
  static const RegisterDeviceRequestPlatformEnum web =
      _$registerDeviceRequestPlatformEnum_web;

  static Serializer<RegisterDeviceRequestPlatformEnum> get serializer =>
      _$registerDeviceRequestPlatformEnumSerializer;

  const RegisterDeviceRequestPlatformEnum._(String name) : super(name);

  static BuiltSet<RegisterDeviceRequestPlatformEnum> get values =>
      _$registerDeviceRequestPlatformEnumValues;
  static RegisterDeviceRequestPlatformEnum valueOf(String name) =>
      _$registerDeviceRequestPlatformEnumValueOf(name);
}
