//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_corrective_action_request.g.dart';

/// CreateCorrectiveActionRequest
///
/// Properties:
/// * [assigneeId]
/// * [description]
/// * [dueDate]
/// * [id]
/// * [priority]
@BuiltValue()
abstract class CreateCorrectiveActionRequest
    implements
        Built<CreateCorrectiveActionRequest,
            CreateCorrectiveActionRequestBuilder> {
  @BuiltValueField(wireName: r'assignee_id')
  String get assigneeId;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'due_date')
  DateTime get dueDate;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'priority')
  CreateCorrectiveActionRequestPriorityEnum? get priority;
  // enum priorityEnum {  low,  medium,  high,  critical,  };

  CreateCorrectiveActionRequest._();

  factory CreateCorrectiveActionRequest(
          [void updates(CreateCorrectiveActionRequestBuilder b)]) =
      _$CreateCorrectiveActionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCorrectiveActionRequestBuilder b) =>
      b..priority = const CreateCorrectiveActionRequestPriorityEnum._('medium');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCorrectiveActionRequest> get serializer =>
      _$CreateCorrectiveActionRequestSerializer();
}

class _$CreateCorrectiveActionRequestSerializer
    implements PrimitiveSerializer<CreateCorrectiveActionRequest> {
  @override
  final Iterable<Type> types = const [
    CreateCorrectiveActionRequest,
    _$CreateCorrectiveActionRequest
  ];

  @override
  final String wireName = r'CreateCorrectiveActionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCorrectiveActionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assignee_id';
    yield serializers.serialize(
      object.assigneeId,
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
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType:
            const FullType(CreateCorrectiveActionRequestPriorityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateCorrectiveActionRequest object, {
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
    required CreateCorrectiveActionRequestBuilder result,
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
            specifiedType:
                const FullType(CreateCorrectiveActionRequestPriorityEnum),
          ) as CreateCorrectiveActionRequestPriorityEnum;
          result.priority = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateCorrectiveActionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCorrectiveActionRequestBuilder();
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

class CreateCorrectiveActionRequestPriorityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const CreateCorrectiveActionRequestPriorityEnum low =
      _$createCorrectiveActionRequestPriorityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const CreateCorrectiveActionRequestPriorityEnum medium =
      _$createCorrectiveActionRequestPriorityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const CreateCorrectiveActionRequestPriorityEnum high =
      _$createCorrectiveActionRequestPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const CreateCorrectiveActionRequestPriorityEnum critical =
      _$createCorrectiveActionRequestPriorityEnum_critical;

  static Serializer<CreateCorrectiveActionRequestPriorityEnum> get serializer =>
      _$createCorrectiveActionRequestPriorityEnumSerializer;

  const CreateCorrectiveActionRequestPriorityEnum._(String name) : super(name);

  static BuiltSet<CreateCorrectiveActionRequestPriorityEnum> get values =>
      _$createCorrectiveActionRequestPriorityEnumValues;
  static CreateCorrectiveActionRequestPriorityEnum valueOf(String name) =>
      _$createCorrectiveActionRequestPriorityEnumValueOf(name);
}
