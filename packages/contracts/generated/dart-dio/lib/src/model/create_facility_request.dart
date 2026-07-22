//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_facility_request.g.dart';

/// CreateFacilityRequest
///
/// Properties:
/// * [address]
/// * [gpsLat]
/// * [gpsLng]
/// * [name]
/// * [sector]
/// * [status]
/// * [timezone]
@BuiltValue()
abstract class CreateFacilityRequest
    implements Built<CreateFacilityRequest, CreateFacilityRequestBuilder> {
  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sector')
  String? get sector;

  @BuiltValueField(wireName: r'status')
  CreateFacilityRequestStatusEnum? get status;
  // enum statusEnum {  active,  inactive,  };

  @BuiltValueField(wireName: r'timezone')
  String? get timezone;

  CreateFacilityRequest._();

  factory CreateFacilityRequest(
      [void updates(CreateFacilityRequestBuilder b)]) = _$CreateFacilityRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateFacilityRequestBuilder b) =>
      b..status = const CreateFacilityRequestStatusEnum._('active');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateFacilityRequest> get serializer =>
      _$CreateFacilityRequestSerializer();
}

class _$CreateFacilityRequestSerializer
    implements PrimitiveSerializer<CreateFacilityRequest> {
  @override
  final Iterable<Type> types = const [
    CreateFacilityRequest,
    _$CreateFacilityRequest
  ];

  @override
  final String wireName = r'CreateFacilityRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateFacilityRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.gpsLat != null) {
      yield r'gps_lat';
      yield serializers.serialize(
        object.gpsLat,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.gpsLng != null) {
      yield r'gps_lng';
      yield serializers.serialize(
        object.gpsLng,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.sector != null) {
      yield r'sector';
      yield serializers.serialize(
        object.sector,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(CreateFacilityRequestStatusEnum),
      );
    }
    if (object.timezone != null) {
      yield r'timezone';
      yield serializers.serialize(
        object.timezone,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateFacilityRequest object, {
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
    required CreateFacilityRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'gps_lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLat = valueDes;
          break;
        case r'gps_lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLng = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'sector':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sector = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateFacilityRequestStatusEnum),
          ) as CreateFacilityRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.timezone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateFacilityRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateFacilityRequestBuilder();
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

class CreateFacilityRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const CreateFacilityRequestStatusEnum active =
      _$createFacilityRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const CreateFacilityRequestStatusEnum inactive =
      _$createFacilityRequestStatusEnum_inactive;

  static Serializer<CreateFacilityRequestStatusEnum> get serializer =>
      _$createFacilityRequestStatusEnumSerializer;

  const CreateFacilityRequestStatusEnum._(String name) : super(name);

  static BuiltSet<CreateFacilityRequestStatusEnum> get values =>
      _$createFacilityRequestStatusEnumValues;
  static CreateFacilityRequestStatusEnum valueOf(String name) =>
      _$createFacilityRequestStatusEnumValueOf(name);
}
