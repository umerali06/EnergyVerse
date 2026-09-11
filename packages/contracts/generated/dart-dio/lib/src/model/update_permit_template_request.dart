//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/permit_checklist_template_item_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_approval_template_step_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_permit_template_request.g.dart';

/// UpdatePermitTemplateRequest
///
/// Properties:
/// * [approvalSteps]
/// * [checklistItems]
/// * [description]
/// * [expectedVersion]
/// * [name]
/// * [permitType]
@BuiltValue()
abstract class UpdatePermitTemplateRequest
    implements
        Built<UpdatePermitTemplateRequest, UpdatePermitTemplateRequestBuilder> {
  @BuiltValueField(wireName: r'approval_steps')
  BuiltList<PermitApprovalTemplateStepInput>? get approvalSteps;

  @BuiltValueField(wireName: r'checklist_items')
  BuiltList<PermitChecklistTemplateItemInput>? get checklistItems;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'expected_version')
  int get expectedVersion;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'permit_type')
  UpdatePermitTemplateRequestPermitTypeEnum? get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  UpdatePermitTemplateRequest._();

  factory UpdatePermitTemplateRequest(
          [void updates(UpdatePermitTemplateRequestBuilder b)]) =
      _$UpdatePermitTemplateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatePermitTemplateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatePermitTemplateRequest> get serializer =>
      _$UpdatePermitTemplateRequestSerializer();
}

class _$UpdatePermitTemplateRequestSerializer
    implements PrimitiveSerializer<UpdatePermitTemplateRequest> {
  @override
  final Iterable<Type> types = const [
    UpdatePermitTemplateRequest,
    _$UpdatePermitTemplateRequest
  ];

  @override
  final String wireName = r'UpdatePermitTemplateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatePermitTemplateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.approvalSteps != null) {
      yield r'approval_steps';
      yield serializers.serialize(
        object.approvalSteps,
        specifiedType: const FullType.nullable(
            BuiltList, [FullType(PermitApprovalTemplateStepInput)]),
      );
    }
    if (object.checklistItems != null) {
      yield r'checklist_items';
      yield serializers.serialize(
        object.checklistItems,
        specifiedType: const FullType.nullable(
            BuiltList, [FullType(PermitChecklistTemplateItemInput)]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'expected_version';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(int),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.permitType != null) {
      yield r'permit_type';
      yield serializers.serialize(
        object.permitType,
        specifiedType:
            const FullType.nullable(UpdatePermitTemplateRequestPermitTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdatePermitTemplateRequest object, {
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
    required UpdatePermitTemplateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approval_steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(PermitApprovalTemplateStepInput)]),
          ) as BuiltList<PermitApprovalTemplateStepInput>?;
          if (valueDes == null) continue;
          result.approvalSteps.replace(valueDes);
          break;
        case r'checklist_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(PermitChecklistTemplateItemInput)]),
          ) as BuiltList<PermitChecklistTemplateItemInput>?;
          if (valueDes == null) continue;
          result.checklistItems.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'expected_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedVersion = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'permit_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                UpdatePermitTemplateRequestPermitTypeEnum),
          ) as UpdatePermitTemplateRequestPermitTypeEnum?;
          if (valueDes == null) continue;
          result.permitType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdatePermitTemplateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatePermitTemplateRequestBuilder();
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

class UpdatePermitTemplateRequestPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const UpdatePermitTemplateRequestPermitTypeEnum hotWork =
      _$updatePermitTemplateRequestPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const UpdatePermitTemplateRequestPermitTypeEnum confinedSpace =
      _$updatePermitTemplateRequestPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const UpdatePermitTemplateRequestPermitTypeEnum
      electricalIsolationLoto =
      _$updatePermitTemplateRequestPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const UpdatePermitTemplateRequestPermitTypeEnum excavation =
      _$updatePermitTemplateRequestPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const UpdatePermitTemplateRequestPermitTypeEnum workingAtHeight =
      _$updatePermitTemplateRequestPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const UpdatePermitTemplateRequestPermitTypeEnum generalMaintenance =
      _$updatePermitTemplateRequestPermitTypeEnum_generalMaintenance;

  static Serializer<UpdatePermitTemplateRequestPermitTypeEnum> get serializer =>
      _$updatePermitTemplateRequestPermitTypeEnumSerializer;

  const UpdatePermitTemplateRequestPermitTypeEnum._(String name) : super(name);

  static BuiltSet<UpdatePermitTemplateRequestPermitTypeEnum> get values =>
      _$updatePermitTemplateRequestPermitTypeEnumValues;
  static UpdatePermitTemplateRequestPermitTypeEnum valueOf(String name) =>
      _$updatePermitTemplateRequestPermitTypeEnumValueOf(name);
}
