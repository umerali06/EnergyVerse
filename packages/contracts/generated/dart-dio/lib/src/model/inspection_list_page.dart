//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/inspection_list_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inspection_list_page.g.dart';

/// InspectionListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class InspectionListPage
    implements Built<InspectionListPage, InspectionListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<InspectionListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  InspectionListPage._();

  factory InspectionListPage([void updates(InspectionListPageBuilder b)]) =
      _$InspectionListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InspectionListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InspectionListPage> get serializer =>
      _$InspectionListPageSerializer();
}

class _$InspectionListPageSerializer
    implements PrimitiveSerializer<InspectionListPage> {
  @override
  final Iterable<Type> types = const [InspectionListPage, _$InspectionListPage];

  @override
  final String wireName = r'InspectionListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InspectionListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(InspectionListItem)]),
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
    InspectionListPage object, {
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
    required InspectionListPageBuilder result,
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
                const FullType(BuiltList, [FullType(InspectionListItem)]),
          ) as BuiltList<InspectionListItem>;
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
  InspectionListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InspectionListPageBuilder();
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
