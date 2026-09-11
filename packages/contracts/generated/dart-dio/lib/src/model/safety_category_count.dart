//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_category_count.g.dart';

/// SafetyCategoryCount
///
/// Properties:
/// * [category]
/// * [count]
@BuiltValue()
abstract class SafetyCategoryCount
    implements Built<SafetyCategoryCount, SafetyCategoryCountBuilder> {
  @BuiltValueField(wireName: r'category')
  SafetyCategoryCountCategoryEnum get category;
  // enum categoryEnum {  near_miss,  unsafe_condition,  unsafe_behavior,  fire,  gas_leak,  chemical_spill,  environmental_incident,  equipment_failure,  injury,  };

  @BuiltValueField(wireName: r'count')
  int get count;

  SafetyCategoryCount._();

  factory SafetyCategoryCount([void updates(SafetyCategoryCountBuilder b)]) =
      _$SafetyCategoryCount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyCategoryCountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyCategoryCount> get serializer =>
      _$SafetyCategoryCountSerializer();
}

class _$SafetyCategoryCountSerializer
    implements PrimitiveSerializer<SafetyCategoryCount> {
  @override
  final Iterable<Type> types = const [
    SafetyCategoryCount,
    _$SafetyCategoryCount
  ];

  @override
  final String wireName = r'SafetyCategoryCount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyCategoryCount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SafetyCategoryCountCategoryEnum),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SafetyCategoryCount object, {
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
    required SafetyCategoryCountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyCategoryCountCategoryEnum),
          ) as SafetyCategoryCountCategoryEnum;
          result.category = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SafetyCategoryCount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyCategoryCountBuilder();
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

class SafetyCategoryCountCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'near_miss')
  static const SafetyCategoryCountCategoryEnum nearMiss =
      _$safetyCategoryCountCategoryEnum_nearMiss;
  @BuiltValueEnumConst(wireName: r'unsafe_condition')
  static const SafetyCategoryCountCategoryEnum unsafeCondition =
      _$safetyCategoryCountCategoryEnum_unsafeCondition;
  @BuiltValueEnumConst(wireName: r'unsafe_behavior')
  static const SafetyCategoryCountCategoryEnum unsafeBehavior =
      _$safetyCategoryCountCategoryEnum_unsafeBehavior;
  @BuiltValueEnumConst(wireName: r'fire')
  static const SafetyCategoryCountCategoryEnum fire =
      _$safetyCategoryCountCategoryEnum_fire;
  @BuiltValueEnumConst(wireName: r'gas_leak')
  static const SafetyCategoryCountCategoryEnum gasLeak =
      _$safetyCategoryCountCategoryEnum_gasLeak;
  @BuiltValueEnumConst(wireName: r'chemical_spill')
  static const SafetyCategoryCountCategoryEnum chemicalSpill =
      _$safetyCategoryCountCategoryEnum_chemicalSpill;
  @BuiltValueEnumConst(wireName: r'environmental_incident')
  static const SafetyCategoryCountCategoryEnum environmentalIncident =
      _$safetyCategoryCountCategoryEnum_environmentalIncident;
  @BuiltValueEnumConst(wireName: r'equipment_failure')
  static const SafetyCategoryCountCategoryEnum equipmentFailure =
      _$safetyCategoryCountCategoryEnum_equipmentFailure;
  @BuiltValueEnumConst(wireName: r'injury')
  static const SafetyCategoryCountCategoryEnum injury =
      _$safetyCategoryCountCategoryEnum_injury;

  static Serializer<SafetyCategoryCountCategoryEnum> get serializer =>
      _$safetyCategoryCountCategoryEnumSerializer;

  const SafetyCategoryCountCategoryEnum._(String name) : super(name);

  static BuiltSet<SafetyCategoryCountCategoryEnum> get values =>
      _$safetyCategoryCountCategoryEnumValues;
  static SafetyCategoryCountCategoryEnum valueOf(String name) =>
      _$safetyCategoryCountCategoryEnumValueOf(name);
}
