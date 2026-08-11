//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_order_list_item.g.dart';

/// WorkOrderListItem
///
/// Properties:
/// * [assetId]
/// * [createdAt]
/// * [dueDate]
/// * [facilityId]
/// * [id]
/// * [priority]
/// * [revision]
/// * [status]
/// * [technicianId]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class WorkOrderListItem
    implements Built<WorkOrderListItem, WorkOrderListItemBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'due_date')
  DateTime? get dueDate;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'priority')
  WorkOrderListItemPriorityEnum get priority;
  // enum priorityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'status')
  WorkOrderListItemStatusEnum get status;
  // enum statusEnum {  open,  assigned,  in_progress,  pending_review,  closed,  cancelled,  };

  @BuiltValueField(wireName: r'technician_id')
  String? get technicianId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  WorkOrderListItem._();

  factory WorkOrderListItem([void updates(WorkOrderListItemBuilder b)]) =
      _$WorkOrderListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkOrderListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkOrderListItem> get serializer =>
      _$WorkOrderListItemSerializer();
}

class _$WorkOrderListItemSerializer
    implements PrimitiveSerializer<WorkOrderListItem> {
  @override
  final Iterable<Type> types = const [WorkOrderListItem, _$WorkOrderListItem];

  @override
  final String wireName = r'WorkOrderListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkOrderListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
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
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(WorkOrderListItemPriorityEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkOrderListItemStatusEnum),
    );
    if (object.technicianId != null) {
      yield r'technician_id';
      yield serializers.serialize(
        object.technicianId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
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
    WorkOrderListItem object, {
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
    required WorkOrderListItemBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueDate = valueDes;
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
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkOrderListItemPriorityEnum),
          ) as WorkOrderListItemPriorityEnum;
          result.priority = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkOrderListItemStatusEnum),
          ) as WorkOrderListItemStatusEnum;
          result.status = valueDes;
          break;
        case r'technician_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.technicianId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
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
  WorkOrderListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkOrderListItemBuilder();
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

class WorkOrderListItemPriorityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const WorkOrderListItemPriorityEnum low =
      _$workOrderListItemPriorityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const WorkOrderListItemPriorityEnum medium =
      _$workOrderListItemPriorityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const WorkOrderListItemPriorityEnum high =
      _$workOrderListItemPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const WorkOrderListItemPriorityEnum critical =
      _$workOrderListItemPriorityEnum_critical;

  static Serializer<WorkOrderListItemPriorityEnum> get serializer =>
      _$workOrderListItemPriorityEnumSerializer;

  const WorkOrderListItemPriorityEnum._(String name) : super(name);

  static BuiltSet<WorkOrderListItemPriorityEnum> get values =>
      _$workOrderListItemPriorityEnumValues;
  static WorkOrderListItemPriorityEnum valueOf(String name) =>
      _$workOrderListItemPriorityEnumValueOf(name);
}

class WorkOrderListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const WorkOrderListItemStatusEnum open =
      _$workOrderListItemStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const WorkOrderListItemStatusEnum assigned =
      _$workOrderListItemStatusEnum_assigned;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const WorkOrderListItemStatusEnum inProgress =
      _$workOrderListItemStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'pending_review')
  static const WorkOrderListItemStatusEnum pendingReview =
      _$workOrderListItemStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'closed')
  static const WorkOrderListItemStatusEnum closed =
      _$workOrderListItemStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const WorkOrderListItemStatusEnum cancelled =
      _$workOrderListItemStatusEnum_cancelled;

  static Serializer<WorkOrderListItemStatusEnum> get serializer =>
      _$workOrderListItemStatusEnumSerializer;

  const WorkOrderListItemStatusEnum._(String name) : super(name);

  static BuiltSet<WorkOrderListItemStatusEnum> get values =>
      _$workOrderListItemStatusEnumValues;
  static WorkOrderListItemStatusEnum valueOf(String name) =>
      _$workOrderListItemStatusEnumValueOf(name);
}
