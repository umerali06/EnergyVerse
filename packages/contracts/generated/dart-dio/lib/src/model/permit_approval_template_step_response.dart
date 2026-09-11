//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_approval_template_step_response.g.dart';

/// PermitApprovalTemplateStepResponse
///
/// Properties:
/// * [approverRoleId]
/// * [id]
/// * [label]
/// * [required_]
@BuiltValue()
abstract class PermitApprovalTemplateStepResponse
    implements
        Built<PermitApprovalTemplateStepResponse,
            PermitApprovalTemplateStepResponseBuilder> {
  @BuiltValueField(wireName: r'approver_role_id')
  String get approverRoleId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'required')
  bool get required_;

  PermitApprovalTemplateStepResponse._();

  factory PermitApprovalTemplateStepResponse(
          [void updates(PermitApprovalTemplateStepResponseBuilder b)]) =
      _$PermitApprovalTemplateStepResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitApprovalTemplateStepResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitApprovalTemplateStepResponse> get serializer =>
      _$PermitApprovalTemplateStepResponseSerializer();
}

class _$PermitApprovalTemplateStepResponseSerializer
    implements PrimitiveSerializer<PermitApprovalTemplateStepResponse> {
  @override
  final Iterable<Type> types = const [
    PermitApprovalTemplateStepResponse,
    _$PermitApprovalTemplateStepResponse
  ];

  @override
  final String wireName = r'PermitApprovalTemplateStepResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitApprovalTemplateStepResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approver_role_id';
    yield serializers.serialize(
      object.approverRoleId,
      specifiedType: const FullType(String),
    );
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
    PermitApprovalTemplateStepResponse object, {
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
    required PermitApprovalTemplateStepResponseBuilder result,
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
  PermitApprovalTemplateStepResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitApprovalTemplateStepResponseBuilder();
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
