//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_generated_report_request.g.dart';

/// UpdateGeneratedReportRequest
///
/// Properties:
/// * [expectedRevision]
/// * [findings]
/// * [recommendations]
/// * [riskScore]
/// * [summary]
/// * [title]
@BuiltValue()
abstract class UpdateGeneratedReportRequest
    implements
        Built<UpdateGeneratedReportRequest,
            UpdateGeneratedReportRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'findings')
  BuiltList<String>? get findings;

  @BuiltValueField(wireName: r'recommendations')
  BuiltList<String>? get recommendations;

  @BuiltValueField(wireName: r'risk_score')
  num? get riskScore;

  @BuiltValueField(wireName: r'summary')
  String? get summary;

  @BuiltValueField(wireName: r'title')
  String? get title;

  UpdateGeneratedReportRequest._();

  factory UpdateGeneratedReportRequest(
          [void updates(UpdateGeneratedReportRequestBuilder b)]) =
      _$UpdateGeneratedReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateGeneratedReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateGeneratedReportRequest> get serializer =>
      _$UpdateGeneratedReportRequestSerializer();
}

class _$UpdateGeneratedReportRequestSerializer
    implements PrimitiveSerializer<UpdateGeneratedReportRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateGeneratedReportRequest,
    _$UpdateGeneratedReportRequest
  ];

  @override
  final String wireName = r'UpdateGeneratedReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateGeneratedReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    if (object.findings != null) {
      yield r'findings';
      yield serializers.serialize(
        object.findings,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.recommendations != null) {
      yield r'recommendations';
      yield serializers.serialize(
        object.recommendations,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.riskScore != null) {
      yield r'risk_score';
      yield serializers.serialize(
        object.riskScore,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.summary != null) {
      yield r'summary';
      yield serializers.serialize(
        object.summary,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateGeneratedReportRequest object, {
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
    required UpdateGeneratedReportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'findings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.findings.replace(valueDes);
          break;
        case r'recommendations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.summary = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateGeneratedReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateGeneratedReportRequestBuilder();
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
