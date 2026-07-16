//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'service_response.g.dart';

/// ServiceResponse
///
/// Properties:
/// * [service]
/// * [status]
@BuiltValue()
abstract class ServiceResponse
    implements Built<ServiceResponse, ServiceResponseBuilder> {
  @BuiltValueField(wireName: r'service')
  ServiceResponseServiceEnum get service;
  // enum serviceEnum {  fev-api,  };

  @BuiltValueField(wireName: r'status')
  ServiceResponseStatusEnum get status;
  // enum statusEnum {  ok,  };

  ServiceResponse._();

  factory ServiceResponse([void updates(ServiceResponseBuilder b)]) =
      _$ServiceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServiceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServiceResponse> get serializer =>
      _$ServiceResponseSerializer();
}

class _$ServiceResponseSerializer
    implements PrimitiveSerializer<ServiceResponse> {
  @override
  final Iterable<Type> types = const [ServiceResponse, _$ServiceResponse];

  @override
  final String wireName = r'ServiceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServiceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(ServiceResponseServiceEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ServiceResponseStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServiceResponse object, {
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
    required ServiceResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServiceResponseServiceEnum),
          ) as ServiceResponseServiceEnum;
          result.service = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServiceResponseStatusEnum),
          ) as ServiceResponseStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServiceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServiceResponseBuilder();
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

class ServiceResponseServiceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fev-api')
  static const ServiceResponseServiceEnum fevApi =
      _$serviceResponseServiceEnum_fevApi;

  static Serializer<ServiceResponseServiceEnum> get serializer =>
      _$serviceResponseServiceEnumSerializer;

  const ServiceResponseServiceEnum._(String name) : super(name);

  static BuiltSet<ServiceResponseServiceEnum> get values =>
      _$serviceResponseServiceEnumValues;
  static ServiceResponseServiceEnum valueOf(String name) =>
      _$serviceResponseServiceEnumValueOf(name);
}

class ServiceResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const ServiceResponseStatusEnum ok = _$serviceResponseStatusEnum_ok;

  static Serializer<ServiceResponseStatusEnum> get serializer =>
      _$serviceResponseStatusEnumSerializer;

  const ServiceResponseStatusEnum._(String name) : super(name);

  static BuiltSet<ServiceResponseStatusEnum> get values =>
      _$serviceResponseStatusEnumValues;
  static ServiceResponseStatusEnum valueOf(String name) =>
      _$serviceResponseStatusEnumValueOf(name);
}
