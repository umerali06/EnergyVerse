//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/annotation_point_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ar_measurement_request.g.dart';

/// CreateArMeasurementRequest
///
/// Properties:
/// * [checklistItemId]
/// * [distanceMeters]
/// * [id]
/// * [label]
/// * [mediaLocalId]
/// * [method]
/// * [note]
/// * [points]
@BuiltValue()
abstract class CreateArMeasurementRequest
    implements
        Built<CreateArMeasurementRequest, CreateArMeasurementRequestBuilder> {
  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  @BuiltValueField(wireName: r'distance_meters')
  num get distanceMeters;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'media_local_id')
  String? get mediaLocalId;

  @BuiltValueField(wireName: r'method')
  CreateArMeasurementRequestMethodEnum get method;
  // enum methodEnum {  ar,  manual,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'points')
  BuiltList<AnnotationPointInput>? get points;

  CreateArMeasurementRequest._();

  factory CreateArMeasurementRequest(
          [void updates(CreateArMeasurementRequestBuilder b)]) =
      _$CreateArMeasurementRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateArMeasurementRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateArMeasurementRequest> get serializer =>
      _$CreateArMeasurementRequestSerializer();
}

class _$CreateArMeasurementRequestSerializer
    implements PrimitiveSerializer<CreateArMeasurementRequest> {
  @override
  final Iterable<Type> types = const [
    CreateArMeasurementRequest,
    _$CreateArMeasurementRequest
  ];

  @override
  final String wireName = r'CreateArMeasurementRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateArMeasurementRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
      specifiedType: const FullType(CreateArMeasurementRequestMethodEnum),
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
            const FullType(BuiltList, [FullType(AnnotationPointInput)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateArMeasurementRequest object, {
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
    required CreateArMeasurementRequestBuilder result,
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
            specifiedType: const FullType(CreateArMeasurementRequestMethodEnum),
          ) as CreateArMeasurementRequestMethodEnum;
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
                const FullType(BuiltList, [FullType(AnnotationPointInput)]),
          ) as BuiltList<AnnotationPointInput>;
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
  CreateArMeasurementRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateArMeasurementRequestBuilder();
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

class CreateArMeasurementRequestMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ar')
  static const CreateArMeasurementRequestMethodEnum ar =
      _$createArMeasurementRequestMethodEnum_ar;
  @BuiltValueEnumConst(wireName: r'manual')
  static const CreateArMeasurementRequestMethodEnum manual =
      _$createArMeasurementRequestMethodEnum_manual;

  static Serializer<CreateArMeasurementRequestMethodEnum> get serializer =>
      _$createArMeasurementRequestMethodEnumSerializer;

  const CreateArMeasurementRequestMethodEnum._(String name) : super(name);

  static BuiltSet<CreateArMeasurementRequestMethodEnum> get values =>
      _$createArMeasurementRequestMethodEnumValues;
  static CreateArMeasurementRequestMethodEnum valueOf(String name) =>
      _$createArMeasurementRequestMethodEnumValueOf(name);
}
