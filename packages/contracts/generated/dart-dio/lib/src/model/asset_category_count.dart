//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_category_count.g.dart';

/// AssetCategoryCount
///
/// Properties:
/// * [category]
/// * [count]
@BuiltValue()
abstract class AssetCategoryCount
    implements Built<AssetCategoryCount, AssetCategoryCountBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'count')
  int get count;

  AssetCategoryCount._();

  factory AssetCategoryCount([void updates(AssetCategoryCountBuilder b)]) =
      _$AssetCategoryCount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetCategoryCountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetCategoryCount> get serializer =>
      _$AssetCategoryCountSerializer();
}

class _$AssetCategoryCountSerializer
    implements PrimitiveSerializer<AssetCategoryCount> {
  @override
  final Iterable<Type> types = const [AssetCategoryCount, _$AssetCategoryCount];

  @override
  final String wireName = r'AssetCategoryCount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetCategoryCount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
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
    AssetCategoryCount object, {
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
    required AssetCategoryCountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AssetCategoryCount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetCategoryCountBuilder();
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
