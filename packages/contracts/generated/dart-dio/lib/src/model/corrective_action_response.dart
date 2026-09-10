//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'corrective_action_response.g.dart';

/// CorrectiveActionResponse
///
/// Properties:
/// * [assigneeId]
/// * [cancellationReason]
/// * [cancelledAt]
/// * [cancelledBy]
/// * [completedAt]
/// * [completedBy]
/// * [completionNotes]
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [dueDate]
/// * [id]
/// * [priority]
/// * [startedAt]
/// * [status]
/// * [updatedAt]
@BuiltValue()
abstract class CorrectiveActionResponse
    implements
        Built<CorrectiveActionResponse, CorrectiveActionResponseBuilder> {
  @BuiltValueField(wireName: r'assignee_id')
  String get assigneeId;

  @BuiltValueField(wireName: r'cancellation_reason')
  String? get cancellationReason;

  @BuiltValueField(wireName: r'cancelled_at')
  DateTime? get cancelledAt;

  @BuiltValueField(wireName: r'cancelled_by')
  String? get cancelledBy;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'completed_by')
  String? get completedBy;

  @BuiltValueField(wireName: r'completion_notes')
  String? get completionNotes;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'due_date')
  DateTime get dueDate;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'priority')
  CorrectiveActionResponsePriorityEnum get priority;
  // enum priorityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'started_at')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'status')
  CorrectiveActionResponseStatusEnum get status;
  // enum statusEnum {  open,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  CorrectiveActionResponse._();

  factory CorrectiveActionResponse(
          [void updates(CorrectiveActionResponseBuilder b)]) =
      _$CorrectiveActionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CorrectiveActionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CorrectiveActionResponse> get serializer =>
      _$CorrectiveActionResponseSerializer();
}

class _$CorrectiveActionResponseSerializer
    implements PrimitiveSerializer<CorrectiveActionResponse> {
  @override
  final Iterable<Type> types = const [
    CorrectiveActionResponse,
    _$CorrectiveActionResponse
  ];

  @override
  final String wireName = r'CorrectiveActionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CorrectiveActionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assignee_id';
    yield serializers.serialize(
      object.assigneeId,
      specifiedType: const FullType(String),
    );
    if (object.cancellationReason != null) {
      yield r'cancellation_reason';
      yield serializers.serialize(
        object.cancellationReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cancelledAt != null) {
      yield r'cancelled_at';
      yield serializers.serialize(
        object.cancelledAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.cancelledBy != null) {
      yield r'cancelled_by';
      yield serializers.serialize(
        object.cancelledBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.completedBy != null) {
      yield r'completed_by';
      yield serializers.serialize(
        object.completedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.completionNotes != null) {
      yield r'completion_notes';
      yield serializers.serialize(
        object.completionNotes,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_by';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'due_date';
    yield serializers.serialize(
      object.dueDate,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(CorrectiveActionResponsePriorityEnum),
    );
    if (object.startedAt != null) {
      yield r'started_at';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CorrectiveActionResponseStatusEnum),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CorrectiveActionResponse object, {
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
    required CorrectiveActionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assignee_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assigneeId = valueDes;
          break;
        case r'cancellation_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cancellationReason = valueDes;
          break;
        case r'cancelled_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.cancelledAt = valueDes;
          break;
        case r'cancelled_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cancelledBy = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'completed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.completedBy = valueDes;
          break;
        case r'completion_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.completionNotes = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdBy = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueDate = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CorrectiveActionResponsePriorityEnum),
          ) as CorrectiveActionResponsePriorityEnum;
          result.priority = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CorrectiveActionResponseStatusEnum),
          ) as CorrectiveActionResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CorrectiveActionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CorrectiveActionResponseBuilder();
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

class CorrectiveActionResponsePriorityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const CorrectiveActionResponsePriorityEnum low =
      _$correctiveActionResponsePriorityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const CorrectiveActionResponsePriorityEnum medium =
      _$correctiveActionResponsePriorityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const CorrectiveActionResponsePriorityEnum high =
      _$correctiveActionResponsePriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const CorrectiveActionResponsePriorityEnum critical =
      _$correctiveActionResponsePriorityEnum_critical;

  static Serializer<CorrectiveActionResponsePriorityEnum> get serializer =>
      _$correctiveActionResponsePriorityEnumSerializer;

  const CorrectiveActionResponsePriorityEnum._(String name) : super(name);

  static BuiltSet<CorrectiveActionResponsePriorityEnum> get values =>
      _$correctiveActionResponsePriorityEnumValues;
  static CorrectiveActionResponsePriorityEnum valueOf(String name) =>
      _$correctiveActionResponsePriorityEnumValueOf(name);
}

class CorrectiveActionResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const CorrectiveActionResponseStatusEnum open =
      _$correctiveActionResponseStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const CorrectiveActionResponseStatusEnum inProgress =
      _$correctiveActionResponseStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const CorrectiveActionResponseStatusEnum completed =
      _$correctiveActionResponseStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CorrectiveActionResponseStatusEnum cancelled =
      _$correctiveActionResponseStatusEnum_cancelled;

  static Serializer<CorrectiveActionResponseStatusEnum> get serializer =>
      _$correctiveActionResponseStatusEnumSerializer;

  const CorrectiveActionResponseStatusEnum._(String name) : super(name);

  static BuiltSet<CorrectiveActionResponseStatusEnum> get values =>
      _$correctiveActionResponseStatusEnumValues;
  static CorrectiveActionResponseStatusEnum valueOf(String name) =>
      _$correctiveActionResponseStatusEnumValueOf(name);
}
