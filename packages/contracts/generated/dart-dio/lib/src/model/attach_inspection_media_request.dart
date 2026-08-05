//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attach_inspection_media_request.g.dart';

/// AttachInspectionMediaRequest
///
/// Properties:
/// * [beforeAfterTag]
/// * [capturedAt]
/// * [checklistItemId]
/// * [contentType]
/// * [filename]
/// * [gpsLat]
/// * [gpsLng]
/// * [kind]
/// * [localId]
/// * [size]
@BuiltValue()
abstract class AttachInspectionMediaRequest
    implements
        Built<AttachInspectionMediaRequest,
            AttachInspectionMediaRequestBuilder> {
  @BuiltValueField(wireName: r'before_after_tag')
  AttachInspectionMediaRequestBeforeAfterTagEnum? get beforeAfterTag;
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

  @BuiltValueField(wireName: r'kind')
  AttachInspectionMediaRequestKindEnum get kind;
  // enum kindEnum {  photo,  video,  };

  @BuiltValueField(wireName: r'local_id')
  String get localId;

  @BuiltValueField(wireName: r'size')
  int get size;

  AttachInspectionMediaRequest._();

  factory AttachInspectionMediaRequest(
          [void updates(AttachInspectionMediaRequestBuilder b)]) =
      _$AttachInspectionMediaRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttachInspectionMediaRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttachInspectionMediaRequest> get serializer =>
      _$AttachInspectionMediaRequestSerializer();
}

class _$AttachInspectionMediaRequestSerializer
    implements PrimitiveSerializer<AttachInspectionMediaRequest> {
  @override
  final Iterable<Type> types = const [
    AttachInspectionMediaRequest,
    _$AttachInspectionMediaRequest
  ];

  @override
  final String wireName = r'AttachInspectionMediaRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttachInspectionMediaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beforeAfterTag != null) {
      yield r'before_after_tag';
      yield serializers.serialize(
        object.beforeAfterTag,
        specifiedType: const FullType.nullable(
            AttachInspectionMediaRequestBeforeAfterTagEnum),
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
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AttachInspectionMediaRequestKindEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AttachInspectionMediaRequest object, {
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
    required AttachInspectionMediaRequestBuilder result,
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
                AttachInspectionMediaRequestBeforeAfterTagEnum),
          ) as AttachInspectionMediaRequestBeforeAfterTagEnum?;
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AttachInspectionMediaRequestKindEnum),
          ) as AttachInspectionMediaRequestKindEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttachInspectionMediaRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttachInspectionMediaRequestBuilder();
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

class AttachInspectionMediaRequestBeforeAfterTagEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'before')
  static const AttachInspectionMediaRequestBeforeAfterTagEnum before =
      _$attachInspectionMediaRequestBeforeAfterTagEnum_before;
  @BuiltValueEnumConst(wireName: r'after')
  static const AttachInspectionMediaRequestBeforeAfterTagEnum after =
      _$attachInspectionMediaRequestBeforeAfterTagEnum_after;

  static Serializer<AttachInspectionMediaRequestBeforeAfterTagEnum>
      get serializer =>
          _$attachInspectionMediaRequestBeforeAfterTagEnumSerializer;

  const AttachInspectionMediaRequestBeforeAfterTagEnum._(String name)
      : super(name);

  static BuiltSet<AttachInspectionMediaRequestBeforeAfterTagEnum> get values =>
      _$attachInspectionMediaRequestBeforeAfterTagEnumValues;
  static AttachInspectionMediaRequestBeforeAfterTagEnum valueOf(String name) =>
      _$attachInspectionMediaRequestBeforeAfterTagEnumValueOf(name);
}

class AttachInspectionMediaRequestKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'photo')
  static const AttachInspectionMediaRequestKindEnum photo =
      _$attachInspectionMediaRequestKindEnum_photo;
  @BuiltValueEnumConst(wireName: r'video')
  static const AttachInspectionMediaRequestKindEnum video =
      _$attachInspectionMediaRequestKindEnum_video;

  static Serializer<AttachInspectionMediaRequestKindEnum> get serializer =>
      _$attachInspectionMediaRequestKindEnumSerializer;

  const AttachInspectionMediaRequestKindEnum._(String name) : super(name);

  static BuiltSet<AttachInspectionMediaRequestKindEnum> get values =>
      _$attachInspectionMediaRequestKindEnumValues;
  static AttachInspectionMediaRequestKindEnum valueOf(String name) =>
      _$attachInspectionMediaRequestKindEnumValueOf(name);
}
