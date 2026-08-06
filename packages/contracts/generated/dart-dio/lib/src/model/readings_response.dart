//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'readings_response.g.dart';

/// ReadingsResponse
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
/// * [recordedAt]
/// * [recordedBy]
/// * [temperatureC]
/// * [vibrationObservation]
@BuiltValue()
abstract class ReadingsResponse
    implements Built<ReadingsResponse, ReadingsResponseBuilder> {
  @BuiltValueField(wireName: r'comments')
  String? get comments;

  @BuiltValueField(wireName: r'condition')
  ReadingsResponseConditionEnum get condition;
  // enum conditionEnum {  Excellent,  Good,  Fair,  Poor,  Critical,  };

  @BuiltValueField(wireName: r'leak_observed')
  bool? get leakObserved;

  @BuiltValueField(wireName: r'noise_level_db')
  num? get noiseLevelDb;

  @BuiltValueField(wireName: r'operational_status')
  ReadingsResponseOperationalStatusEnum? get operationalStatus;
  // enum operationalStatusEnum {  running,  stopped,  degraded,  };

  @BuiltValueField(wireName: r'pressure_bar')
  num? get pressureBar;

  @BuiltValueField(wireName: r'priority_level')
  ReadingsResponsePriorityLevelEnum? get priorityLevel;
  // enum priorityLevelEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'recommendations')
  String? get recommendations;

  @BuiltValueField(wireName: r'recorded_at')
  DateTime? get recordedAt;

  @BuiltValueField(wireName: r'recorded_by')
  String? get recordedBy;

  @BuiltValueField(wireName: r'temperature_c')
  num? get temperatureC;

  @BuiltValueField(wireName: r'vibration_observation')
  String? get vibrationObservation;

  ReadingsResponse._();

  factory ReadingsResponse([void updates(ReadingsResponseBuilder b)]) =
      _$ReadingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadingsResponse> get serializer =>
      _$ReadingsResponseSerializer();
}

class _$ReadingsResponseSerializer
    implements PrimitiveSerializer<ReadingsResponse> {
  @override
  final Iterable<Type> types = const [ReadingsResponse, _$ReadingsResponse];

  @override
  final String wireName = r'ReadingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadingsResponse object, {
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
      specifiedType: const FullType(ReadingsResponseConditionEnum),
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
            const FullType.nullable(ReadingsResponseOperationalStatusEnum),
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
        specifiedType:
            const FullType.nullable(ReadingsResponsePriorityLevelEnum),
      );
    }
    if (object.recommendations != null) {
      yield r'recommendations';
      yield serializers.serialize(
        object.recommendations,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.recordedAt != null) {
      yield r'recorded_at';
      yield serializers.serialize(
        object.recordedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.recordedBy != null) {
      yield r'recorded_by';
      yield serializers.serialize(
        object.recordedBy,
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
    ReadingsResponse object, {
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
    required ReadingsResponseBuilder result,
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
            specifiedType: const FullType(ReadingsResponseConditionEnum),
          ) as ReadingsResponseConditionEnum;
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
                const FullType.nullable(ReadingsResponseOperationalStatusEnum),
          ) as ReadingsResponseOperationalStatusEnum?;
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
                const FullType.nullable(ReadingsResponsePriorityLevelEnum),
          ) as ReadingsResponsePriorityLevelEnum?;
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
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.recordedAt = valueDes;
          break;
        case r'recorded_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recordedBy = valueDes;
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
  ReadingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadingsResponseBuilder();
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

class ReadingsResponseConditionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Excellent')
  static const ReadingsResponseConditionEnum excellent =
      _$readingsResponseConditionEnum_excellent;
  @BuiltValueEnumConst(wireName: r'Good')
  static const ReadingsResponseConditionEnum good =
      _$readingsResponseConditionEnum_good;
  @BuiltValueEnumConst(wireName: r'Fair')
  static const ReadingsResponseConditionEnum fair =
      _$readingsResponseConditionEnum_fair;
  @BuiltValueEnumConst(wireName: r'Poor')
  static const ReadingsResponseConditionEnum poor =
      _$readingsResponseConditionEnum_poor;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const ReadingsResponseConditionEnum critical =
      _$readingsResponseConditionEnum_critical;

  static Serializer<ReadingsResponseConditionEnum> get serializer =>
      _$readingsResponseConditionEnumSerializer;

  const ReadingsResponseConditionEnum._(String name) : super(name);

  static BuiltSet<ReadingsResponseConditionEnum> get values =>
      _$readingsResponseConditionEnumValues;
  static ReadingsResponseConditionEnum valueOf(String name) =>
      _$readingsResponseConditionEnumValueOf(name);
}

class ReadingsResponseOperationalStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'running')
  static const ReadingsResponseOperationalStatusEnum running =
      _$readingsResponseOperationalStatusEnum_running;
  @BuiltValueEnumConst(wireName: r'stopped')
  static const ReadingsResponseOperationalStatusEnum stopped =
      _$readingsResponseOperationalStatusEnum_stopped;
  @BuiltValueEnumConst(wireName: r'degraded')
  static const ReadingsResponseOperationalStatusEnum degraded =
      _$readingsResponseOperationalStatusEnum_degraded;

  static Serializer<ReadingsResponseOperationalStatusEnum> get serializer =>
      _$readingsResponseOperationalStatusEnumSerializer;

  const ReadingsResponseOperationalStatusEnum._(String name) : super(name);

  static BuiltSet<ReadingsResponseOperationalStatusEnum> get values =>
      _$readingsResponseOperationalStatusEnumValues;
  static ReadingsResponseOperationalStatusEnum valueOf(String name) =>
      _$readingsResponseOperationalStatusEnumValueOf(name);
}

class ReadingsResponsePriorityLevelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const ReadingsResponsePriorityLevelEnum low =
      _$readingsResponsePriorityLevelEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const ReadingsResponsePriorityLevelEnum medium =
      _$readingsResponsePriorityLevelEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const ReadingsResponsePriorityLevelEnum high =
      _$readingsResponsePriorityLevelEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const ReadingsResponsePriorityLevelEnum critical =
      _$readingsResponsePriorityLevelEnum_critical;

  static Serializer<ReadingsResponsePriorityLevelEnum> get serializer =>
      _$readingsResponsePriorityLevelEnumSerializer;

  const ReadingsResponsePriorityLevelEnum._(String name) : super(name);

  static BuiltSet<ReadingsResponsePriorityLevelEnum> get values =>
      _$readingsResponsePriorityLevelEnumValues;
  static ReadingsResponsePriorityLevelEnum valueOf(String name) =>
      _$readingsResponsePriorityLevelEnumValueOf(name);
}
