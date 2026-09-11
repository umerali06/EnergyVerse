//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_narrative_response.g.dart';

/// ReportNarrativeResponse
///
/// Properties:
/// * [findings]
/// * [recommendations]
/// * [riskScore]
/// * [summary]
@BuiltValue()
abstract class ReportNarrativeResponse
    implements Built<ReportNarrativeResponse, ReportNarrativeResponseBuilder> {
  @BuiltValueField(wireName: r'findings')
  BuiltList<String>? get findings;

  @BuiltValueField(wireName: r'recommendations')
  BuiltList<String>? get recommendations;

  @BuiltValueField(wireName: r'risk_score')
  num? get riskScore;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  ReportNarrativeResponse._();

  factory ReportNarrativeResponse(
          [void updates(ReportNarrativeResponseBuilder b)]) =
      _$ReportNarrativeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportNarrativeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportNarrativeResponse> get serializer =>
      _$ReportNarrativeResponseSerializer();
}

class _$ReportNarrativeResponseSerializer
    implements PrimitiveSerializer<ReportNarrativeResponse> {
  @override
  final Iterable<Type> types = const [
    ReportNarrativeResponse,
    _$ReportNarrativeResponse
  ];

  @override
  final String wireName = r'ReportNarrativeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportNarrativeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.findings != null) {
      yield r'findings';
      yield serializers.serialize(
        object.findings,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.recommendations != null) {
      yield r'recommendations';
      yield serializers.serialize(
        object.recommendations,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.riskScore != null) {
      yield r'risk_score';
      yield serializers.serialize(
        object.riskScore,
        specifiedType: const FullType.nullable(num),
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
    ReportNarrativeResponse object, {
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
    required ReportNarrativeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'findings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.findings.replace(valueDes);
          break;
        case r'recommendations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.recommendations.replace(valueDes);
          break;
        case r'risk_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.riskScore = valueDes;
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
  ReportNarrativeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportNarrativeResponseBuilder();
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
