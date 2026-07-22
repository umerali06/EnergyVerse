//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/asset_history_event.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_history_page.g.dart';

/// AssetHistoryPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class AssetHistoryPage
    implements Built<AssetHistoryPage, AssetHistoryPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AssetHistoryEvent>? get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  AssetHistoryPage._();

  factory AssetHistoryPage([void updates(AssetHistoryPageBuilder b)]) =
      _$AssetHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetHistoryPage> get serializer =>
      _$AssetHistoryPageSerializer();
}

class _$AssetHistoryPageSerializer
    implements PrimitiveSerializer<AssetHistoryPage> {
  @override
  final Iterable<Type> types = const [AssetHistoryPage, _$AssetHistoryPage];

  @override
  final String wireName = r'AssetHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.items != null) {
      yield r'items';
      yield serializers.serialize(
        object.items,
        specifiedType: const FullType(BuiltList, [FullType(AssetHistoryEvent)]),
      );
    }
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
    AssetHistoryPage object, {
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
    required AssetHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AssetHistoryEvent)]),
          ) as BuiltList<AssetHistoryEvent>;
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
  AssetHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetHistoryPageBuilder();
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
