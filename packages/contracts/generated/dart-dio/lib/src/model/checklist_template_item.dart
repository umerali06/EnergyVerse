//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checklist_template_item.g.dart';

/// ChecklistTemplateItem
///
/// Properties:
/// * [helpText]
/// * [id]
/// * [itemType]
/// * [label]
/// * [options]
/// * [required_]
@BuiltValue()
abstract class ChecklistTemplateItem
    implements Built<ChecklistTemplateItem, ChecklistTemplateItemBuilder> {
  @BuiltValueField(wireName: r'help_text')
  String? get helpText;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'item_type')
  ChecklistTemplateItemItemTypeEnum get itemType;
  // enum itemTypeEnum {  boolean,  numeric,  text,  select,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'options')
  BuiltList<String>? get options;

  @BuiltValueField(wireName: r'required')
  bool get required_;

  ChecklistTemplateItem._();

  factory ChecklistTemplateItem(
      [void updates(ChecklistTemplateItemBuilder b)]) = _$ChecklistTemplateItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChecklistTemplateItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChecklistTemplateItem> get serializer =>
      _$ChecklistTemplateItemSerializer();
}

class _$ChecklistTemplateItemSerializer
    implements PrimitiveSerializer<ChecklistTemplateItem> {
  @override
  final Iterable<Type> types = const [
    ChecklistTemplateItem,
    _$ChecklistTemplateItem
  ];

  @override
  final String wireName = r'ChecklistTemplateItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChecklistTemplateItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.helpText != null) {
      yield r'help_text';
      yield serializers.serialize(
        object.helpText,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'item_type';
    yield serializers.serialize(
      object.itemType,
      specifiedType: const FullType(ChecklistTemplateItemItemTypeEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    if (object.options != null) {
      yield r'options';
      yield serializers.serialize(
        object.options,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChecklistTemplateItem object, {
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
    required ChecklistTemplateItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'help_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.helpText = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'item_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChecklistTemplateItemItemTypeEnum),
          ) as ChecklistTemplateItemItemTypeEnum;
          result.itemType = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.options.replace(valueDes);
          break;
        case r'required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.required_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChecklistTemplateItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChecklistTemplateItemBuilder();
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

class ChecklistTemplateItemItemTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'boolean')
  static const ChecklistTemplateItemItemTypeEnum boolean =
      _$checklistTemplateItemItemTypeEnum_boolean;
  @BuiltValueEnumConst(wireName: r'numeric')
  static const ChecklistTemplateItemItemTypeEnum numeric =
      _$checklistTemplateItemItemTypeEnum_numeric;
  @BuiltValueEnumConst(wireName: r'text')
  static const ChecklistTemplateItemItemTypeEnum text =
      _$checklistTemplateItemItemTypeEnum_text;
  @BuiltValueEnumConst(wireName: r'select')
  static const ChecklistTemplateItemItemTypeEnum select =
      _$checklistTemplateItemItemTypeEnum_select;

  static Serializer<ChecklistTemplateItemItemTypeEnum> get serializer =>
      _$checklistTemplateItemItemTypeEnumSerializer;

  const ChecklistTemplateItemItemTypeEnum._(String name) : super(name);

  static BuiltSet<ChecklistTemplateItemItemTypeEnum> get values =>
      _$checklistTemplateItemItemTypeEnumValues;
  static ChecklistTemplateItemItemTypeEnum valueOf(String name) =>
      _$checklistTemplateItemItemTypeEnumValueOf(name);
}
