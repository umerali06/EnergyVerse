//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_approval_template_step_input.g.dart';

/// PermitApprovalTemplateStepInput
///
/// Properties:
/// * [approverRoleId]
/// * [id]
/// * [label]
/// * [required_]
@BuiltValue()
abstract class PermitApprovalTemplateStepInput
    implements
        Built<PermitApprovalTemplateStepInput,
            PermitApprovalTemplateStepInputBuilder> {
  @BuiltValueField(wireName: r'approver_role_id')
  String get approverRoleId;

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'required')
  bool? get required_;

  PermitApprovalTemplateStepInput._();

  factory PermitApprovalTemplateStepInput(
          [void updates(PermitApprovalTemplateStepInputBuilder b)]) =
      _$PermitApprovalTemplateStepInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitApprovalTemplateStepInputBuilder b) =>
      b..required_ = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitApprovalTemplateStepInput> get serializer =>
      _$PermitApprovalTemplateStepInputSerializer();
}

class _$PermitApprovalTemplateStepInputSerializer
    implements PrimitiveSerializer<PermitApprovalTemplateStepInput> {
  @override
  final Iterable<Type> types = const [
    PermitApprovalTemplateStepInput,
    _$PermitApprovalTemplateStepInput
  ];

  @override
  final String wireName = r'PermitApprovalTemplateStepInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitApprovalTemplateStepInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approver_role_id';
    yield serializers.serialize(
      object.approverRoleId,
      specifiedType: const FullType(String),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
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
    PermitApprovalTemplateStepInput object, {
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
    required PermitApprovalTemplateStepInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approver_role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.approverRoleId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  PermitApprovalTemplateStepInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitApprovalTemplateStepInputBuilder();
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
