//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'readings_input.g.dart';

/// Client-submitted readings (spec section 9, Phase 7.7). `recorded_at`/ `recorded_by` are never accepted from the client -- the server always stamps them, mirroring how `answered_at`/`answered_by` are handled on `ChecklistResponse`.
///
/// Properties:
/// * [comments]
/// * [condition]
/// * [leakObserved]
/// * [noiseLevelDb]
/// * [operationalStatus]
/// * [pressureBar]
/// * [priorityLevel]
/// * [recommendations]
/// * [temperatureC]
/// * [vibrationObservation]
@BuiltValue()
abstract class ReadingsInput
    implements Built<ReadingsInput, ReadingsInputBuilder> {
  @BuiltValueField(wireName: r'comments')
  String? get comments;

  @BuiltValueField(wireName: r'condition')
  ReadingsInputConditionEnum get condition;
  // enum conditionEnum {  Excellent,  Good,  Fair,  Poor,  Critical,  };

  @BuiltValueField(wireName: r'leak_observed')
  bool? get leakObserved;

  @BuiltValueField(wireName: r'noise_level_db')
  num? get noiseLevelDb;

  @BuiltValueField(wireName: r'operational_status')
  ReadingsInputOperationalStatusEnum? get operationalStatus;
  // enum operationalStatusEnum {  running,  stopped,  degraded,  };

  @BuiltValueField(wireName: r'pressure_bar')
  num? get pressureBar;

  @BuiltValueField(wireName: r'priority_level')
  ReadingsInputPriorityLevelEnum? get priorityLevel;
  // enum priorityLevelEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'recommendations')
  String? get recommendations;

  @BuiltValueField(wireName: r'temperature_c')
  num? get temperatureC;

  @BuiltValueField(wireName: r'vibration_observation')
  String? get vibrationObservation;

  ReadingsInput._();

  factory ReadingsInput([void updates(ReadingsInputBuilder b)]) =
      _$ReadingsInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadingsInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadingsInput> get serializer =>
      _$ReadingsInputSerializer();
}

class _$ReadingsInputSerializer implements PrimitiveSerializer<ReadingsInput> {
  @override
  final Iterable<Type> types = const [ReadingsInput, _$ReadingsInput];

  @override
  final String wireName = r'ReadingsInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadingsInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.comments != null) {
      yield r'comments';
      yield serializers.serialize(
        object.comments,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'condition';
    yield serializers.serialize(
      object.condition,
      specifiedType: const FullType(ReadingsInputConditionEnum),
    );
    if (object.leakObserved != null) {
      yield r'leak_observed';
      yield serializers.serialize(
        object.leakObserved,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.noiseLevelDb != null) {
      yield r'noise_level_db';
      yield serializers.serialize(
        object.noiseLevelDb,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.operationalStatus != null) {
      yield r'operational_status';
      yield serializers.serialize(
        object.operationalStatus,
        specifiedType:
            const FullType.nullable(ReadingsInputOperationalStatusEnum),
      );
    }
    if (object.pressureBar != null) {
      yield r'pressure_bar';
      yield serializers.serialize(
        object.pressureBar,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.priorityLevel != null) {
      yield r'priority_level';
      yield serializers.serialize(
        object.priorityLevel,
        specifiedType: const FullType.nullable(ReadingsInputPriorityLevelEnum),
      );
    }
    if (object.recommendations != null) {
      yield r'recommendations';
      yield serializers.serialize(
        object.recommendations,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.temperatureC != null) {
      yield r'temperature_c';
      yield serializers.serialize(
        object.temperatureC,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.vibrationObservation != null) {
      yield r'vibration_observation';
      yield serializers.serialize(
        object.vibrationObservation,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadingsInput object, {
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
    required ReadingsInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'comments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comments = valueDes;
          break;
        case r'condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadingsInputConditionEnum),
          ) as ReadingsInputConditionEnum;
          result.condition = valueDes;
          break;
        case r'leak_observed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.leakObserved = valueDes;
          break;
        case r'noise_level_db':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.noiseLevelDb = valueDes;
          break;
        case r'operational_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(ReadingsInputOperationalStatusEnum),
          ) as ReadingsInputOperationalStatusEnum?;
          if (valueDes == null) continue;
          result.operationalStatus = valueDes;
          break;
        case r'pressure_bar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.pressureBar = valueDes;
          break;
        case r'priority_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(ReadingsInputPriorityLevelEnum),
          ) as ReadingsInputPriorityLevelEnum?;
          if (valueDes == null) continue;
          result.priorityLevel = valueDes;
          break;
        case r'recommendations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recommendations = valueDes;
          break;
        case r'temperature_c':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.temperatureC = valueDes;
          break;
        case r'vibration_observation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vibrationObservation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadingsInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadingsInputBuilder();
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

class ReadingsInputConditionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Excellent')
  static const ReadingsInputConditionEnum excellent =
      _$readingsInputConditionEnum_excellent;
  @BuiltValueEnumConst(wireName: r'Good')
  static const ReadingsInputConditionEnum good =
      _$readingsInputConditionEnum_good;
  @BuiltValueEnumConst(wireName: r'Fair')
  static const ReadingsInputConditionEnum fair =
      _$readingsInputConditionEnum_fair;
  @BuiltValueEnumConst(wireName: r'Poor')
  static const ReadingsInputConditionEnum poor =
      _$readingsInputConditionEnum_poor;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const ReadingsInputConditionEnum critical =
      _$readingsInputConditionEnum_critical;

  static Serializer<ReadingsInputConditionEnum> get serializer =>
      _$readingsInputConditionEnumSerializer;

  const ReadingsInputConditionEnum._(String name) : super(name);

  static BuiltSet<ReadingsInputConditionEnum> get values =>
      _$readingsInputConditionEnumValues;
  static ReadingsInputConditionEnum valueOf(String name) =>
      _$readingsInputConditionEnumValueOf(name);
}

class ReadingsInputOperationalStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'running')
  static const ReadingsInputOperationalStatusEnum running =
      _$readingsInputOperationalStatusEnum_running;
  @BuiltValueEnumConst(wireName: r'stopped')
  static const ReadingsInputOperationalStatusEnum stopped =
      _$readingsInputOperationalStatusEnum_stopped;
  @BuiltValueEnumConst(wireName: r'degraded')
  static const ReadingsInputOperationalStatusEnum degraded =
      _$readingsInputOperationalStatusEnum_degraded;

  static Serializer<ReadingsInputOperationalStatusEnum> get serializer =>
      _$readingsInputOperationalStatusEnumSerializer;

  const ReadingsInputOperationalStatusEnum._(String name) : super(name);

  static BuiltSet<ReadingsInputOperationalStatusEnum> get values =>
      _$readingsInputOperationalStatusEnumValues;
  static ReadingsInputOperationalStatusEnum valueOf(String name) =>
      _$readingsInputOperationalStatusEnumValueOf(name);
}

class ReadingsInputPriorityLevelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const ReadingsInputPriorityLevelEnum low =
      _$readingsInputPriorityLevelEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const ReadingsInputPriorityLevelEnum medium =
      _$readingsInputPriorityLevelEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const ReadingsInputPriorityLevelEnum high =
      _$readingsInputPriorityLevelEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const ReadingsInputPriorityLevelEnum critical =
      _$readingsInputPriorityLevelEnum_critical;

  static Serializer<ReadingsInputPriorityLevelEnum> get serializer =>
      _$readingsInputPriorityLevelEnumSerializer;

  const ReadingsInputPriorityLevelEnum._(String name) : super(name);

  static BuiltSet<ReadingsInputPriorityLevelEnum> get values =>
      _$readingsInputPriorityLevelEnumValues;
  static ReadingsInputPriorityLevelEnum valueOf(String name) =>
      _$readingsInputPriorityLevelEnumValueOf(name);
}
