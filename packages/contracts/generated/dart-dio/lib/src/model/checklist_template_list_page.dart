//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/checklist_template_list_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checklist_template_list_page.g.dart';

/// ChecklistTemplateListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class ChecklistTemplateListPage
    implements
        Built<ChecklistTemplateListPage, ChecklistTemplateListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ChecklistTemplateListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  ChecklistTemplateListPage._();

  factory ChecklistTemplateListPage(
          [void updates(ChecklistTemplateListPageBuilder b)]) =
      _$ChecklistTemplateListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChecklistTemplateListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChecklistTemplateListPage> get serializer =>
      _$ChecklistTemplateListPageSerializer();
}

class _$ChecklistTemplateListPageSerializer
    implements PrimitiveSerializer<ChecklistTemplateListPage> {
  @override
  final Iterable<Type> types = const [
    ChecklistTemplateListPage,
    _$ChecklistTemplateListPage
  ];

  @override
  final String wireName = r'ChecklistTemplateListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChecklistTemplateListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(ChecklistTemplateListItem)]),
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
    ChecklistTemplateListPage object, {
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
    required ChecklistTemplateListPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(ChecklistTemplateListItem)]),
          ) as BuiltList<ChecklistTemplateListItem>;
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
  ChecklistTemplateListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChecklistTemplateListPageBuilder();
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
