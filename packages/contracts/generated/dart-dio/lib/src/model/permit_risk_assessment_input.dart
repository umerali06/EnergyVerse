//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_risk_assessment_input.g.dart';

/// PermitRiskAssessmentInput
///
/// Properties:
/// * [controls]
/// * [hazard]
/// * [id]
/// * [initialLikelihood]
/// * [initialSeverity]
/// * [personsAtRisk]
/// * [residualLikelihood]
/// * [residualSeverity]
@BuiltValue()
abstract class PermitRiskAssessmentInput
    implements
        Built<PermitRiskAssessmentInput, PermitRiskAssessmentInputBuilder> {
  @BuiltValueField(wireName: r'controls')
  String get controls;

  @BuiltValueField(wireName: r'hazard')
  String get hazard;

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'initial_likelihood')
  int get initialLikelihood;

  @BuiltValueField(wireName: r'initial_severity')
  int get initialSeverity;

  @BuiltValueField(wireName: r'persons_at_risk')
  String get personsAtRisk;

  @BuiltValueField(wireName: r'residual_likelihood')
  int get residualLikelihood;

  @BuiltValueField(wireName: r'residual_severity')
  int get residualSeverity;

  PermitRiskAssessmentInput._();

  factory PermitRiskAssessmentInput(
          [void updates(PermitRiskAssessmentInputBuilder b)]) =
      _$PermitRiskAssessmentInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitRiskAssessmentInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitRiskAssessmentInput> get serializer =>
      _$PermitRiskAssessmentInputSerializer();
}

class _$PermitRiskAssessmentInputSerializer
    implements PrimitiveSerializer<PermitRiskAssessmentInput> {
  @override
  final Iterable<Type> types = const [
    PermitRiskAssessmentInput,
    _$PermitRiskAssessmentInput
  ];

  @override
  final String wireName = r'PermitRiskAssessmentInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitRiskAssessmentInput object, {
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
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'initial_likelihood';
    yield serializers.serialize(
      object.initialLikelihood,
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
    yield r'residual_likelihood';
    yield serializers.serialize(
      object.residualLikelihood,
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
    PermitRiskAssessmentInput object, {
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
    required PermitRiskAssessmentInputBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'initial_likelihood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.initialLikelihood = valueDes;
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
        case r'residual_likelihood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.residualLikelihood = valueDes;
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
  PermitRiskAssessmentInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitRiskAssessmentInputBuilder();
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
