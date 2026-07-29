//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checklist_template_item_input.g.dart';

/// ChecklistTemplateItemInput
///
/// Properties:
/// * [helpText]
/// * [id]
/// * [itemType]
/// * [label]
/// * [options]
/// * [required_]
@BuiltValue()
abstract class ChecklistTemplateItemInput
    implements
        Built<ChecklistTemplateItemInput, ChecklistTemplateItemInputBuilder> {
  @BuiltValueField(wireName: r'help_text')
  String? get helpText;

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'item_type')
  ChecklistTemplateItemInputItemTypeEnum get itemType;
  // enum itemTypeEnum {  boolean,  numeric,  text,  select,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'options')
  BuiltList<String>? get options;

  @BuiltValueField(wireName: r'required')
  bool? get required_;

  ChecklistTemplateItemInput._();

  factory ChecklistTemplateItemInput(
          [void updates(ChecklistTemplateItemInputBuilder b)]) =
      _$ChecklistTemplateItemInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChecklistTemplateItemInputBuilder b) =>
      b..required_ = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChecklistTemplateItemInput> get serializer =>
      _$ChecklistTemplateItemInputSerializer();
}

class _$ChecklistTemplateItemInputSerializer
    implements PrimitiveSerializer<ChecklistTemplateItemInput> {
  @override
  final Iterable<Type> types = const [
    ChecklistTemplateItemInput,
    _$ChecklistTemplateItemInput
  ];

  @override
  final String wireName = r'ChecklistTemplateItemInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChecklistTemplateItemInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.helpText != null) {
      yield r'help_text';
      yield serializers.serialize(
        object.helpText,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'item_type';
    yield serializers.serialize(
      object.itemType,
      specifiedType: const FullType(ChecklistTemplateItemInputItemTypeEnum),
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
    if (object.required_ != null) {
      yield r'required';
      yield serializers.serialize(
        object.required_,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChecklistTemplateItemInput object, {
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
    required ChecklistTemplateItemInputBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'item_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ChecklistTemplateItemInputItemTypeEnum),
          ) as ChecklistTemplateItemInputItemTypeEnum;
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
  ChecklistTemplateItemInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChecklistTemplateItemInputBuilder();
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

class ChecklistTemplateItemInputItemTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'boolean')
  static const ChecklistTemplateItemInputItemTypeEnum boolean =
      _$checklistTemplateItemInputItemTypeEnum_boolean;
  @BuiltValueEnumConst(wireName: r'numeric')
  static const ChecklistTemplateItemInputItemTypeEnum numeric =
      _$checklistTemplateItemInputItemTypeEnum_numeric;
  @BuiltValueEnumConst(wireName: r'text')
  static const ChecklistTemplateItemInputItemTypeEnum text =
      _$checklistTemplateItemInputItemTypeEnum_text;
  @BuiltValueEnumConst(wireName: r'select')
  static const ChecklistTemplateItemInputItemTypeEnum select =
      _$checklistTemplateItemInputItemTypeEnum_select;

  static Serializer<ChecklistTemplateItemInputItemTypeEnum> get serializer =>
      _$checklistTemplateItemInputItemTypeEnumSerializer;

  const ChecklistTemplateItemInputItemTypeEnum._(String name) : super(name);

  static BuiltSet<ChecklistTemplateItemInputItemTypeEnum> get values =>
      _$checklistTemplateItemInputItemTypeEnumValues;
  static ChecklistTemplateItemInputItemTypeEnum valueOf(String name) =>
      _$checklistTemplateItemInputItemTypeEnumValueOf(name);
}
