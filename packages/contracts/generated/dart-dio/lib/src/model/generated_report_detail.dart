//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/report_narrative_response.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generated_report_detail.g.dart';

/// GeneratedReportDetail
///
/// Properties:
/// * [aiModel]
/// * [createdAt]
/// * [createdBy]
/// * [finalizationAttestation]
/// * [finalizedAt]
/// * [finalizedBy]
/// * [id]
/// * [narrative]
/// * [reportType]
/// * [revision]
/// * [sourceId]
/// * [sourceRevision]
/// * [sourceSnapshot]
/// * [status]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class GeneratedReportDetail
    implements Built<GeneratedReportDetail, GeneratedReportDetailBuilder> {
  @BuiltValueField(wireName: r'ai_model')
  String get aiModel;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'finalization_attestation')
  bool get finalizationAttestation;

  @BuiltValueField(wireName: r'finalized_at')
  DateTime? get finalizedAt;

  @BuiltValueField(wireName: r'finalized_by')
  String? get finalizedBy;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'narrative')
  ReportNarrativeResponse get narrative;

  @BuiltValueField(wireName: r'report_type')
  GeneratedReportDetailReportTypeEnum get reportType;
  // enum reportTypeEnum {  inspection,  maintenance,  safety,  executive_summary,  asset_health,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'source_id')
  String? get sourceId;

  @BuiltValueField(wireName: r'source_revision')
  int? get sourceRevision;

  @BuiltValueField(wireName: r'source_snapshot')
  BuiltMap<String, JsonObject?> get sourceSnapshot;

  @BuiltValueField(wireName: r'status')
  GeneratedReportDetailStatusEnum get status;
  // enum statusEnum {  draft,  finalized,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  GeneratedReportDetail._();

  factory GeneratedReportDetail(
      [void updates(GeneratedReportDetailBuilder b)]) = _$GeneratedReportDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeneratedReportDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeneratedReportDetail> get serializer =>
      _$GeneratedReportDetailSerializer();
}

class _$GeneratedReportDetailSerializer
    implements PrimitiveSerializer<GeneratedReportDetail> {
  @override
  final Iterable<Type> types = const [
    GeneratedReportDetail,
    _$GeneratedReportDetail
  ];

  @override
  final String wireName = r'GeneratedReportDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeneratedReportDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ai_model';
    yield serializers.serialize(
      object.aiModel,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_by';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(String),
    );
    yield r'finalization_attestation';
    yield serializers.serialize(
      object.finalizationAttestation,
      specifiedType: const FullType(bool),
    );
    if (object.finalizedAt != null) {
      yield r'finalized_at';
      yield serializers.serialize(
        object.finalizedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.finalizedBy != null) {
      yield r'finalized_by';
      yield serializers.serialize(
        object.finalizedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'narrative';
    yield serializers.serialize(
      object.narrative,
      specifiedType: const FullType(ReportNarrativeResponse),
    );
    yield r'report_type';
    yield serializers.serialize(
      object.reportType,
      specifiedType: const FullType(GeneratedReportDetailReportTypeEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.sourceId != null) {
      yield r'source_id';
      yield serializers.serialize(
        object.sourceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sourceRevision != null) {
      yield r'source_revision';
      yield serializers.serialize(
        object.sourceRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'source_snapshot';
    yield serializers.serialize(
      object.sourceSnapshot,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GeneratedReportDetailStatusEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeneratedReportDetail object, {
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
    required GeneratedReportDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ai_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.aiModel = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdBy = valueDes;
          break;
        case r'finalization_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.finalizationAttestation = valueDes;
          break;
        case r'finalized_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.finalizedAt = valueDes;
          break;
        case r'finalized_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.finalizedBy = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'narrative':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReportNarrativeResponse),
          ) as ReportNarrativeResponse;
          result.narrative.replace(valueDes);
          break;
        case r'report_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeneratedReportDetailReportTypeEnum),
          ) as GeneratedReportDetailReportTypeEnum;
          result.reportType = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceId = valueDes;
          break;
        case r'source_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.sourceRevision = valueDes;
          break;
        case r'source_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.sourceSnapshot.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeneratedReportDetailStatusEnum),
          ) as GeneratedReportDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeneratedReportDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeneratedReportDetailBuilder();
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

class GeneratedReportDetailReportTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'inspection')
  static const GeneratedReportDetailReportTypeEnum inspection =
      _$generatedReportDetailReportTypeEnum_inspection;
  @BuiltValueEnumConst(wireName: r'maintenance')
  static const GeneratedReportDetailReportTypeEnum maintenance =
      _$generatedReportDetailReportTypeEnum_maintenance;
  @BuiltValueEnumConst(wireName: r'safety')
  static const GeneratedReportDetailReportTypeEnum safety =
      _$generatedReportDetailReportTypeEnum_safety;
  @BuiltValueEnumConst(wireName: r'executive_summary')
  static const GeneratedReportDetailReportTypeEnum executiveSummary =
      _$generatedReportDetailReportTypeEnum_executiveSummary;
  @BuiltValueEnumConst(wireName: r'asset_health')
  static const GeneratedReportDetailReportTypeEnum assetHealth =
      _$generatedReportDetailReportTypeEnum_assetHealth;

  static Serializer<GeneratedReportDetailReportTypeEnum> get serializer =>
      _$generatedReportDetailReportTypeEnumSerializer;

  const GeneratedReportDetailReportTypeEnum._(String name) : super(name);

  static BuiltSet<GeneratedReportDetailReportTypeEnum> get values =>
      _$generatedReportDetailReportTypeEnumValues;
  static GeneratedReportDetailReportTypeEnum valueOf(String name) =>
      _$generatedReportDetailReportTypeEnumValueOf(name);
}

class GeneratedReportDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const GeneratedReportDetailStatusEnum draft =
      _$generatedReportDetailStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'finalized')
  static const GeneratedReportDetailStatusEnum finalized =
      _$generatedReportDetailStatusEnum_finalized;

  static Serializer<GeneratedReportDetailStatusEnum> get serializer =>
      _$generatedReportDetailStatusEnumSerializer;

  const GeneratedReportDetailStatusEnum._(String name) : super(name);

  static BuiltSet<GeneratedReportDetailStatusEnum> get values =>
      _$generatedReportDetailStatusEnumValues;
  static GeneratedReportDetailStatusEnum valueOf(String name) =>
      _$generatedReportDetailStatusEnumValueOf(name);
}
