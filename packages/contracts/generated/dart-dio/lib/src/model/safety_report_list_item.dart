//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_report_list_item.g.dart';

/// SafetyReportListItem
///
/// Properties:
/// * [assignedManagerId]
/// * [category]
/// * [createdAt]
/// * [id]
/// * [occurredAt]
/// * [reporterId]
/// * [revision]
/// * [severity]
/// * [status]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class SafetyReportListItem
    implements Built<SafetyReportListItem, SafetyReportListItemBuilder> {
  @BuiltValueField(wireName: r'assigned_manager_id')
  String? get assignedManagerId;

  @BuiltValueField(wireName: r'category')
  SafetyReportListItemCategoryEnum get category;
  // enum categoryEnum {  near_miss,  unsafe_condition,  unsafe_behavior,  fire,  gas_leak,  chemical_spill,  environmental_incident,  equipment_failure,  injury,  };

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'reporter_id')
  String get reporterId;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'severity')
  SafetyReportListItemSeverityEnum get severity;
  // enum severityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'status')
  SafetyReportListItemStatusEnum get status;
  // enum statusEnum {  reported,  under_review,  corrective_action,  resolved,  closed,  cancelled,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  SafetyReportListItem._();

  factory SafetyReportListItem([void updates(SafetyReportListItemBuilder b)]) =
      _$SafetyReportListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyReportListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyReportListItem> get serializer =>
      _$SafetyReportListItemSerializer();
}

class _$SafetyReportListItemSerializer
    implements PrimitiveSerializer<SafetyReportListItem> {
  @override
  final Iterable<Type> types = const [
    SafetyReportListItem,
    _$SafetyReportListItem
  ];

  @override
  final String wireName = r'SafetyReportListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyReportListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.assignedManagerId != null) {
      yield r'assigned_manager_id';
      yield serializers.serialize(
        object.assignedManagerId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SafetyReportListItemCategoryEnum),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reporter_id';
    yield serializers.serialize(
      object.reporterId,
      specifiedType: const FullType(String),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(SafetyReportListItemSeverityEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SafetyReportListItemStatusEnum),
    );
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
    SafetyReportListItem object, {
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
    required SafetyReportListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assigned_manager_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedManagerId = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyReportListItemCategoryEnum),
          ) as SafetyReportListItemCategoryEnum;
          result.category = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'reporter_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reporterId = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyReportListItemSeverityEnum),
          ) as SafetyReportListItemSeverityEnum;
          result.severity = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyReportListItemStatusEnum),
          ) as SafetyReportListItemStatusEnum;
          result.status = valueDes;
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
  SafetyReportListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyReportListItemBuilder();
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

class SafetyReportListItemCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'near_miss')
  static const SafetyReportListItemCategoryEnum nearMiss =
      _$safetyReportListItemCategoryEnum_nearMiss;
  @BuiltValueEnumConst(wireName: r'unsafe_condition')
  static const SafetyReportListItemCategoryEnum unsafeCondition =
      _$safetyReportListItemCategoryEnum_unsafeCondition;
  @BuiltValueEnumConst(wireName: r'unsafe_behavior')
  static const SafetyReportListItemCategoryEnum unsafeBehavior =
      _$safetyReportListItemCategoryEnum_unsafeBehavior;
  @BuiltValueEnumConst(wireName: r'fire')
  static const SafetyReportListItemCategoryEnum fire =
      _$safetyReportListItemCategoryEnum_fire;
  @BuiltValueEnumConst(wireName: r'gas_leak')
  static const SafetyReportListItemCategoryEnum gasLeak =
      _$safetyReportListItemCategoryEnum_gasLeak;
  @BuiltValueEnumConst(wireName: r'chemical_spill')
  static const SafetyReportListItemCategoryEnum chemicalSpill =
      _$safetyReportListItemCategoryEnum_chemicalSpill;
  @BuiltValueEnumConst(wireName: r'environmental_incident')
  static const SafetyReportListItemCategoryEnum environmentalIncident =
      _$safetyReportListItemCategoryEnum_environmentalIncident;
  @BuiltValueEnumConst(wireName: r'equipment_failure')
  static const SafetyReportListItemCategoryEnum equipmentFailure =
      _$safetyReportListItemCategoryEnum_equipmentFailure;
  @BuiltValueEnumConst(wireName: r'injury')
  static const SafetyReportListItemCategoryEnum injury =
      _$safetyReportListItemCategoryEnum_injury;

  static Serializer<SafetyReportListItemCategoryEnum> get serializer =>
      _$safetyReportListItemCategoryEnumSerializer;

  const SafetyReportListItemCategoryEnum._(String name) : super(name);

  static BuiltSet<SafetyReportListItemCategoryEnum> get values =>
      _$safetyReportListItemCategoryEnumValues;
  static SafetyReportListItemCategoryEnum valueOf(String name) =>
      _$safetyReportListItemCategoryEnumValueOf(name);
}

class SafetyReportListItemSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const SafetyReportListItemSeverityEnum low =
      _$safetyReportListItemSeverityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const SafetyReportListItemSeverityEnum medium =
      _$safetyReportListItemSeverityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const SafetyReportListItemSeverityEnum high =
      _$safetyReportListItemSeverityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const SafetyReportListItemSeverityEnum critical =
      _$safetyReportListItemSeverityEnum_critical;

  static Serializer<SafetyReportListItemSeverityEnum> get serializer =>
      _$safetyReportListItemSeverityEnumSerializer;

  const SafetyReportListItemSeverityEnum._(String name) : super(name);

  static BuiltSet<SafetyReportListItemSeverityEnum> get values =>
      _$safetyReportListItemSeverityEnumValues;
  static SafetyReportListItemSeverityEnum valueOf(String name) =>
      _$safetyReportListItemSeverityEnumValueOf(name);
}

class SafetyReportListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'reported')
  static const SafetyReportListItemStatusEnum reported =
      _$safetyReportListItemStatusEnum_reported;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const SafetyReportListItemStatusEnum underReview =
      _$safetyReportListItemStatusEnum_underReview;
  @BuiltValueEnumConst(wireName: r'corrective_action')
  static const SafetyReportListItemStatusEnum correctiveAction =
      _$safetyReportListItemStatusEnum_correctiveAction;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const SafetyReportListItemStatusEnum resolved =
      _$safetyReportListItemStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const SafetyReportListItemStatusEnum closed =
      _$safetyReportListItemStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const SafetyReportListItemStatusEnum cancelled =
      _$safetyReportListItemStatusEnum_cancelled;

  static Serializer<SafetyReportListItemStatusEnum> get serializer =>
      _$safetyReportListItemStatusEnumSerializer;

  const SafetyReportListItemStatusEnum._(String name) : super(name);

  static BuiltSet<SafetyReportListItemStatusEnum> get values =>
      _$safetyReportListItemStatusEnumValues;
  static SafetyReportListItemStatusEnum valueOf(String name) =>
      _$safetyReportListItemStatusEnumValueOf(name);
}
