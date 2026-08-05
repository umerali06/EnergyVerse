//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/annotation_point_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_annotation_request.g.dart';

/// CreateAnnotationRequest
///
/// Properties:
/// * [color]
/// * [damageType]
/// * [id]
/// * [mediaLocalId]
/// * [note]
/// * [points]
/// * [shape]
@BuiltValue()
abstract class CreateAnnotationRequest
    implements Built<CreateAnnotationRequest, CreateAnnotationRequestBuilder> {
  @BuiltValueField(wireName: r'color')
  String get color;

  @BuiltValueField(wireName: r'damage_type')
  CreateAnnotationRequestDamageTypeEnum? get damageType;
  // enum damageTypeEnum {  corrosion,  rust,  crack,  surface_damage,  paint_deterioration,  missing_bolt,  broken_component,  leak,  wear,  other,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'media_local_id')
  String get mediaLocalId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'points')
  BuiltList<AnnotationPointInput> get points;

  @BuiltValueField(wireName: r'shape')
  CreateAnnotationRequestShapeEnum get shape;
  // enum shapeEnum {  freehand,  rectangle,  circle,  arrow,  point,  };

  CreateAnnotationRequest._();

  factory CreateAnnotationRequest(
          [void updates(CreateAnnotationRequestBuilder b)]) =
      _$CreateAnnotationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAnnotationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAnnotationRequest> get serializer =>
      _$CreateAnnotationRequestSerializer();
}

class _$CreateAnnotationRequestSerializer
    implements PrimitiveSerializer<CreateAnnotationRequest> {
  @override
  final Iterable<Type> types = const [
    CreateAnnotationRequest,
    _$CreateAnnotationRequest
  ];

  @override
  final String wireName = r'CreateAnnotationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAnnotationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'color';
    yield serializers.serialize(
      object.color,
      specifiedType: const FullType(String),
    );
    if (object.damageType != null) {
      yield r'damage_type';
      yield serializers.serialize(
        object.damageType,
        specifiedType:
            const FullType.nullable(CreateAnnotationRequestDamageTypeEnum),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'media_local_id';
    yield serializers.serialize(
      object.mediaLocalId,
      specifiedType: const FullType(String),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType:
          const FullType(BuiltList, [FullType(AnnotationPointInput)]),
    );
    yield r'shape';
    yield serializers.serialize(
      object.shape,
      specifiedType: const FullType(CreateAnnotationRequestShapeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAnnotationRequest object, {
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
    required CreateAnnotationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.color = valueDes;
          break;
        case r'damage_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(CreateAnnotationRequestDamageTypeEnum),
          ) as CreateAnnotationRequestDamageTypeEnum?;
          if (valueDes == null) continue;
          result.damageType = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'media_local_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaLocalId = valueDes;
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
        case r'shape':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateAnnotationRequestShapeEnum),
          ) as CreateAnnotationRequestShapeEnum;
          result.shape = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAnnotationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAnnotationRequestBuilder();
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

class CreateAnnotationRequestDamageTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'corrosion')
  static const CreateAnnotationRequestDamageTypeEnum corrosion =
      _$createAnnotationRequestDamageTypeEnum_corrosion;
  @BuiltValueEnumConst(wireName: r'rust')
  static const CreateAnnotationRequestDamageTypeEnum rust =
      _$createAnnotationRequestDamageTypeEnum_rust;
  @BuiltValueEnumConst(wireName: r'crack')
  static const CreateAnnotationRequestDamageTypeEnum crack =
      _$createAnnotationRequestDamageTypeEnum_crack;
  @BuiltValueEnumConst(wireName: r'surface_damage')
  static const CreateAnnotationRequestDamageTypeEnum surfaceDamage =
      _$createAnnotationRequestDamageTypeEnum_surfaceDamage;
  @BuiltValueEnumConst(wireName: r'paint_deterioration')
  static const CreateAnnotationRequestDamageTypeEnum paintDeterioration =
      _$createAnnotationRequestDamageTypeEnum_paintDeterioration;
  @BuiltValueEnumConst(wireName: r'missing_bolt')
  static const CreateAnnotationRequestDamageTypeEnum missingBolt =
      _$createAnnotationRequestDamageTypeEnum_missingBolt;
  @BuiltValueEnumConst(wireName: r'broken_component')
  static const CreateAnnotationRequestDamageTypeEnum brokenComponent =
      _$createAnnotationRequestDamageTypeEnum_brokenComponent;
  @BuiltValueEnumConst(wireName: r'leak')
  static const CreateAnnotationRequestDamageTypeEnum leak =
      _$createAnnotationRequestDamageTypeEnum_leak;
  @BuiltValueEnumConst(wireName: r'wear')
  static const CreateAnnotationRequestDamageTypeEnum wear =
      _$createAnnotationRequestDamageTypeEnum_wear;
  @BuiltValueEnumConst(wireName: r'other')
  static const CreateAnnotationRequestDamageTypeEnum other =
      _$createAnnotationRequestDamageTypeEnum_other;

  static Serializer<CreateAnnotationRequestDamageTypeEnum> get serializer =>
      _$createAnnotationRequestDamageTypeEnumSerializer;

  const CreateAnnotationRequestDamageTypeEnum._(String name) : super(name);

  static BuiltSet<CreateAnnotationRequestDamageTypeEnum> get values =>
      _$createAnnotationRequestDamageTypeEnumValues;
  static CreateAnnotationRequestDamageTypeEnum valueOf(String name) =>
      _$createAnnotationRequestDamageTypeEnumValueOf(name);
}

class CreateAnnotationRequestShapeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'freehand')
  static const CreateAnnotationRequestShapeEnum freehand =
      _$createAnnotationRequestShapeEnum_freehand;
  @BuiltValueEnumConst(wireName: r'rectangle')
  static const CreateAnnotationRequestShapeEnum rectangle =
      _$createAnnotationRequestShapeEnum_rectangle;
  @BuiltValueEnumConst(wireName: r'circle')
  static const CreateAnnotationRequestShapeEnum circle =
      _$createAnnotationRequestShapeEnum_circle;
  @BuiltValueEnumConst(wireName: r'arrow')
  static const CreateAnnotationRequestShapeEnum arrow =
      _$createAnnotationRequestShapeEnum_arrow;
  @BuiltValueEnumConst(wireName: r'point')
  static const CreateAnnotationRequestShapeEnum point =
      _$createAnnotationRequestShapeEnum_point;

  static Serializer<CreateAnnotationRequestShapeEnum> get serializer =>
      _$createAnnotationRequestShapeEnumSerializer;

  const CreateAnnotationRequestShapeEnum._(String name) : super(name);

  static BuiltSet<CreateAnnotationRequestShapeEnum> get values =>
      _$createAnnotationRequestShapeEnumValues;
  static CreateAnnotationRequestShapeEnum valueOf(String name) =>
      _$createAnnotationRequestShapeEnumValueOf(name);
}
