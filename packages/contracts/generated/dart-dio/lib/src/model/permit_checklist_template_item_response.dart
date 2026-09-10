//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_checklist_template_item_response.g.dart';

/// PermitChecklistTemplateItemResponse
///
/// Properties:
/// * [helpText]
/// * [id]
/// * [label]
/// * [required_]
@BuiltValue()
abstract class PermitChecklistTemplateItemResponse
    implements
        Built<PermitChecklistTemplateItemResponse,
            PermitChecklistTemplateItemResponseBuilder> {
  @BuiltValueField(wireName: r'help_text')
  String? get helpText;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'required')
  bool get required_;

  PermitChecklistTemplateItemResponse._();

  factory PermitChecklistTemplateItemResponse(
          [void updates(PermitChecklistTemplateItemResponseBuilder b)]) =
      _$PermitChecklistTemplateItemResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitChecklistTemplateItemResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitChecklistTemplateItemResponse> get serializer =>
      _$PermitChecklistTemplateItemResponseSerializer();
}

class _$PermitChecklistTemplateItemResponseSerializer
    implements PrimitiveSerializer<PermitChecklistTemplateItemResponse> {
  @override
  final Iterable<Type> types = const [
    PermitChecklistTemplateItemResponse,
    _$PermitChecklistTemplateItemResponse
  ];

  @override
  final String wireName = r'PermitChecklistTemplateItemResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitChecklistTemplateItemResponse object, {
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
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitChecklistTemplateItemResponse object, {
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
    required PermitChecklistTemplateItemResponseBuilder result,
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
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
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
  PermitChecklistTemplateItemResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitChecklistTemplateItemResponseBuilder();
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
