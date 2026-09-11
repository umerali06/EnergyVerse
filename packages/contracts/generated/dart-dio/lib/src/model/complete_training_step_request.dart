//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complete_training_step_request.g.dart';

/// CompleteTrainingStepRequest
///
/// Properties:
/// * [correct]
/// * [selectedOption]
@BuiltValue()
abstract class CompleteTrainingStepRequest
    implements
        Built<CompleteTrainingStepRequest, CompleteTrainingStepRequestBuilder> {
  @BuiltValueField(wireName: r'correct')
  bool? get correct;

  @BuiltValueField(wireName: r'selected_option')
  String? get selectedOption;

  CompleteTrainingStepRequest._();

  factory CompleteTrainingStepRequest(
          [void updates(CompleteTrainingStepRequestBuilder b)]) =
      _$CompleteTrainingStepRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompleteTrainingStepRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompleteTrainingStepRequest> get serializer =>
      _$CompleteTrainingStepRequestSerializer();
}

class _$CompleteTrainingStepRequestSerializer
    implements PrimitiveSerializer<CompleteTrainingStepRequest> {
  @override
  final Iterable<Type> types = const [
    CompleteTrainingStepRequest,
    _$CompleteTrainingStepRequest
  ];

  @override
  final String wireName = r'CompleteTrainingStepRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompleteTrainingStepRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.correct != null) {
      yield r'correct';
      yield serializers.serialize(
        object.correct,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.selectedOption != null) {
      yield r'selected_option';
      yield serializers.serialize(
        object.selectedOption,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CompleteTrainingStepRequest object, {
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
    required CompleteTrainingStepRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'correct':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.correct = valueDes;
          break;
        case r'selected_option':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.selectedOption = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompleteTrainingStepRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompleteTrainingStepRequestBuilder();
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
