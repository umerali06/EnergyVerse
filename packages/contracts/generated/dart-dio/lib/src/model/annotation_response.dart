//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/annotation_point_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'annotation_response.g.dart';

/// AnnotationResponse
///
/// Properties:
/// * [color]
/// * [confidence]
/// * [createdAt]
/// * [createdBy]
/// * [damageType]
/// * [id]
/// * [mediaLocalId]
/// * [note]
/// * [points]
/// * [shape]
/// * [source_]
@BuiltValue()
abstract class AnnotationResponse
    implements Built<AnnotationResponse, AnnotationResponseBuilder> {
  @BuiltValueField(wireName: r'color')
  String get color;

  @BuiltValueField(wireName: r'confidence')
  num? get confidence;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'damage_type')
  AnnotationResponseDamageTypeEnum? get damageType;
  // enum damageTypeEnum {  corrosion,  rust,  crack,  surface_damage,  paint_deterioration,  missing_bolt,  broken_component,  leak,  wear,  other,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'media_local_id')
  String get mediaLocalId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'points')
  BuiltList<AnnotationPointResponse> get points;

  @BuiltValueField(wireName: r'shape')
  AnnotationResponseShapeEnum get shape;
  // enum shapeEnum {  freehand,  rectangle,  circle,  arrow,  point,  };

  @BuiltValueField(wireName: r'source')
  AnnotationResponseSource_Enum? get source_;
  // enum source_Enum {  manual,  ai,  };

  AnnotationResponse._();

  factory AnnotationResponse([void updates(AnnotationResponseBuilder b)]) =
      _$AnnotationResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnnotationResponseBuilder b) =>
      b..source_ = const AnnotationResponseSource_Enum._('manual');

  @BuiltValueSerializer(custom: true)
  static Serializer<AnnotationResponse> get serializer =>
      _$AnnotationResponseSerializer();
}

class _$AnnotationResponseSerializer
    implements PrimitiveSerializer<AnnotationResponse> {
  @override
  final Iterable<Type> types = const [AnnotationResponse, _$AnnotationResponse];

  @override
  final String wireName = r'AnnotationResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnnotationResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'color';
    yield serializers.serialize(
      object.color,
      specifiedType: const FullType(String),
    );
    if (object.confidence != null) {
      yield r'confidence';
      yield serializers.serialize(
        object.confidence,
        specifiedType: const FullType.nullable(num),
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
    if (object.damageType != null) {
      yield r'damage_type';
      yield serializers.serialize(
        object.damageType,
        specifiedType:
            const FullType.nullable(AnnotationResponseDamageTypeEnum),
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
          const FullType(BuiltList, [FullType(AnnotationPointResponse)]),
    );
    yield r'shape';
    yield serializers.serialize(
      object.shape,
      specifiedType: const FullType(AnnotationResponseShapeEnum),
    );
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType(AnnotationResponseSource_Enum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AnnotationResponse object, {
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
    required AnnotationResponseBuilder result,
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
        case r'confidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.confidence = valueDes;
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
        case r'damage_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(AnnotationResponseDamageTypeEnum),
          ) as AnnotationResponseDamageTypeEnum?;
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
                const FullType(BuiltList, [FullType(AnnotationPointResponse)]),
          ) as BuiltList<AnnotationPointResponse>;
          result.points.replace(valueDes);
          break;
        case r'shape':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnnotationResponseShapeEnum),
          ) as AnnotationResponseShapeEnum;
          result.shape = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnnotationResponseSource_Enum),
          ) as AnnotationResponseSource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnnotationResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnnotationResponseBuilder();
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

class AnnotationResponseDamageTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'corrosion')
  static const AnnotationResponseDamageTypeEnum corrosion =
      _$annotationResponseDamageTypeEnum_corrosion;
  @BuiltValueEnumConst(wireName: r'rust')
  static const AnnotationResponseDamageTypeEnum rust =
      _$annotationResponseDamageTypeEnum_rust;
  @BuiltValueEnumConst(wireName: r'crack')
  static const AnnotationResponseDamageTypeEnum crack =
      _$annotationResponseDamageTypeEnum_crack;
  @BuiltValueEnumConst(wireName: r'surface_damage')
  static const AnnotationResponseDamageTypeEnum surfaceDamage =
      _$annotationResponseDamageTypeEnum_surfaceDamage;
  @BuiltValueEnumConst(wireName: r'paint_deterioration')
  static const AnnotationResponseDamageTypeEnum paintDeterioration =
      _$annotationResponseDamageTypeEnum_paintDeterioration;
  @BuiltValueEnumConst(wireName: r'missing_bolt')
  static const AnnotationResponseDamageTypeEnum missingBolt =
      _$annotationResponseDamageTypeEnum_missingBolt;
  @BuiltValueEnumConst(wireName: r'broken_component')
  static const AnnotationResponseDamageTypeEnum brokenComponent =
      _$annotationResponseDamageTypeEnum_brokenComponent;
  @BuiltValueEnumConst(wireName: r'leak')
  static const AnnotationResponseDamageTypeEnum leak =
      _$annotationResponseDamageTypeEnum_leak;
  @BuiltValueEnumConst(wireName: r'wear')
  static const AnnotationResponseDamageTypeEnum wear =
      _$annotationResponseDamageTypeEnum_wear;
  @BuiltValueEnumConst(wireName: r'other')
  static const AnnotationResponseDamageTypeEnum other =
      _$annotationResponseDamageTypeEnum_other;

  static Serializer<AnnotationResponseDamageTypeEnum> get serializer =>
      _$annotationResponseDamageTypeEnumSerializer;

  const AnnotationResponseDamageTypeEnum._(String name) : super(name);

  static BuiltSet<AnnotationResponseDamageTypeEnum> get values =>
      _$annotationResponseDamageTypeEnumValues;
  static AnnotationResponseDamageTypeEnum valueOf(String name) =>
      _$annotationResponseDamageTypeEnumValueOf(name);
}

class AnnotationResponseShapeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'freehand')
  static const AnnotationResponseShapeEnum freehand =
      _$annotationResponseShapeEnum_freehand;
  @BuiltValueEnumConst(wireName: r'rectangle')
  static const AnnotationResponseShapeEnum rectangle =
      _$annotationResponseShapeEnum_rectangle;
  @BuiltValueEnumConst(wireName: r'circle')
  static const AnnotationResponseShapeEnum circle =
      _$annotationResponseShapeEnum_circle;
  @BuiltValueEnumConst(wireName: r'arrow')
  static const AnnotationResponseShapeEnum arrow =
      _$annotationResponseShapeEnum_arrow;
  @BuiltValueEnumConst(wireName: r'point')
  static const AnnotationResponseShapeEnum point =
      _$annotationResponseShapeEnum_point;

  static Serializer<AnnotationResponseShapeEnum> get serializer =>
      _$annotationResponseShapeEnumSerializer;

  const AnnotationResponseShapeEnum._(String name) : super(name);

  static BuiltSet<AnnotationResponseShapeEnum> get values =>
      _$annotationResponseShapeEnumValues;
  static AnnotationResponseShapeEnum valueOf(String name) =>
      _$annotationResponseShapeEnumValueOf(name);
}

class AnnotationResponseSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const AnnotationResponseSource_Enum manual =
      _$annotationResponseSourceEnum_manual;
  @BuiltValueEnumConst(wireName: r'ai')
  static const AnnotationResponseSource_Enum ai =
      _$annotationResponseSourceEnum_ai;

  static Serializer<AnnotationResponseSource_Enum> get serializer =>
      _$annotationResponseSourceEnumSerializer;

  const AnnotationResponseSource_Enum._(String name) : super(name);

  static BuiltSet<AnnotationResponseSource_Enum> get values =>
      _$annotationResponseSourceEnumValues;
  static AnnotationResponseSource_Enum valueOf(String name) =>
      _$annotationResponseSourceEnumValueOf(name);
}
