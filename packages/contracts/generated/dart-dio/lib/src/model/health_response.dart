//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_response.g.dart';

/// HealthResponse
///
/// Properties:
/// * [firestore]
/// * [service]
/// * [status]
/// * [timestamp]
@BuiltValue()
abstract class HealthResponse
    implements Built<HealthResponse, HealthResponseBuilder> {
  @BuiltValueField(wireName: r'firestore')
  HealthResponseFirestoreEnum get firestore;
  // enum firestoreEnum {  connected,  unavailable,  unconfigured,  };

  @BuiltValueField(wireName: r'service')
  HealthResponseServiceEnum get service;
  // enum serviceEnum {  fev-api,  };

  @BuiltValueField(wireName: r'status')
  HealthResponseStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  HealthResponse._();

  factory HealthResponse([void updates(HealthResponseBuilder b)]) =
      _$HealthResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthResponse> get serializer =>
      _$HealthResponseSerializer();
}

class _$HealthResponseSerializer
    implements PrimitiveSerializer<HealthResponse> {
  @override
  final Iterable<Type> types = const [HealthResponse, _$HealthResponse];

  @override
  final String wireName = r'HealthResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firestore';
    yield serializers.serialize(
      object.firestore,
      specifiedType: const FullType(HealthResponseFirestoreEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(HealthResponseServiceEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(HealthResponseStatusEnum),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthResponse object, {
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
    required HealthResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firestore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthResponseFirestoreEnum),
          ) as HealthResponseFirestoreEnum;
          result.firestore = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthResponseServiceEnum),
          ) as HealthResponseServiceEnum;
          result.service = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthResponseStatusEnum),
          ) as HealthResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HealthResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthResponseBuilder();
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

class HealthResponseFirestoreEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'connected')
  static const HealthResponseFirestoreEnum connected =
      _$healthResponseFirestoreEnum_connected;
  @BuiltValueEnumConst(wireName: r'unavailable')
  static const HealthResponseFirestoreEnum unavailable =
      _$healthResponseFirestoreEnum_unavailable;
  @BuiltValueEnumConst(wireName: r'unconfigured')
  static const HealthResponseFirestoreEnum unconfigured =
      _$healthResponseFirestoreEnum_unconfigured;

  static Serializer<HealthResponseFirestoreEnum> get serializer =>
      _$healthResponseFirestoreEnumSerializer;

  const HealthResponseFirestoreEnum._(String name) : super(name);

  static BuiltSet<HealthResponseFirestoreEnum> get values =>
      _$healthResponseFirestoreEnumValues;
  static HealthResponseFirestoreEnum valueOf(String name) =>
      _$healthResponseFirestoreEnumValueOf(name);
}

class HealthResponseServiceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fev-api')
  static const HealthResponseServiceEnum fevApi =
      _$healthResponseServiceEnum_fevApi;

  static Serializer<HealthResponseServiceEnum> get serializer =>
      _$healthResponseServiceEnumSerializer;

  const HealthResponseServiceEnum._(String name) : super(name);

  static BuiltSet<HealthResponseServiceEnum> get values =>
      _$healthResponseServiceEnumValues;
  static HealthResponseServiceEnum valueOf(String name) =>
      _$healthResponseServiceEnumValueOf(name);
}

class HealthResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const HealthResponseStatusEnum ok = _$healthResponseStatusEnum_ok;

  static Serializer<HealthResponseStatusEnum> get serializer =>
      _$healthResponseStatusEnumSerializer;

  const HealthResponseStatusEnum._(String name) : super(name);

  static BuiltSet<HealthResponseStatusEnum> get values =>
      _$healthResponseStatusEnumValues;
  static HealthResponseStatusEnum valueOf(String name) =>
      _$healthResponseStatusEnumValueOf(name);
}
