//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/annotation_point_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_annotation_request.g.dart';

/// UpdateAnnotationRequest
///
/// Properties:
/// * [color]
/// * [damageType]
/// * [note]
/// * [points]
@BuiltValue()
abstract class UpdateAnnotationRequest
    implements Built<UpdateAnnotationRequest, UpdateAnnotationRequestBuilder> {
  @BuiltValueField(wireName: r'color')
  String? get color;

  @BuiltValueField(wireName: r'damage_type')
  UpdateAnnotationRequestDamageTypeEnum? get damageType;
  // enum damageTypeEnum {  corrosion,  rust,  crack,  surface_damage,  paint_deterioration,  missing_bolt,  broken_component,  leak,  wear,  other,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'points')
  BuiltList<AnnotationPointInput>? get points;

  UpdateAnnotationRequest._();

  factory UpdateAnnotationRequest(
          [void updates(UpdateAnnotationRequestBuilder b)]) =
      _$UpdateAnnotationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAnnotationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAnnotationRequest> get serializer =>
      _$UpdateAnnotationRequestSerializer();
}

class _$UpdateAnnotationRequestSerializer
    implements PrimitiveSerializer<UpdateAnnotationRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateAnnotationRequest,
    _$UpdateAnnotationRequest
  ];

  @override
  final String wireName = r'UpdateAnnotationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAnnotationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.damageType != null) {
      yield r'damage_type';
      yield serializers.serialize(
        object.damageType,
        specifiedType:
            const FullType.nullable(UpdateAnnotationRequestDamageTypeEnum),
      );
    }
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
        specifiedType: const FullType.nullable(
            BuiltList, [FullType(AnnotationPointInput)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateAnnotationRequest object, {
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
    required UpdateAnnotationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.color = valueDes;
          break;
        case r'damage_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(UpdateAnnotationRequestDamageTypeEnum),
          ) as UpdateAnnotationRequestDamageTypeEnum?;
          if (valueDes == null) continue;
          result.damageType = valueDes;
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
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(AnnotationPointInput)]),
          ) as BuiltList<AnnotationPointInput>?;
          if (valueDes == null) continue;
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
  UpdateAnnotationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAnnotationRequestBuilder();
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

class UpdateAnnotationRequestDamageTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'corrosion')
  static const UpdateAnnotationRequestDamageTypeEnum corrosion =
      _$updateAnnotationRequestDamageTypeEnum_corrosion;
  @BuiltValueEnumConst(wireName: r'rust')
  static const UpdateAnnotationRequestDamageTypeEnum rust =
      _$updateAnnotationRequestDamageTypeEnum_rust;
  @BuiltValueEnumConst(wireName: r'crack')
  static const UpdateAnnotationRequestDamageTypeEnum crack =
      _$updateAnnotationRequestDamageTypeEnum_crack;
  @BuiltValueEnumConst(wireName: r'surface_damage')
  static const UpdateAnnotationRequestDamageTypeEnum surfaceDamage =
      _$updateAnnotationRequestDamageTypeEnum_surfaceDamage;
  @BuiltValueEnumConst(wireName: r'paint_deterioration')
  static const UpdateAnnotationRequestDamageTypeEnum paintDeterioration =
      _$updateAnnotationRequestDamageTypeEnum_paintDeterioration;
  @BuiltValueEnumConst(wireName: r'missing_bolt')
  static const UpdateAnnotationRequestDamageTypeEnum missingBolt =
      _$updateAnnotationRequestDamageTypeEnum_missingBolt;
  @BuiltValueEnumConst(wireName: r'broken_component')
  static const UpdateAnnotationRequestDamageTypeEnum brokenComponent =
      _$updateAnnotationRequestDamageTypeEnum_brokenComponent;
  @BuiltValueEnumConst(wireName: r'leak')
  static const UpdateAnnotationRequestDamageTypeEnum leak =
      _$updateAnnotationRequestDamageTypeEnum_leak;
  @BuiltValueEnumConst(wireName: r'wear')
  static const UpdateAnnotationRequestDamageTypeEnum wear =
      _$updateAnnotationRequestDamageTypeEnum_wear;
  @BuiltValueEnumConst(wireName: r'other')
  static const UpdateAnnotationRequestDamageTypeEnum other =
      _$updateAnnotationRequestDamageTypeEnum_other;

  static Serializer<UpdateAnnotationRequestDamageTypeEnum> get serializer =>
      _$updateAnnotationRequestDamageTypeEnumSerializer;

  const UpdateAnnotationRequestDamageTypeEnum._(String name) : super(name);

  static BuiltSet<UpdateAnnotationRequestDamageTypeEnum> get values =>
      _$updateAnnotationRequestDamageTypeEnumValues;
  static UpdateAnnotationRequestDamageTypeEnum valueOf(String name) =>
      _$updateAnnotationRequestDamageTypeEnumValueOf(name);
}
