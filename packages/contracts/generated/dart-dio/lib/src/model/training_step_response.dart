//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'training_step_response.g.dart';

/// TrainingStepResponse
///
/// Properties:
/// * [action]
/// * [id]
/// * [instruction]
/// * [options]
/// * [order]
/// * [targetAssetId]
/// * [targetPosition]
/// * [timeLimitSeconds]
/// * [title]
@BuiltValue()
abstract class TrainingStepResponse
    implements Built<TrainingStepResponse, TrainingStepResponseBuilder> {
  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'instruction')
  String get instruction;

  @BuiltValueField(wireName: r'options')
  BuiltList<String>? get options;

  @BuiltValueField(wireName: r'order')
  int get order;

  @BuiltValueField(wireName: r'target_asset_id')
  String? get targetAssetId;

  @BuiltValueField(wireName: r'target_position')
  BuiltList<num>? get targetPosition;

  @BuiltValueField(wireName: r'time_limit_seconds')
  int? get timeLimitSeconds;

  @BuiltValueField(wireName: r'title')
  String get title;

  TrainingStepResponse._();

  factory TrainingStepResponse([void updates(TrainingStepResponseBuilder b)]) =
      _$TrainingStepResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainingStepResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainingStepResponse> get serializer =>
      _$TrainingStepResponseSerializer();
}

class _$TrainingStepResponseSerializer
    implements PrimitiveSerializer<TrainingStepResponse> {
  @override
  final Iterable<Type> types = const [
    TrainingStepResponse,
    _$TrainingStepResponse
  ];

  @override
  final String wireName = r'TrainingStepResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainingStepResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'instruction';
    yield serializers.serialize(
      object.instruction,
      specifiedType: const FullType(String),
    );
    if (object.options != null) {
      yield r'options';
      yield serializers.serialize(
        object.options,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(int),
    );
    if (object.targetAssetId != null) {
      yield r'target_asset_id';
      yield serializers.serialize(
        object.targetAssetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.targetPosition != null) {
      yield r'target_position';
      yield serializers.serialize(
        object.targetPosition,
        specifiedType: const FullType.nullable(BuiltList, [FullType(num)]),
      );
    }
    if (object.timeLimitSeconds != null) {
      yield r'time_limit_seconds';
      yield serializers.serialize(
        object.timeLimitSeconds,
        specifiedType: const FullType.nullable(int),
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
    TrainingStepResponse object, {
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
    required TrainingStepResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'instruction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.instruction = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.options.replace(valueDes);
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.order = valueDes;
          break;
        case r'target_asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.targetAssetId = valueDes;
          break;
        case r'target_position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(num)]),
          ) as BuiltList<num>?;
          if (valueDes == null) continue;
          result.targetPosition.replace(valueDes);
          break;
        case r'time_limit_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.timeLimitSeconds = valueDes;
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
  TrainingStepResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainingStepResponseBuilder();
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
