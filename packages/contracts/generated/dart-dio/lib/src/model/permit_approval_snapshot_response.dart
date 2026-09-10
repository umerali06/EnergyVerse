//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_approval_snapshot_response.g.dart';

/// PermitApprovalSnapshotResponse
///
/// Properties:
/// * [approverRoleId]
/// * [id]
/// * [label]
/// * [rejectionReason]
/// * [required_]
/// * [signedAt]
/// * [signedBy]
/// * [status]
/// * [templateStepId]
@BuiltValue()
abstract class PermitApprovalSnapshotResponse
    implements
        Built<PermitApprovalSnapshotResponse,
            PermitApprovalSnapshotResponseBuilder> {
  @BuiltValueField(wireName: r'approver_role_id')
  String get approverRoleId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'rejection_reason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'required')
  bool get required_;

  @BuiltValueField(wireName: r'signed_at')
  DateTime? get signedAt;

  @BuiltValueField(wireName: r'signed_by')
  String? get signedBy;

  @BuiltValueField(wireName: r'status')
  PermitApprovalSnapshotResponseStatusEnum get status;
  // enum statusEnum {  pending,  approved,  rejected,  };

  @BuiltValueField(wireName: r'template_step_id')
  String get templateStepId;

  PermitApprovalSnapshotResponse._();

  factory PermitApprovalSnapshotResponse(
          [void updates(PermitApprovalSnapshotResponseBuilder b)]) =
      _$PermitApprovalSnapshotResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitApprovalSnapshotResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitApprovalSnapshotResponse> get serializer =>
      _$PermitApprovalSnapshotResponseSerializer();
}

class _$PermitApprovalSnapshotResponseSerializer
    implements PrimitiveSerializer<PermitApprovalSnapshotResponse> {
  @override
  final Iterable<Type> types = const [
    PermitApprovalSnapshotResponse,
    _$PermitApprovalSnapshotResponse
  ];

  @override
  final String wireName = r'PermitApprovalSnapshotResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitApprovalSnapshotResponse object, {
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
    if (object.rejectionReason != null) {
      yield r'rejection_reason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
    if (object.signedAt != null) {
      yield r'signed_at';
      yield serializers.serialize(
        object.signedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.signedBy != null) {
      yield r'signed_by';
      yield serializers.serialize(
        object.signedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PermitApprovalSnapshotResponseStatusEnum),
    );
    yield r'template_step_id';
    yield serializers.serialize(
      object.templateStepId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitApprovalSnapshotResponse object, {
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
    required PermitApprovalSnapshotResponseBuilder result,
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
        case r'rejection_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        case r'required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.required_ = valueDes;
          break;
        case r'signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.signedAt = valueDes;
          break;
        case r'signed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.signedBy = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(PermitApprovalSnapshotResponseStatusEnum),
          ) as PermitApprovalSnapshotResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'template_step_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateStepId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitApprovalSnapshotResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitApprovalSnapshotResponseBuilder();
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

class PermitApprovalSnapshotResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const PermitApprovalSnapshotResponseStatusEnum pending =
      _$permitApprovalSnapshotResponseStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'approved')
  static const PermitApprovalSnapshotResponseStatusEnum approved =
      _$permitApprovalSnapshotResponseStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const PermitApprovalSnapshotResponseStatusEnum rejected =
      _$permitApprovalSnapshotResponseStatusEnum_rejected;

  static Serializer<PermitApprovalSnapshotResponseStatusEnum> get serializer =>
      _$permitApprovalSnapshotResponseStatusEnumSerializer;

  const PermitApprovalSnapshotResponseStatusEnum._(String name) : super(name);

  static BuiltSet<PermitApprovalSnapshotResponseStatusEnum> get values =>
      _$permitApprovalSnapshotResponseStatusEnumValues;
  static PermitApprovalSnapshotResponseStatusEnum valueOf(String name) =>
      _$permitApprovalSnapshotResponseStatusEnumValueOf(name);
}
