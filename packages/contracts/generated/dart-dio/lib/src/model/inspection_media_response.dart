//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inspection_media_response.g.dart';

/// InspectionMediaResponse
///
/// Properties:
/// * [beforeAfterTag]
/// * [capturedAt]
/// * [checklistItemId]
/// * [contentType]
/// * [filename]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [kind]
/// * [localId]
/// * [size]
/// * [uploadedAt]
/// * [uploadedBy]
/// * [url]
@BuiltValue()
abstract class InspectionMediaResponse
    implements Built<InspectionMediaResponse, InspectionMediaResponseBuilder> {
  @BuiltValueField(wireName: r'before_after_tag')
  InspectionMediaResponseBeforeAfterTagEnum? get beforeAfterTag;
  // enum beforeAfterTagEnum {  before,  after,  };

  @BuiltValueField(wireName: r'captured_at')
  DateTime get capturedAt;

  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  InspectionMediaResponseKindEnum get kind;
  // enum kindEnum {  photo,  video,  };

  @BuiltValueField(wireName: r'local_id')
  String get localId;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'uploaded_by')
  String get uploadedBy;

  @BuiltValueField(wireName: r'url')
  String get url;

  InspectionMediaResponse._();

  factory InspectionMediaResponse(
          [void updates(InspectionMediaResponseBuilder b)]) =
      _$InspectionMediaResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InspectionMediaResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InspectionMediaResponse> get serializer =>
      _$InspectionMediaResponseSerializer();
}

class _$InspectionMediaResponseSerializer
    implements PrimitiveSerializer<InspectionMediaResponse> {
  @override
  final Iterable<Type> types = const [
    InspectionMediaResponse,
    _$InspectionMediaResponse
  ];

  @override
  final String wireName = r'InspectionMediaResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InspectionMediaResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beforeAfterTag != null) {
      yield r'before_after_tag';
      yield serializers.serialize(
        object.beforeAfterTag,
        specifiedType:
            const FullType.nullable(InspectionMediaResponseBeforeAfterTagEnum),
      );
    }
    yield r'captured_at';
    yield serializers.serialize(
      object.capturedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'filename';
    yield serializers.serialize(
      object.filename,
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
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(InspectionMediaResponseKindEnum),
    );
    yield r'local_id';
    yield serializers.serialize(
      object.localId,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'uploaded_at';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'uploaded_by';
    yield serializers.serialize(
      object.uploadedBy,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InspectionMediaResponse object, {
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
    required InspectionMediaResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'before_after_tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                InspectionMediaResponseBeforeAfterTagEnum),
          ) as InspectionMediaResponseBeforeAfterTagEnum?;
          if (valueDes == null) continue;
          result.beforeAfterTag = valueDes;
          break;
        case r'captured_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.capturedAt = valueDes;
          break;
        case r'checklist_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistItemId = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'filename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filename = valueDes;
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InspectionMediaResponseKindEnum),
          ) as InspectionMediaResponseKindEnum;
          result.kind = valueDes;
          break;
        case r'local_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.localId = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.uploadedAt = valueDes;
          break;
        case r'uploaded_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadedBy = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InspectionMediaResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InspectionMediaResponseBuilder();
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

class InspectionMediaResponseBeforeAfterTagEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'before')
  static const InspectionMediaResponseBeforeAfterTagEnum before =
      _$inspectionMediaResponseBeforeAfterTagEnum_before;
  @BuiltValueEnumConst(wireName: r'after')
  static const InspectionMediaResponseBeforeAfterTagEnum after =
      _$inspectionMediaResponseBeforeAfterTagEnum_after;

  static Serializer<InspectionMediaResponseBeforeAfterTagEnum> get serializer =>
      _$inspectionMediaResponseBeforeAfterTagEnumSerializer;

  const InspectionMediaResponseBeforeAfterTagEnum._(String name) : super(name);

  static BuiltSet<InspectionMediaResponseBeforeAfterTagEnum> get values =>
      _$inspectionMediaResponseBeforeAfterTagEnumValues;
  static InspectionMediaResponseBeforeAfterTagEnum valueOf(String name) =>
      _$inspectionMediaResponseBeforeAfterTagEnumValueOf(name);
}

class InspectionMediaResponseKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'photo')
  static const InspectionMediaResponseKindEnum photo =
      _$inspectionMediaResponseKindEnum_photo;
  @BuiltValueEnumConst(wireName: r'video')
  static const InspectionMediaResponseKindEnum video =
      _$inspectionMediaResponseKindEnum_video;

  static Serializer<InspectionMediaResponseKindEnum> get serializer =>
      _$inspectionMediaResponseKindEnumSerializer;

  const InspectionMediaResponseKindEnum._(String name) : super(name);

  static BuiltSet<InspectionMediaResponseKindEnum> get values =>
      _$inspectionMediaResponseKindEnumValues;
  static InspectionMediaResponseKindEnum valueOf(String name) =>
      _$inspectionMediaResponseKindEnumValueOf(name);
}
