//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'facility_detail.g.dart';

/// FacilityDetail
///
/// Properties:
/// * [address]
/// * [createdAt]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [name]
/// * [sector]
/// * [status]
/// * [timezone]
/// * [updatedAt]
@BuiltValue()
abstract class FacilityDetail
    implements Built<FacilityDetail, FacilityDetailBuilder> {
  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sector')
  String? get sector;

  @BuiltValueField(wireName: r'status')
  FacilityDetailStatusEnum get status;
  // enum statusEnum {  active,  inactive,  };

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  FacilityDetail._();

  factory FacilityDetail([void updates(FacilityDetailBuilder b)]) =
      _$FacilityDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacilityDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacilityDetail> get serializer =>
      _$FacilityDetailSerializer();
}

class _$FacilityDetailSerializer
    implements PrimitiveSerializer<FacilityDetail> {
  @override
  final Iterable<Type> types = const [FacilityDetail, _$FacilityDetail];

  @override
  final String wireName = r'FacilityDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacilityDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
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
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FacilityDetailStatusEnum),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FacilityDetail object, {
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
    required FacilityDetailBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
            specifiedType: const FullType(FacilityDetailStatusEnum),
          ) as FacilityDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FacilityDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacilityDetailBuilder();
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

class FacilityDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const FacilityDetailStatusEnum active =
      _$facilityDetailStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const FacilityDetailStatusEnum inactive =
      _$facilityDetailStatusEnum_inactive;

  static Serializer<FacilityDetailStatusEnum> get serializer =>
      _$facilityDetailStatusEnumSerializer;

  const FacilityDetailStatusEnum._(String name) : super(name);

  static BuiltSet<FacilityDetailStatusEnum> get values =>
      _$facilityDetailStatusEnumValues;
  static FacilityDetailStatusEnum valueOf(String name) =>
      _$facilityDetailStatusEnumValueOf(name);
}
