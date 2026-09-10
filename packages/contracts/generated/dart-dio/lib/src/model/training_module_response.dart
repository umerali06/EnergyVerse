//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/training_step_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'training_module_response.g.dart';

/// TrainingModuleResponse
///
/// Properties:
/// * [description]
/// * [estimatedMinutes]
/// * [facilityId]
/// * [id]
/// * [kind]
/// * [passThreshold]
/// * [steps]
/// * [title]
@BuiltValue()
abstract class TrainingModuleResponse
    implements Built<TrainingModuleResponse, TrainingModuleResponseBuilder> {
  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'estimated_minutes')
  int get estimatedMinutes;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'pass_threshold')
  int get passThreshold;

  @BuiltValueField(wireName: r'steps')
  BuiltList<TrainingStepResponse>? get steps;

  @BuiltValueField(wireName: r'title')
  String get title;

  TrainingModuleResponse._();

  factory TrainingModuleResponse(
          [void updates(TrainingModuleResponseBuilder b)]) =
      _$TrainingModuleResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainingModuleResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainingModuleResponse> get serializer =>
      _$TrainingModuleResponseSerializer();
}

class _$TrainingModuleResponseSerializer
    implements PrimitiveSerializer<TrainingModuleResponse> {
  @override
  final Iterable<Type> types = const [
    TrainingModuleResponse,
    _$TrainingModuleResponse
  ];

  @override
  final String wireName = r'TrainingModuleResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainingModuleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'estimated_minutes';
    yield serializers.serialize(
      object.estimatedMinutes,
      specifiedType: const FullType(int),
    );
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'pass_threshold';
    yield serializers.serialize(
      object.passThreshold,
      specifiedType: const FullType(int),
    );
    if (object.steps != null) {
      yield r'steps';
      yield serializers.serialize(
        object.steps,
        specifiedType:
            const FullType(BuiltList, [FullType(TrainingStepResponse)]),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainingModuleResponse object, {
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
    required TrainingModuleResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'estimated_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedMinutes = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'pass_threshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.passThreshold = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(TrainingStepResponse)]),
          ) as BuiltList<TrainingStepResponse>;
          result.steps.replace(valueDes);
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  TrainingModuleResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainingModuleResponseBuilder();
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
