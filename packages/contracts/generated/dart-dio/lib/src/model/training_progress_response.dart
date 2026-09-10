//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'training_progress_response.g.dart';

/// TrainingProgressResponse
///
/// Properties:
/// * [attempts]
/// * [completedAt]
/// * [completedStepIds]
/// * [correctCount]
/// * [id]
/// * [moduleId]
/// * [score]
/// * [scoredCount]
/// * [startedAt]
/// * [status]
@BuiltValue()
abstract class TrainingProgressResponse
    implements
        Built<TrainingProgressResponse, TrainingProgressResponseBuilder> {
  @BuiltValueField(wireName: r'attempts')
  int? get attempts;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'completed_step_ids')
  BuiltList<String>? get completedStepIds;

  @BuiltValueField(wireName: r'correct_count')
  int? get correctCount;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'module_id')
  String get moduleId;

  @BuiltValueField(wireName: r'score')
  int? get score;

  @BuiltValueField(wireName: r'scored_count')
  int? get scoredCount;

  @BuiltValueField(wireName: r'started_at')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'status')
  String get status;

  TrainingProgressResponse._();

  factory TrainingProgressResponse(
          [void updates(TrainingProgressResponseBuilder b)]) =
      _$TrainingProgressResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainingProgressResponseBuilder b) => b
    ..attempts = 1
    ..correctCount = 0
    ..scoredCount = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainingProgressResponse> get serializer =>
      _$TrainingProgressResponseSerializer();
}

class _$TrainingProgressResponseSerializer
    implements PrimitiveSerializer<TrainingProgressResponse> {
  @override
  final Iterable<Type> types = const [
    TrainingProgressResponse,
    _$TrainingProgressResponse
  ];

  @override
  final String wireName = r'TrainingProgressResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainingProgressResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.attempts != null) {
      yield r'attempts';
      yield serializers.serialize(
        object.attempts,
        specifiedType: const FullType(int),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.completedStepIds != null) {
      yield r'completed_step_ids';
      yield serializers.serialize(
        object.completedStepIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.correctCount != null) {
      yield r'correct_count';
      yield serializers.serialize(
        object.correctCount,
        specifiedType: const FullType(int),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'module_id';
    yield serializers.serialize(
      object.moduleId,
      specifiedType: const FullType(String),
    );
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.scoredCount != null) {
      yield r'scored_count';
      yield serializers.serialize(
        object.scoredCount,
        specifiedType: const FullType(int),
      );
    }
    yield r'started_at';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainingProgressResponse object, {
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
    required TrainingProgressResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attempts = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'completed_step_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.completedStepIds.replace(valueDes);
          break;
        case r'correct_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.correctCount = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'module_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.moduleId = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.score = valueDes;
          break;
        case r'scored_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.scoredCount = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainingProgressResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainingProgressResponseBuilder();
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
