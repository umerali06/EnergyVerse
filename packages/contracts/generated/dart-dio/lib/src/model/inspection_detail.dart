//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/annotation_response.dart';
import 'package:fev_api_client/src/model/readings_response.dart';
import 'package:fev_api_client/src/model/signature_response.dart';
import 'package:fev_api_client/src/model/checklist_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/ar_measurement_response.dart';
import 'package:fev_api_client/src/model/inspection_media_response.dart';
import 'package:fev_api_client/src/model/checklist_template_item.dart';
import 'package:fev_api_client/src/model/voice_note_response.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inspection_detail.g.dart';

/// InspectionDetail
///
/// Properties:
/// * [aiAnalysis]
/// * [annotations]
/// * [arMeasurements]
/// * [areaId]
/// * [assetId]
/// * [checklistItemsSnapshot]
/// * [checklistResponses]
/// * [checklistTemplateId]
/// * [checklistTemplateVersion]
/// * [clientCreatedAt]
/// * [completedAt]
/// * [createdAt]
/// * [deviceId]
/// * [facilityId]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [inspectionType]
/// * [inspectorId]
/// * [media]
/// * [notes]
/// * [origin]
/// * [readings]
/// * [revision]
/// * [signature]
/// * [startedAt]
/// * [status]
/// * [title]
/// * [updatedAt]
/// * [voiceNotes]
@BuiltValue()
abstract class InspectionDetail
    implements Built<InspectionDetail, InspectionDetailBuilder> {
  @BuiltValueField(wireName: r'ai_analysis')
  BuiltMap<String, JsonObject?>? get aiAnalysis;

  @BuiltValueField(wireName: r'annotations')
  BuiltList<AnnotationResponse>? get annotations;

  @BuiltValueField(wireName: r'ar_measurements')
  BuiltList<ArMeasurementResponse>? get arMeasurements;

  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'checklist_items_snapshot')
  BuiltList<ChecklistTemplateItem>? get checklistItemsSnapshot;

  @BuiltValueField(wireName: r'checklist_responses')
  BuiltList<ChecklistResponse>? get checklistResponses;

  @BuiltValueField(wireName: r'checklist_template_id')
  String? get checklistTemplateId;

  @BuiltValueField(wireName: r'checklist_template_version')
  int? get checklistTemplateVersion;

  @BuiltValueField(wireName: r'client_created_at')
  DateTime get clientCreatedAt;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'inspection_type')
  InspectionDetailInspectionTypeEnum get inspectionType;
  // enum inspectionTypeEnum {  routine,  scheduled,  ad_hoc,  };

  @BuiltValueField(wireName: r'inspector_id')
  String get inspectorId;

  @BuiltValueField(wireName: r'media')
  BuiltList<InspectionMediaResponse>? get media;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'origin')
  String? get origin;

  @BuiltValueField(wireName: r'readings')
  ReadingsResponse? get readings;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'signature')
  SignatureResponse? get signature;

  @BuiltValueField(wireName: r'started_at')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'status')
  InspectionDetailStatusEnum get status;
  // enum statusEnum {  draft,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'voice_notes')
  BuiltList<VoiceNoteResponse>? get voiceNotes;

  InspectionDetail._();

  factory InspectionDetail([void updates(InspectionDetailBuilder b)]) =
      _$InspectionDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InspectionDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InspectionDetail> get serializer =>
      _$InspectionDetailSerializer();
}

class _$InspectionDetailSerializer
    implements PrimitiveSerializer<InspectionDetail> {
  @override
  final Iterable<Type> types = const [InspectionDetail, _$InspectionDetail];

  @override
  final String wireName = r'InspectionDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InspectionDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.aiAnalysis != null) {
      yield r'ai_analysis';
      yield serializers.serialize(
        object.aiAnalysis,
        specifiedType: const FullType.nullable(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.annotations != null) {
      yield r'annotations';
      yield serializers.serialize(
        object.annotations,
        specifiedType:
            const FullType(BuiltList, [FullType(AnnotationResponse)]),
      );
    }
    if (object.arMeasurements != null) {
      yield r'ar_measurements';
      yield serializers.serialize(
        object.arMeasurements,
        specifiedType:
            const FullType(BuiltList, [FullType(ArMeasurementResponse)]),
      );
    }
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.checklistItemsSnapshot != null) {
      yield r'checklist_items_snapshot';
      yield serializers.serialize(
        object.checklistItemsSnapshot,
        specifiedType:
            const FullType(BuiltList, [FullType(ChecklistTemplateItem)]),
      );
    }
    if (object.checklistResponses != null) {
      yield r'checklist_responses';
      yield serializers.serialize(
        object.checklistResponses,
        specifiedType: const FullType(BuiltList, [FullType(ChecklistResponse)]),
      );
    }
    if (object.checklistTemplateId != null) {
      yield r'checklist_template_id';
      yield serializers.serialize(
        object.checklistTemplateId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.checklistTemplateVersion != null) {
      yield r'checklist_template_version';
      yield serializers.serialize(
        object.checklistTemplateVersion,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'client_created_at';
    yield serializers.serialize(
      object.clientCreatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    if (object.gpsLat != null) {
      yield r'gps_lat';
      yield serializers.serialize(
        object.gpsLat,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.gpsLng != null) {
      yield r'gps_lng';
      yield serializers.serialize(
        object.gpsLng,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'inspection_type';
    yield serializers.serialize(
      object.inspectionType,
      specifiedType: const FullType(InspectionDetailInspectionTypeEnum),
    );
    yield r'inspector_id';
    yield serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType(String),
    );
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType:
            const FullType(BuiltList, [FullType(InspectionMediaResponse)]),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.origin != null) {
      yield r'origin';
      yield serializers.serialize(
        object.origin,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.readings != null) {
      yield r'readings';
      yield serializers.serialize(
        object.readings,
        specifiedType: const FullType.nullable(ReadingsResponse),
      );
    }
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.signature != null) {
      yield r'signature';
      yield serializers.serialize(
        object.signature,
        specifiedType: const FullType.nullable(SignatureResponse),
      );
    }
    if (object.startedAt != null) {
      yield r'started_at';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(InspectionDetailStatusEnum),
    );
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.voiceNotes != null) {
      yield r'voice_notes';
      yield serializers.serialize(
        object.voiceNotes,
        specifiedType: const FullType(BuiltList, [FullType(VoiceNoteResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InspectionDetail object, {
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
    required InspectionDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ai_analysis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.aiAnalysis.replace(valueDes);
          break;
        case r'annotations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AnnotationResponse)]),
          ) as BuiltList<AnnotationResponse>;
          result.annotations.replace(valueDes);
          break;
        case r'ar_measurements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ArMeasurementResponse)]),
          ) as BuiltList<ArMeasurementResponse>;
          result.arMeasurements.replace(valueDes);
          break;
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
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'checklist_items_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ChecklistTemplateItem)]),
          ) as BuiltList<ChecklistTemplateItem>;
          result.checklistItemsSnapshot.replace(valueDes);
          break;
        case r'checklist_responses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ChecklistResponse)]),
          ) as BuiltList<ChecklistResponse>;
          result.checklistResponses.replace(valueDes);
          break;
        case r'checklist_template_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistTemplateId = valueDes;
          break;
        case r'checklist_template_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.checklistTemplateVersion = valueDes;
          break;
        case r'client_created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.clientCreatedAt = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'gps_lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLat = valueDes;
          break;
        case r'gps_lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLng = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'inspection_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InspectionDetailInspectionTypeEnum),
          ) as InspectionDetailInspectionTypeEnum;
          result.inspectionType = valueDes;
          break;
        case r'inspector_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(InspectionMediaResponse)]),
          ) as BuiltList<InspectionMediaResponse>;
          result.media.replace(valueDes);
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.origin = valueDes;
          break;
        case r'readings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReadingsResponse),
          ) as ReadingsResponse?;
          if (valueDes == null) continue;
          result.readings.replace(valueDes);
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'signature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SignatureResponse),
          ) as SignatureResponse?;
          if (valueDes == null) continue;
          result.signature.replace(valueDes);
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InspectionDetailStatusEnum),
          ) as InspectionDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'voice_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(VoiceNoteResponse)]),
          ) as BuiltList<VoiceNoteResponse>;
          result.voiceNotes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InspectionDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InspectionDetailBuilder();
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

class InspectionDetailInspectionTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'routine')
  static const InspectionDetailInspectionTypeEnum routine =
      _$inspectionDetailInspectionTypeEnum_routine;
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const InspectionDetailInspectionTypeEnum scheduled =
      _$inspectionDetailInspectionTypeEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'ad_hoc')
  static const InspectionDetailInspectionTypeEnum adHoc =
      _$inspectionDetailInspectionTypeEnum_adHoc;

  static Serializer<InspectionDetailInspectionTypeEnum> get serializer =>
      _$inspectionDetailInspectionTypeEnumSerializer;

  const InspectionDetailInspectionTypeEnum._(String name) : super(name);

  static BuiltSet<InspectionDetailInspectionTypeEnum> get values =>
      _$inspectionDetailInspectionTypeEnumValues;
  static InspectionDetailInspectionTypeEnum valueOf(String name) =>
      _$inspectionDetailInspectionTypeEnumValueOf(name);
}

class InspectionDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const InspectionDetailStatusEnum draft =
      _$inspectionDetailStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const InspectionDetailStatusEnum inProgress =
      _$inspectionDetailStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const InspectionDetailStatusEnum completed =
      _$inspectionDetailStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const InspectionDetailStatusEnum cancelled =
      _$inspectionDetailStatusEnum_cancelled;

  static Serializer<InspectionDetailStatusEnum> get serializer =>
      _$inspectionDetailStatusEnumSerializer;

  const InspectionDetailStatusEnum._(String name) : super(name);

  static BuiltSet<InspectionDetailStatusEnum> get values =>
      _$inspectionDetailStatusEnumValues;
  static InspectionDetailStatusEnum valueOf(String name) =>
      _$inspectionDetailStatusEnumValueOf(name);
}
