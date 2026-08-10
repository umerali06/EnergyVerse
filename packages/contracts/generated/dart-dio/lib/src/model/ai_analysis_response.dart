//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_analysis_response.g.dart';

/// AiAnalysisResponse
///
/// Properties:
/// * [annotationIds]
/// * [createdAt]
/// * [createdBy]
/// * [id]
/// * [mediaLocalId]
/// * [model]
/// * [recommendations]
/// * [reviewed]
/// * [reviewedAt]
/// * [reviewedBy]
/// * [riskLevel]
/// * [summary]
@BuiltValue()
abstract class AiAnalysisResponse
    implements Built<AiAnalysisResponse, AiAnalysisResponseBuilder> {
  @BuiltValueField(wireName: r'annotation_ids')
  BuiltList<String>? get annotationIds;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'media_local_id')
  String get mediaLocalId;

  @BuiltValueField(wireName: r'model')
  String get model;

  @BuiltValueField(wireName: r'recommendations')
  String? get recommendations;

  @BuiltValueField(wireName: r'reviewed')
  bool? get reviewed;

  @BuiltValueField(wireName: r'reviewed_at')
  DateTime? get reviewedAt;

  @BuiltValueField(wireName: r'reviewed_by')
  String? get reviewedBy;

  @BuiltValueField(wireName: r'risk_level')
  AiAnalysisResponseRiskLevelEnum? get riskLevel;
  // enum riskLevelEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'summary')
  String get summary;

  AiAnalysisResponse._();

  factory AiAnalysisResponse([void updates(AiAnalysisResponseBuilder b)]) =
      _$AiAnalysisResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiAnalysisResponseBuilder b) => b..reviewed = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiAnalysisResponse> get serializer =>
      _$AiAnalysisResponseSerializer();
}

class _$AiAnalysisResponseSerializer
    implements PrimitiveSerializer<AiAnalysisResponse> {
  @override
  final Iterable<Type> types = const [AiAnalysisResponse, _$AiAnalysisResponse];

  @override
  final String wireName = r'AiAnalysisResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiAnalysisResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.annotationIds != null) {
      yield r'annotation_ids';
      yield serializers.serialize(
        object.annotationIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    yield r'model';
    yield serializers.serialize(
      object.model,
      specifiedType: const FullType(String),
    );
    if (object.recommendations != null) {
      yield r'recommendations';
      yield serializers.serialize(
        object.recommendations,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reviewed != null) {
      yield r'reviewed';
      yield serializers.serialize(
        object.reviewed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.reviewedBy != null) {
      yield r'reviewed_by';
      yield serializers.serialize(
        object.reviewedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.riskLevel != null) {
      yield r'risk_level';
      yield serializers.serialize(
        object.riskLevel,
        specifiedType: const FullType.nullable(AiAnalysisResponseRiskLevelEnum),
      );
    }
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiAnalysisResponse object, {
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
    required AiAnalysisResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'annotation_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.annotationIds.replace(valueDes);
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
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.model = valueDes;
          break;
        case r'recommendations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recommendations = valueDes;
          break;
        case r'reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reviewed = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'reviewed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewedBy = valueDes;
          break;
        case r'risk_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(AiAnalysisResponseRiskLevelEnum),
          ) as AiAnalysisResponseRiskLevelEnum?;
          if (valueDes == null) continue;
          result.riskLevel = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiAnalysisResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiAnalysisResponseBuilder();
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

class AiAnalysisResponseRiskLevelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const AiAnalysisResponseRiskLevelEnum low =
      _$aiAnalysisResponseRiskLevelEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const AiAnalysisResponseRiskLevelEnum medium =
      _$aiAnalysisResponseRiskLevelEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const AiAnalysisResponseRiskLevelEnum high =
      _$aiAnalysisResponseRiskLevelEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const AiAnalysisResponseRiskLevelEnum critical =
      _$aiAnalysisResponseRiskLevelEnum_critical;

  static Serializer<AiAnalysisResponseRiskLevelEnum> get serializer =>
      _$aiAnalysisResponseRiskLevelEnumSerializer;

  const AiAnalysisResponseRiskLevelEnum._(String name) : super(name);

  static BuiltSet<AiAnalysisResponseRiskLevelEnum> get values =>
      _$aiAnalysisResponseRiskLevelEnumValues;
  static AiAnalysisResponseRiskLevelEnum valueOf(String name) =>
      _$aiAnalysisResponseRiskLevelEnumValueOf(name);
}
