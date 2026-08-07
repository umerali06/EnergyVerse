//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/signature_stroke_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complete_inspection_request.g.dart';

/// Signature capture is the final step of completion (spec 7.2 \"digital signature\", Phase 7.8) -- there is no separate sign-then-complete endpoint. `expected_revision` is required, unlike the optional field on `UpdateInspectionRequest`/`AssignChecklistTemplateRequest`: the whole point of binding a signature to a revision is to reject a stale view outright (409 `revision_conflict`) and force a refresh + re-sign, never silently complete against out-of-date checklist/readings data. `strokes` is a list of stroke objects (each with its own `points`), not a raw `list[list[...]]` -- see `Signature.strokes`'s docstring for why.
///
/// Properties:
/// * [expectedRevision]
/// * [strokes]
@BuiltValue()
abstract class CompleteInspectionRequest
    implements
        Built<CompleteInspectionRequest, CompleteInspectionRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'strokes')
  BuiltList<SignatureStrokeInput> get strokes;

  CompleteInspectionRequest._();

  factory CompleteInspectionRequest(
          [void updates(CompleteInspectionRequestBuilder b)]) =
      _$CompleteInspectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompleteInspectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompleteInspectionRequest> get serializer =>
      _$CompleteInspectionRequestSerializer();
}

class _$CompleteInspectionRequestSerializer
    implements PrimitiveSerializer<CompleteInspectionRequest> {
  @override
  final Iterable<Type> types = const [
    CompleteInspectionRequest,
    _$CompleteInspectionRequest
  ];

  @override
  final String wireName = r'CompleteInspectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompleteInspectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'strokes';
    yield serializers.serialize(
      object.strokes,
      specifiedType:
          const FullType(BuiltList, [FullType(SignatureStrokeInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompleteInspectionRequest object, {
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
    required CompleteInspectionRequestBuilder result,
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
        case r'strokes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SignatureStrokeInput)]),
          ) as BuiltList<SignatureStrokeInput>;
          result.strokes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompleteInspectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompleteInspectionRequestBuilder();
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
