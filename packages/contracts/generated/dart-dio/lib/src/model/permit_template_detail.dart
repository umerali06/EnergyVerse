//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_checklist_template_item_response.dart';
import 'package:fev_api_client/src/model/permit_approval_template_step_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_template_detail.g.dart';

/// PermitTemplateDetail
///
/// Properties:
/// * [approvalSteps]
/// * [checklistItems]
/// * [createdAt]
/// * [description]
/// * [id]
/// * [name]
/// * [permitType]
/// * [updatedAt]
/// * [version]
@BuiltValue()
abstract class PermitTemplateDetail
    implements Built<PermitTemplateDetail, PermitTemplateDetailBuilder> {
  @BuiltValueField(wireName: r'approval_steps')
  BuiltList<PermitApprovalTemplateStepResponse> get approvalSteps;

  @BuiltValueField(wireName: r'checklist_items')
  BuiltList<PermitChecklistTemplateItemResponse> get checklistItems;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'permit_type')
  PermitTemplateDetailPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'version')
  int get version;

  PermitTemplateDetail._();

  factory PermitTemplateDetail([void updates(PermitTemplateDetailBuilder b)]) =
      _$PermitTemplateDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitTemplateDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitTemplateDetail> get serializer =>
      _$PermitTemplateDetailSerializer();
}

class _$PermitTemplateDetailSerializer
    implements PrimitiveSerializer<PermitTemplateDetail> {
  @override
  final Iterable<Type> types = const [
    PermitTemplateDetail,
    _$PermitTemplateDetail
  ];

  @override
  final String wireName = r'PermitTemplateDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitTemplateDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approval_steps';
    yield serializers.serialize(
      object.approvalSteps,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitApprovalTemplateStepResponse)]),
    );
    yield r'checklist_items';
    yield serializers.serialize(
      object.checklistItems,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitChecklistTemplateItemResponse)]),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(PermitTemplateDetailPermitTypeEnum),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitTemplateDetail object, {
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
    required PermitTemplateDetailBuilder result,
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
                BuiltList, [FullType(PermitApprovalTemplateStepResponse)]),
          ) as BuiltList<PermitApprovalTemplateStepResponse>;
          result.approvalSteps.replace(valueDes);
          break;
        case r'checklist_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitChecklistTemplateItemResponse)]),
          ) as BuiltList<PermitChecklistTemplateItemResponse>;
          result.checklistItems.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
            specifiedType: const FullType(PermitTemplateDetailPermitTypeEnum),
          ) as PermitTemplateDetailPermitTypeEnum;
          result.permitType = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitTemplateDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitTemplateDetailBuilder();
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

class PermitTemplateDetailPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const PermitTemplateDetailPermitTypeEnum hotWork =
      _$permitTemplateDetailPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const PermitTemplateDetailPermitTypeEnum confinedSpace =
      _$permitTemplateDetailPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const PermitTemplateDetailPermitTypeEnum electricalIsolationLoto =
      _$permitTemplateDetailPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const PermitTemplateDetailPermitTypeEnum excavation =
      _$permitTemplateDetailPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const PermitTemplateDetailPermitTypeEnum workingAtHeight =
      _$permitTemplateDetailPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const PermitTemplateDetailPermitTypeEnum generalMaintenance =
      _$permitTemplateDetailPermitTypeEnum_generalMaintenance;

  static Serializer<PermitTemplateDetailPermitTypeEnum> get serializer =>
      _$permitTemplateDetailPermitTypeEnumSerializer;

  const PermitTemplateDetailPermitTypeEnum._(String name) : super(name);

  static BuiltSet<PermitTemplateDetailPermitTypeEnum> get values =>
      _$permitTemplateDetailPermitTypeEnumValues;
  static PermitTemplateDetailPermitTypeEnum valueOf(String name) =>
      _$permitTemplateDetailPermitTypeEnumValueOf(name);
}
