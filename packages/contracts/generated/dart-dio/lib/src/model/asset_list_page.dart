//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/asset_list_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_list_page.g.dart';

/// AssetListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class AssetListPage
    implements Built<AssetListPage, AssetListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AssetListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  AssetListPage._();

  factory AssetListPage([void updates(AssetListPageBuilder b)]) =
      _$AssetListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetListPage> get serializer =>
      _$AssetListPageSerializer();
}

class _$AssetListPageSerializer implements PrimitiveSerializer<AssetListPage> {
  @override
  final Iterable<Type> types = const [AssetListPage, _$AssetListPage];

  @override
  final String wireName = r'AssetListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AssetListItem)]),
    );
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetListPage object, {
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
    required AssetListPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetListItem)]),
          ) as BuiltList<AssetListItem>;
          result.items.replace(valueDes);
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetListPageBuilder();
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
