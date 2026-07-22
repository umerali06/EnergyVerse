//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_facility_request.g.dart';

/// UpdateFacilityRequest
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
abstract class UpdateFacilityRequest
    implements Built<UpdateFacilityRequest, UpdateFacilityRequestBuilder> {
  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'sector')
  String? get sector;

  @BuiltValueField(wireName: r'status')
  UpdateFacilityRequestStatusEnum? get status;
  // enum statusEnum {  active,  inactive,  };

  @BuiltValueField(wireName: r'timezone')
  String? get timezone;

  UpdateFacilityRequest._();

  factory UpdateFacilityRequest(
      [void updates(UpdateFacilityRequestBuilder b)]) = _$UpdateFacilityRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateFacilityRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateFacilityRequest> get serializer =>
      _$UpdateFacilityRequestSerializer();
}

class _$UpdateFacilityRequestSerializer
    implements PrimitiveSerializer<UpdateFacilityRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateFacilityRequest,
    _$UpdateFacilityRequest
  ];

  @override
  final String wireName = r'UpdateFacilityRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateFacilityRequest object, {
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
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
        specifiedType: const FullType.nullable(UpdateFacilityRequestStatusEnum),
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
    UpdateFacilityRequest object, {
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
    required UpdateFacilityRequestBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType:
                const FullType.nullable(UpdateFacilityRequestStatusEnum),
          ) as UpdateFacilityRequestStatusEnum?;
          if (valueDes == null) continue;
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
  UpdateFacilityRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateFacilityRequestBuilder();
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

class UpdateFacilityRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const UpdateFacilityRequestStatusEnum active =
      _$updateFacilityRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const UpdateFacilityRequestStatusEnum inactive =
      _$updateFacilityRequestStatusEnum_inactive;

  static Serializer<UpdateFacilityRequestStatusEnum> get serializer =>
      _$updateFacilityRequestStatusEnumSerializer;

  const UpdateFacilityRequestStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateFacilityRequestStatusEnum> get values =>
      _$updateFacilityRequestStatusEnumValues;
  static UpdateFacilityRequestStatusEnum valueOf(String name) =>
      _$updateFacilityRequestStatusEnumValueOf(name);
}
