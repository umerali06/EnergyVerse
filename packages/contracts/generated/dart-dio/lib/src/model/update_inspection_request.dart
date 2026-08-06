//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/checklist_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/readings_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_inspection_request.g.dart';

/// UpdateInspectionRequest
///
/// Properties:
/// * [checklistResponses]
/// * [expectedRevision]
/// * [gpsLat]
/// * [gpsLng]
/// * [inspectionType]
/// * [notes]
/// * [readings]
/// * [title]
@BuiltValue()
abstract class UpdateInspectionRequest
    implements Built<UpdateInspectionRequest, UpdateInspectionRequestBuilder> {
  @BuiltValueField(wireName: r'checklist_responses')
  BuiltList<ChecklistResponse>? get checklistResponses;

  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'inspection_type')
  UpdateInspectionRequestInspectionTypeEnum? get inspectionType;
  // enum inspectionTypeEnum {  routine,  scheduled,  ad_hoc,  };

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'readings')
  ReadingsInput? get readings;

  @BuiltValueField(wireName: r'title')
  String? get title;

  UpdateInspectionRequest._();

  factory UpdateInspectionRequest(
          [void updates(UpdateInspectionRequestBuilder b)]) =
      _$UpdateInspectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateInspectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateInspectionRequest> get serializer =>
      _$UpdateInspectionRequestSerializer();
}

class _$UpdateInspectionRequestSerializer
    implements PrimitiveSerializer<UpdateInspectionRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateInspectionRequest,
    _$UpdateInspectionRequest
  ];

  @override
  final String wireName = r'UpdateInspectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateInspectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checklistResponses != null) {
      yield r'checklist_responses';
      yield serializers.serialize(
        object.checklistResponses,
        specifiedType:
            const FullType.nullable(BuiltList, [FullType(ChecklistResponse)]),
      );
    }
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
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
    if (object.inspectionType != null) {
      yield r'inspection_type';
      yield serializers.serialize(
        object.inspectionType,
        specifiedType:
            const FullType.nullable(UpdateInspectionRequestInspectionTypeEnum),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.readings != null) {
      yield r'readings';
      yield serializers.serialize(
        object.readings,
        specifiedType: const FullType.nullable(ReadingsInput),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateInspectionRequest object, {
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
    required UpdateInspectionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checklist_responses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(ChecklistResponse)]),
          ) as BuiltList<ChecklistResponse>?;
          if (valueDes == null) continue;
          result.checklistResponses.replace(valueDes);
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expectedRevision = valueDes;
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
        case r'inspection_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                UpdateInspectionRequestInspectionTypeEnum),
          ) as UpdateInspectionRequestInspectionTypeEnum?;
          if (valueDes == null) continue;
          result.inspectionType = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'readings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReadingsInput),
          ) as ReadingsInput?;
          if (valueDes == null) continue;
          result.readings.replace(valueDes);
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateInspectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateInspectionRequestBuilder();
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

class UpdateInspectionRequestInspectionTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'routine')
  static const UpdateInspectionRequestInspectionTypeEnum routine =
      _$updateInspectionRequestInspectionTypeEnum_routine;
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const UpdateInspectionRequestInspectionTypeEnum scheduled =
      _$updateInspectionRequestInspectionTypeEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'ad_hoc')
  static const UpdateInspectionRequestInspectionTypeEnum adHoc =
      _$updateInspectionRequestInspectionTypeEnum_adHoc;

  static Serializer<UpdateInspectionRequestInspectionTypeEnum> get serializer =>
      _$updateInspectionRequestInspectionTypeEnumSerializer;

  const UpdateInspectionRequestInspectionTypeEnum._(String name) : super(name);

  static BuiltSet<UpdateInspectionRequestInspectionTypeEnum> get values =>
      _$updateInspectionRequestInspectionTypeEnumValues;
  static UpdateInspectionRequestInspectionTypeEnum valueOf(String name) =>
      _$updateInspectionRequestInspectionTypeEnumValueOf(name);
}
