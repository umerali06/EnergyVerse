//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_facility_count.g.dart';

/// AssetFacilityCount
///
/// Properties:
/// * [count]
/// * [facilityId]
/// * [facilityName]
@BuiltValue()
abstract class AssetFacilityCount
    implements Built<AssetFacilityCount, AssetFacilityCountBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'facility_name')
  String get facilityName;

  AssetFacilityCount._();

  factory AssetFacilityCount([void updates(AssetFacilityCountBuilder b)]) =
      _$AssetFacilityCount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetFacilityCountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetFacilityCount> get serializer =>
      _$AssetFacilityCountSerializer();
}

class _$AssetFacilityCountSerializer
    implements PrimitiveSerializer<AssetFacilityCount> {
  @override
  final Iterable<Type> types = const [AssetFacilityCount, _$AssetFacilityCount];

  @override
  final String wireName = r'AssetFacilityCount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetFacilityCount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'facility_name';
    yield serializers.serialize(
      object.facilityName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetFacilityCount object, {
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
    required AssetFacilityCountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'facility_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetFacilityCount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetFacilityCountBuilder();
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
