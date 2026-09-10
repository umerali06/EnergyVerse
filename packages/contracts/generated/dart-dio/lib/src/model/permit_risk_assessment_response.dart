//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_risk_assessment_response.g.dart';

/// PermitRiskAssessmentResponse
///
/// Properties:
/// * [controls]
/// * [hazard]
/// * [id]
/// * [initialBand]
/// * [initialLikelihood]
/// * [initialScore]
/// * [initialSeverity]
/// * [personsAtRisk]
/// * [residualBand]
/// * [residualLikelihood]
/// * [residualScore]
/// * [residualSeverity]
@BuiltValue()
abstract class PermitRiskAssessmentResponse
    implements
        Built<PermitRiskAssessmentResponse,
            PermitRiskAssessmentResponseBuilder> {
  @BuiltValueField(wireName: r'controls')
  String get controls;

  @BuiltValueField(wireName: r'hazard')
  String get hazard;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'initial_band')
  PermitRiskAssessmentResponseInitialBandEnum get initialBand;
  // enum initialBandEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'initial_likelihood')
  int get initialLikelihood;

  @BuiltValueField(wireName: r'initial_score')
  int get initialScore;

  @BuiltValueField(wireName: r'initial_severity')
  int get initialSeverity;

  @BuiltValueField(wireName: r'persons_at_risk')
  String get personsAtRisk;

  @BuiltValueField(wireName: r'residual_band')
  PermitRiskAssessmentResponseResidualBandEnum get residualBand;
  // enum residualBandEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'residual_likelihood')
  int get residualLikelihood;

  @BuiltValueField(wireName: r'residual_score')
  int get residualScore;

  @BuiltValueField(wireName: r'residual_severity')
  int get residualSeverity;

  PermitRiskAssessmentResponse._();

  factory PermitRiskAssessmentResponse(
          [void updates(PermitRiskAssessmentResponseBuilder b)]) =
      _$PermitRiskAssessmentResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitRiskAssessmentResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitRiskAssessmentResponse> get serializer =>
      _$PermitRiskAssessmentResponseSerializer();
}

class _$PermitRiskAssessmentResponseSerializer
    implements PrimitiveSerializer<PermitRiskAssessmentResponse> {
  @override
  final Iterable<Type> types = const [
    PermitRiskAssessmentResponse,
    _$PermitRiskAssessmentResponse
  ];

  @override
  final String wireName = r'PermitRiskAssessmentResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitRiskAssessmentResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'controls';
    yield serializers.serialize(
      object.controls,
      specifiedType: const FullType(String),
    );
    yield r'hazard';
    yield serializers.serialize(
      object.hazard,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'initial_band';
    yield serializers.serialize(
      object.initialBand,
      specifiedType:
          const FullType(PermitRiskAssessmentResponseInitialBandEnum),
    );
    yield r'initial_likelihood';
    yield serializers.serialize(
      object.initialLikelihood,
      specifiedType: const FullType(int),
    );
    yield r'initial_score';
    yield serializers.serialize(
      object.initialScore,
      specifiedType: const FullType(int),
    );
    yield r'initial_severity';
    yield serializers.serialize(
      object.initialSeverity,
      specifiedType: const FullType(int),
    );
    yield r'persons_at_risk';
    yield serializers.serialize(
      object.personsAtRisk,
      specifiedType: const FullType(String),
    );
    yield r'residual_band';
    yield serializers.serialize(
      object.residualBand,
      specifiedType:
          const FullType(PermitRiskAssessmentResponseResidualBandEnum),
    );
    yield r'residual_likelihood';
    yield serializers.serialize(
      object.residualLikelihood,
      specifiedType: const FullType(int),
    );
    yield r'residual_score';
    yield serializers.serialize(
      object.residualScore,
      specifiedType: const FullType(int),
    );
    yield r'residual_severity';
    yield serializers.serialize(
      object.residualSeverity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitRiskAssessmentResponse object, {
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
    required PermitRiskAssessmentResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'controls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.controls = valueDes;
          break;
        case r'hazard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hazard = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'initial_band':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(PermitRiskAssessmentResponseInitialBandEnum),
          ) as PermitRiskAssessmentResponseInitialBandEnum;
          result.initialBand = valueDes;
          break;
        case r'initial_likelihood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.initialLikelihood = valueDes;
          break;
        case r'initial_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.initialScore = valueDes;
          break;
        case r'initial_severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.initialSeverity = valueDes;
          break;
        case r'persons_at_risk':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personsAtRisk = valueDes;
          break;
        case r'residual_band':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(PermitRiskAssessmentResponseResidualBandEnum),
          ) as PermitRiskAssessmentResponseResidualBandEnum;
          result.residualBand = valueDes;
          break;
        case r'residual_likelihood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.residualLikelihood = valueDes;
          break;
        case r'residual_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.residualScore = valueDes;
          break;
        case r'residual_severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.residualSeverity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitRiskAssessmentResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitRiskAssessmentResponseBuilder();
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

class PermitRiskAssessmentResponseInitialBandEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const PermitRiskAssessmentResponseInitialBandEnum low =
      _$permitRiskAssessmentResponseInitialBandEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const PermitRiskAssessmentResponseInitialBandEnum medium =
      _$permitRiskAssessmentResponseInitialBandEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const PermitRiskAssessmentResponseInitialBandEnum high =
      _$permitRiskAssessmentResponseInitialBandEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const PermitRiskAssessmentResponseInitialBandEnum critical =
      _$permitRiskAssessmentResponseInitialBandEnum_critical;

  static Serializer<PermitRiskAssessmentResponseInitialBandEnum>
      get serializer => _$permitRiskAssessmentResponseInitialBandEnumSerializer;

  const PermitRiskAssessmentResponseInitialBandEnum._(String name)
      : super(name);

  static BuiltSet<PermitRiskAssessmentResponseInitialBandEnum> get values =>
      _$permitRiskAssessmentResponseInitialBandEnumValues;
  static PermitRiskAssessmentResponseInitialBandEnum valueOf(String name) =>
      _$permitRiskAssessmentResponseInitialBandEnumValueOf(name);
}

class PermitRiskAssessmentResponseResidualBandEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const PermitRiskAssessmentResponseResidualBandEnum low =
      _$permitRiskAssessmentResponseResidualBandEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const PermitRiskAssessmentResponseResidualBandEnum medium =
      _$permitRiskAssessmentResponseResidualBandEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const PermitRiskAssessmentResponseResidualBandEnum high =
      _$permitRiskAssessmentResponseResidualBandEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const PermitRiskAssessmentResponseResidualBandEnum critical =
      _$permitRiskAssessmentResponseResidualBandEnum_critical;

  static Serializer<PermitRiskAssessmentResponseResidualBandEnum>
      get serializer =>
          _$permitRiskAssessmentResponseResidualBandEnumSerializer;

  const PermitRiskAssessmentResponseResidualBandEnum._(String name)
      : super(name);

  static BuiltSet<PermitRiskAssessmentResponseResidualBandEnum> get values =>
      _$permitRiskAssessmentResponseResidualBandEnumValues;
  static PermitRiskAssessmentResponseResidualBandEnum valueOf(String name) =>
      _$permitRiskAssessmentResponseResidualBandEnumValueOf(name);
}
