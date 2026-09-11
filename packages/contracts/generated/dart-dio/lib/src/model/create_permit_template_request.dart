//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/permit_checklist_template_item_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_approval_template_step_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_permit_template_request.g.dart';

/// CreatePermitTemplateRequest
///
/// Properties:
/// * [approvalSteps]
/// * [checklistItems]
/// * [description]
/// * [name]
/// * [permitType]
@BuiltValue()
abstract class CreatePermitTemplateRequest
    implements
        Built<CreatePermitTemplateRequest, CreatePermitTemplateRequestBuilder> {
  @BuiltValueField(wireName: r'approval_steps')
  BuiltList<PermitApprovalTemplateStepInput> get approvalSteps;

  @BuiltValueField(wireName: r'checklist_items')
  BuiltList<PermitChecklistTemplateItemInput> get checklistItems;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'permit_type')
  CreatePermitTemplateRequestPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  CreatePermitTemplateRequest._();

  factory CreatePermitTemplateRequest(
          [void updates(CreatePermitTemplateRequestBuilder b)]) =
      _$CreatePermitTemplateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePermitTemplateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePermitTemplateRequest> get serializer =>
      _$CreatePermitTemplateRequestSerializer();
}

class _$CreatePermitTemplateRequestSerializer
    implements PrimitiveSerializer<CreatePermitTemplateRequest> {
  @override
  final Iterable<Type> types = const [
    CreatePermitTemplateRequest,
    _$CreatePermitTemplateRequest
  ];

  @override
  final String wireName = r'CreatePermitTemplateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePermitTemplateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approval_steps';
    yield serializers.serialize(
      object.approvalSteps,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitApprovalTemplateStepInput)]),
    );
    yield r'checklist_items';
    yield serializers.serialize(
      object.checklistItems,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitChecklistTemplateItemInput)]),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(CreatePermitTemplateRequestPermitTypeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePermitTemplateRequest object, {
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
    required CreatePermitTemplateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approval_steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitApprovalTemplateStepInput)]),
          ) as BuiltList<PermitApprovalTemplateStepInput>;
          result.approvalSteps.replace(valueDes);
          break;
        case r'checklist_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitChecklistTemplateItemInput)]),
          ) as BuiltList<PermitChecklistTemplateItemInput>;
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'permit_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(CreatePermitTemplateRequestPermitTypeEnum),
          ) as CreatePermitTemplateRequestPermitTypeEnum;
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
  CreatePermitTemplateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePermitTemplateRequestBuilder();
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

class CreatePermitTemplateRequestPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const CreatePermitTemplateRequestPermitTypeEnum hotWork =
      _$createPermitTemplateRequestPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const CreatePermitTemplateRequestPermitTypeEnum confinedSpace =
      _$createPermitTemplateRequestPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const CreatePermitTemplateRequestPermitTypeEnum
      electricalIsolationLoto =
      _$createPermitTemplateRequestPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const CreatePermitTemplateRequestPermitTypeEnum excavation =
      _$createPermitTemplateRequestPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const CreatePermitTemplateRequestPermitTypeEnum workingAtHeight =
      _$createPermitTemplateRequestPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const CreatePermitTemplateRequestPermitTypeEnum generalMaintenance =
      _$createPermitTemplateRequestPermitTypeEnum_generalMaintenance;

  static Serializer<CreatePermitTemplateRequestPermitTypeEnum> get serializer =>
      _$createPermitTemplateRequestPermitTypeEnumSerializer;

  const CreatePermitTemplateRequestPermitTypeEnum._(String name) : super(name);

  static BuiltSet<CreatePermitTemplateRequestPermitTypeEnum> get values =>
      _$createPermitTemplateRequestPermitTypeEnumValues;
  static CreatePermitTemplateRequestPermitTypeEnum valueOf(String name) =>
      _$createPermitTemplateRequestPermitTypeEnumValueOf(name);
}
