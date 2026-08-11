//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_order_detail.g.dart';

/// WorkOrderDetail
///
/// Properties:
/// * [acceptedAt]
/// * [assetId]
/// * [assignedAt]
/// * [assignedBy]
/// * [cancelledAt]
/// * [closedAt]
/// * [closedBy]
/// * [completionNotes]
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [dueDate]
/// * [facilityId]
/// * [id]
/// * [laborHours]
/// * [materialsUsed]
/// * [priority]
/// * [revision]
/// * [sourceInspectionId]
/// * [status]
/// * [submittedAt]
/// * [technicianId]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class WorkOrderDetail
    implements Built<WorkOrderDetail, WorkOrderDetailBuilder> {
  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'assigned_at')
  DateTime? get assignedAt;

  @BuiltValueField(wireName: r'assigned_by')
  String? get assignedBy;

  @BuiltValueField(wireName: r'cancelled_at')
  DateTime? get cancelledAt;

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closed_by')
  String? get closedBy;

  @BuiltValueField(wireName: r'completion_notes')
  String? get completionNotes;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'due_date')
  DateTime? get dueDate;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'labor_hours')
  num? get laborHours;

  @BuiltValueField(wireName: r'materials_used')
  BuiltList<String>? get materialsUsed;

  @BuiltValueField(wireName: r'priority')
  WorkOrderDetailPriorityEnum get priority;
  // enum priorityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'source_inspection_id')
  String? get sourceInspectionId;

  @BuiltValueField(wireName: r'status')
  WorkOrderDetailStatusEnum get status;
  // enum statusEnum {  open,  assigned,  in_progress,  pending_review,  closed,  cancelled,  };

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'technician_id')
  String? get technicianId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  WorkOrderDetail._();

  factory WorkOrderDetail([void updates(WorkOrderDetailBuilder b)]) =
      _$WorkOrderDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkOrderDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkOrderDetail> get serializer =>
      _$WorkOrderDetailSerializer();
}

class _$WorkOrderDetailSerializer
    implements PrimitiveSerializer<WorkOrderDetail> {
  @override
  final Iterable<Type> types = const [WorkOrderDetail, _$WorkOrderDetail];

  @override
  final String wireName = r'WorkOrderDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkOrderDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.acceptedAt != null) {
      yield r'accepted_at';
      yield serializers.serialize(
        object.acceptedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.assignedAt != null) {
      yield r'assigned_at';
      yield serializers.serialize(
        object.assignedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.assignedBy != null) {
      yield r'assigned_by';
      yield serializers.serialize(
        object.assignedBy,
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
    if (object.closedAt != null) {
      yield r'closed_at';
      yield serializers.serialize(
        object.closedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.closedBy != null) {
      yield r'closed_by';
      yield serializers.serialize(
        object.closedBy,
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
    if (object.laborHours != null) {
      yield r'labor_hours';
      yield serializers.serialize(
        object.laborHours,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.materialsUsed != null) {
      yield r'materials_used';
      yield serializers.serialize(
        object.materialsUsed,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(WorkOrderDetailPriorityEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.sourceInspectionId != null) {
      yield r'source_inspection_id';
      yield serializers.serialize(
        object.sourceInspectionId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkOrderDetailStatusEnum),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
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
    WorkOrderDetail object, {
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
    required WorkOrderDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'assigned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.assignedAt = valueDes;
          break;
        case r'assigned_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedBy = valueDes;
          break;
        case r'cancelled_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.cancelledAt = valueDes;
          break;
        case r'closed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closedBy = valueDes;
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
        case r'labor_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.laborHours = valueDes;
          break;
        case r'materials_used':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.materialsUsed.replace(valueDes);
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkOrderDetailPriorityEnum),
          ) as WorkOrderDetailPriorityEnum;
          result.priority = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'source_inspection_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceInspectionId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkOrderDetailStatusEnum),
          ) as WorkOrderDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
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
  WorkOrderDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkOrderDetailBuilder();
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

class WorkOrderDetailPriorityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const WorkOrderDetailPriorityEnum low =
      _$workOrderDetailPriorityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const WorkOrderDetailPriorityEnum medium =
      _$workOrderDetailPriorityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const WorkOrderDetailPriorityEnum high =
      _$workOrderDetailPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const WorkOrderDetailPriorityEnum critical =
      _$workOrderDetailPriorityEnum_critical;

  static Serializer<WorkOrderDetailPriorityEnum> get serializer =>
      _$workOrderDetailPriorityEnumSerializer;

  const WorkOrderDetailPriorityEnum._(String name) : super(name);

  static BuiltSet<WorkOrderDetailPriorityEnum> get values =>
      _$workOrderDetailPriorityEnumValues;
  static WorkOrderDetailPriorityEnum valueOf(String name) =>
      _$workOrderDetailPriorityEnumValueOf(name);
}

class WorkOrderDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const WorkOrderDetailStatusEnum open =
      _$workOrderDetailStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const WorkOrderDetailStatusEnum assigned =
      _$workOrderDetailStatusEnum_assigned;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const WorkOrderDetailStatusEnum inProgress =
      _$workOrderDetailStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'pending_review')
  static const WorkOrderDetailStatusEnum pendingReview =
      _$workOrderDetailStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'closed')
  static const WorkOrderDetailStatusEnum closed =
      _$workOrderDetailStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const WorkOrderDetailStatusEnum cancelled =
      _$workOrderDetailStatusEnum_cancelled;

  static Serializer<WorkOrderDetailStatusEnum> get serializer =>
      _$workOrderDetailStatusEnumSerializer;

  const WorkOrderDetailStatusEnum._(String name) : super(name);

  static BuiltSet<WorkOrderDetailStatusEnum> get values =>
      _$workOrderDetailStatusEnumValues;
  static WorkOrderDetailStatusEnum valueOf(String name) =>
      _$workOrderDetailStatusEnumValueOf(name);
}
