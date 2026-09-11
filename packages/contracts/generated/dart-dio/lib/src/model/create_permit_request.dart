//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_risk_assessment_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_permit_request.g.dart';

/// CreatePermitRequest
///
/// Properties:
/// * [areaId]
/// * [assetId]
/// * [description]
/// * [facilityId]
/// * [permitType]
/// * [riskAssessment]
/// * [templateId]
/// * [title]
/// * [validFrom]
/// * [validUntil]
/// * [workerIds]
@BuiltValue()
abstract class CreatePermitRequest
    implements Built<CreatePermitRequest, CreatePermitRequestBuilder> {
  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'permit_type')
  CreatePermitRequestPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  @BuiltValueField(wireName: r'risk_assessment')
  BuiltList<PermitRiskAssessmentInput> get riskAssessment;

  @BuiltValueField(wireName: r'template_id')
  String get templateId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'valid_from')
  DateTime get validFrom;

  @BuiltValueField(wireName: r'valid_until')
  DateTime get validUntil;

  @BuiltValueField(wireName: r'worker_ids')
  BuiltList<String> get workerIds;

  CreatePermitRequest._();

  factory CreatePermitRequest([void updates(CreatePermitRequestBuilder b)]) =
      _$CreatePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePermitRequest> get serializer =>
      _$CreatePermitRequestSerializer();
}

class _$CreatePermitRequestSerializer
    implements PrimitiveSerializer<CreatePermitRequest> {
  @override
  final Iterable<Type> types = const [
    CreatePermitRequest,
    _$CreatePermitRequest
  ];

  @override
  final String wireName = r'CreatePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.assetId != null) {
      yield r'asset_id';
      yield serializers.serialize(
        object.assetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(CreatePermitRequestPermitTypeEnum),
    );
    yield r'risk_assessment';
    yield serializers.serialize(
      object.riskAssessment,
      specifiedType:
          const FullType(BuiltList, [FullType(PermitRiskAssessmentInput)]),
    );
    yield r'template_id';
    yield serializers.serialize(
      object.templateId,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'valid_from';
    yield serializers.serialize(
      object.validFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'valid_until';
    yield serializers.serialize(
      object.validUntil,
      specifiedType: const FullType(DateTime),
    );
    yield r'worker_ids';
    yield serializers.serialize(
      object.workerIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePermitRequest object, {
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
    required CreatePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'area_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.areaId = valueDes;
          break;
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetId = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'permit_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatePermitRequestPermitTypeEnum),
          ) as CreatePermitRequestPermitTypeEnum;
          result.permitType = valueDes;
          break;
        case r'risk_assessment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitRiskAssessmentInput)]),
          ) as BuiltList<PermitRiskAssessmentInput>;
          result.riskAssessment.replace(valueDes);
          break;
        case r'template_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'valid_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.validFrom = valueDes;
          break;
        case r'valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.validUntil = valueDes;
          break;
        case r'worker_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.workerIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePermitRequestBuilder();
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

class CreatePermitRequestPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const CreatePermitRequestPermitTypeEnum hotWork =
      _$createPermitRequestPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const CreatePermitRequestPermitTypeEnum confinedSpace =
      _$createPermitRequestPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const CreatePermitRequestPermitTypeEnum electricalIsolationLoto =
      _$createPermitRequestPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const CreatePermitRequestPermitTypeEnum excavation =
      _$createPermitRequestPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const CreatePermitRequestPermitTypeEnum workingAtHeight =
      _$createPermitRequestPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const CreatePermitRequestPermitTypeEnum generalMaintenance =
      _$createPermitRequestPermitTypeEnum_generalMaintenance;

  static Serializer<CreatePermitRequestPermitTypeEnum> get serializer =>
      _$createPermitRequestPermitTypeEnumSerializer;

  const CreatePermitRequestPermitTypeEnum._(String name) : super(name);

  static BuiltSet<CreatePermitRequestPermitTypeEnum> get values =>
      _$createPermitRequestPermitTypeEnumValues;
  static CreatePermitRequestPermitTypeEnum valueOf(String name) =>
      _$createPermitRequestPermitTypeEnumValueOf(name);
}
