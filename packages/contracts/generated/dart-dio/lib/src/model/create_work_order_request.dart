//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_work_order_request.g.dart';

/// CreateWorkOrderRequest
///
/// Properties:
/// * [assetId]
/// * [description]
/// * [dueDate]
/// * [id]
/// * [priority]
/// * [sourceInspectionId]
/// * [title]
@BuiltValue()
abstract class CreateWorkOrderRequest
    implements Built<CreateWorkOrderRequest, CreateWorkOrderRequestBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'due_date')
  DateTime? get dueDate;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'priority')
  CreateWorkOrderRequestPriorityEnum? get priority;
  // enum priorityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'source_inspection_id')
  String? get sourceInspectionId;

  @BuiltValueField(wireName: r'title')
  String get title;

  CreateWorkOrderRequest._();

  factory CreateWorkOrderRequest(
          [void updates(CreateWorkOrderRequestBuilder b)]) =
      _$CreateWorkOrderRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateWorkOrderRequestBuilder b) =>
      b..priority = const CreateWorkOrderRequestPriorityEnum._('medium');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateWorkOrderRequest> get serializer =>
      _$CreateWorkOrderRequestSerializer();
}

class _$CreateWorkOrderRequestSerializer
    implements PrimitiveSerializer<CreateWorkOrderRequest> {
  @override
  final Iterable<Type> types = const [
    CreateWorkOrderRequest,
    _$CreateWorkOrderRequest
  ];

  @override
  final String wireName = r'CreateWorkOrderRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateWorkOrderRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType: const FullType(CreateWorkOrderRequestPriorityEnum),
      );
    }
    if (object.sourceInspectionId != null) {
      yield r'source_inspection_id';
      yield serializers.serialize(
        object.sourceInspectionId,
        specifiedType: const FullType.nullable(String),
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
    CreateWorkOrderRequest object, {
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
    required CreateWorkOrderRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType(CreateWorkOrderRequestPriorityEnum),
          ) as CreateWorkOrderRequestPriorityEnum;
          result.priority = valueDes;
          break;
        case r'source_inspection_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceInspectionId = valueDes;
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
  CreateWorkOrderRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateWorkOrderRequestBuilder();
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

class CreateWorkOrderRequestPriorityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const CreateWorkOrderRequestPriorityEnum low =
      _$createWorkOrderRequestPriorityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const CreateWorkOrderRequestPriorityEnum medium =
      _$createWorkOrderRequestPriorityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const CreateWorkOrderRequestPriorityEnum high =
      _$createWorkOrderRequestPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const CreateWorkOrderRequestPriorityEnum critical =
      _$createWorkOrderRequestPriorityEnum_critical;

  static Serializer<CreateWorkOrderRequestPriorityEnum> get serializer =>
      _$createWorkOrderRequestPriorityEnumSerializer;

  const CreateWorkOrderRequestPriorityEnum._(String name) : super(name);

  static BuiltSet<CreateWorkOrderRequestPriorityEnum> get values =>
      _$createWorkOrderRequestPriorityEnumValues;
  static CreateWorkOrderRequestPriorityEnum valueOf(String name) =>
      _$createWorkOrderRequestPriorityEnumValueOf(name);
}
