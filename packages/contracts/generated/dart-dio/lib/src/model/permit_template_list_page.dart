//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/permit_template_list_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_template_list_page.g.dart';

/// PermitTemplateListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PermitTemplateListPage
    implements Built<PermitTemplateListPage, PermitTemplateListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PermitTemplateListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  PermitTemplateListPage._();

  factory PermitTemplateListPage(
          [void updates(PermitTemplateListPageBuilder b)]) =
      _$PermitTemplateListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitTemplateListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitTemplateListPage> get serializer =>
      _$PermitTemplateListPageSerializer();
}

class _$PermitTemplateListPageSerializer
    implements PrimitiveSerializer<PermitTemplateListPage> {
  @override
  final Iterable<Type> types = const [
    PermitTemplateListPage,
    _$PermitTemplateListPage
  ];

  @override
  final String wireName = r'PermitTemplateListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitTemplateListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(PermitTemplateListItem)]),
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
    PermitTemplateListPage object, {
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
    required PermitTemplateListPageBuilder result,
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
                const FullType(BuiltList, [FullType(PermitTemplateListItem)]),
          ) as BuiltList<PermitTemplateListItem>;
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
  PermitTemplateListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitTemplateListPageBuilder();
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
