//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/permit_list_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_list_page.g.dart';

/// PermitListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PermitListPage
    implements Built<PermitListPage, PermitListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PermitListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  PermitListPage._();

  factory PermitListPage([void updates(PermitListPageBuilder b)]) =
      _$PermitListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitListPage> get serializer =>
      _$PermitListPageSerializer();
}

class _$PermitListPageSerializer
    implements PrimitiveSerializer<PermitListPage> {
  @override
  final Iterable<Type> types = const [PermitListPage, _$PermitListPage];

  @override
  final String wireName = r'PermitListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PermitListItem)]),
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
    PermitListPage object, {
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
    required PermitListPageBuilder result,
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
                const FullType(BuiltList, [FullType(PermitListItem)]),
          ) as BuiltList<PermitListItem>;
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
  PermitListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitListPageBuilder();
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
