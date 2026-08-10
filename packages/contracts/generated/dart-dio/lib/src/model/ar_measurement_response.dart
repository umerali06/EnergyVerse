//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/annotation_point_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ar_measurement_response.g.dart';

/// ArMeasurementResponse
///
/// Properties:
/// * [checklistItemId]
/// * [createdAt]
/// * [createdBy]
/// * [distanceMeters]
/// * [id]
/// * [label]
/// * [mediaLocalId]
/// * [method]
/// * [note]
/// * [points]
@BuiltValue()
abstract class ArMeasurementResponse
    implements Built<ArMeasurementResponse, ArMeasurementResponseBuilder> {
  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'distance_meters')
  num get distanceMeters;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'media_local_id')
  String? get mediaLocalId;

  @BuiltValueField(wireName: r'method')
  ArMeasurementResponseMethodEnum get method;
  // enum methodEnum {  ar,  manual,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'points')
  BuiltList<AnnotationPointResponse>? get points;

  ArMeasurementResponse._();

  factory ArMeasurementResponse(
      [void updates(ArMeasurementResponseBuilder b)]) = _$ArMeasurementResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArMeasurementResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArMeasurementResponse> get serializer =>
      _$ArMeasurementResponseSerializer();
}

class _$ArMeasurementResponseSerializer
    implements PrimitiveSerializer<ArMeasurementResponse> {
  @override
  final Iterable<Type> types = const [
    ArMeasurementResponse,
    _$ArMeasurementResponse
  ];

  @override
  final String wireName = r'ArMeasurementResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArMeasurementResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(num),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.mediaLocalId != null) {
      yield r'media_local_id';
      yield serializers.serialize(
        object.mediaLocalId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(ArMeasurementResponseMethodEnum),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.points != null) {
      yield r'points';
      yield serializers.serialize(
        object.points,
        specifiedType:
            const FullType(BuiltList, [FullType(AnnotationPointResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ArMeasurementResponse object, {
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
    required ArMeasurementResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checklist_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistItemId = valueDes;
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
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.distanceMeters = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'media_local_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mediaLocalId = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ArMeasurementResponseMethodEnum),
          ) as ArMeasurementResponseMethodEnum;
          result.method = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AnnotationPointResponse)]),
          ) as BuiltList<AnnotationPointResponse>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArMeasurementResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArMeasurementResponseBuilder();
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

class ArMeasurementResponseMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ar')
  static const ArMeasurementResponseMethodEnum ar =
      _$arMeasurementResponseMethodEnum_ar;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ArMeasurementResponseMethodEnum manual =
      _$arMeasurementResponseMethodEnum_manual;

  static Serializer<ArMeasurementResponseMethodEnum> get serializer =>
      _$arMeasurementResponseMethodEnumSerializer;

  const ArMeasurementResponseMethodEnum._(String name) : super(name);

  static BuiltSet<ArMeasurementResponseMethodEnum> get values =>
      _$arMeasurementResponseMethodEnumValues;
  static ArMeasurementResponseMethodEnum valueOf(String name) =>
      _$arMeasurementResponseMethodEnumValueOf(name);
}
