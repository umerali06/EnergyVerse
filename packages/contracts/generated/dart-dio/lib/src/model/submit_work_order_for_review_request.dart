//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'submit_work_order_for_review_request.g.dart';

/// SubmitWorkOrderForReviewRequest
///
/// Properties:
/// * [completionNotes]
/// * [expectedRevision]
/// * [laborHours]
/// * [materialsUsed]
@BuiltValue()
abstract class SubmitWorkOrderForReviewRequest
    implements
        Built<SubmitWorkOrderForReviewRequest,
            SubmitWorkOrderForReviewRequestBuilder> {
  @BuiltValueField(wireName: r'completion_notes')
  String get completionNotes;

  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  @BuiltValueField(wireName: r'labor_hours')
  num? get laborHours;

  @BuiltValueField(wireName: r'materials_used')
  BuiltList<String>? get materialsUsed;

  SubmitWorkOrderForReviewRequest._();

  factory SubmitWorkOrderForReviewRequest(
          [void updates(SubmitWorkOrderForReviewRequestBuilder b)]) =
      _$SubmitWorkOrderForReviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubmitWorkOrderForReviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubmitWorkOrderForReviewRequest> get serializer =>
      _$SubmitWorkOrderForReviewRequestSerializer();
}

class _$SubmitWorkOrderForReviewRequestSerializer
    implements PrimitiveSerializer<SubmitWorkOrderForReviewRequest> {
  @override
  final Iterable<Type> types = const [
    SubmitWorkOrderForReviewRequest,
    _$SubmitWorkOrderForReviewRequest
  ];

  @override
  final String wireName = r'SubmitWorkOrderForReviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubmitWorkOrderForReviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'completion_notes';
    yield serializers.serialize(
      object.completionNotes,
      specifiedType: const FullType(String),
    );
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.laborHours != null) {
      yield r'labor_hours';
      yield serializers.serialize(
        object.laborHours,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.materialsUsed != null) {
      yield r'materials_used';
      yield serializers.serialize(
        object.materialsUsed,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubmitWorkOrderForReviewRequest object, {
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
    required SubmitWorkOrderForReviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'completion_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.completionNotes = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expectedRevision = valueDes;
          break;
        case r'labor_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.laborHours = valueDes;
          break;
        case r'materials_used':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.materialsUsed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubmitWorkOrderForReviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitWorkOrderForReviewRequestBuilder();
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
