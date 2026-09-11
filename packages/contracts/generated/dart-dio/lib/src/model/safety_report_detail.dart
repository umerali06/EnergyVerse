//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/corrective_action_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/safety_evidence_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_report_detail.g.dart';

/// SafetyReportDetail
///
/// Properties:
/// * [assignedAt]
/// * [assignedManagerId]
/// * [cancelledAt]
/// * [category]
/// * [closedAt]
/// * [closedBy]
/// * [correctiveActions]
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [evidence]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [occurredAt]
/// * [reporterId]
/// * [resolvedAt]
/// * [revision]
/// * [severity]
/// * [status]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class SafetyReportDetail
    implements Built<SafetyReportDetail, SafetyReportDetailBuilder> {
  @BuiltValueField(wireName: r'assigned_at')
  DateTime? get assignedAt;

  @BuiltValueField(wireName: r'assigned_manager_id')
  String? get assignedManagerId;

  @BuiltValueField(wireName: r'cancelled_at')
  DateTime? get cancelledAt;

  @BuiltValueField(wireName: r'category')
  SafetyReportDetailCategoryEnum get category;
  // enum categoryEnum {  near_miss,  unsafe_condition,  unsafe_behavior,  fire,  gas_leak,  chemical_spill,  environmental_incident,  equipment_failure,  injury,  };

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closed_by')
  String? get closedBy;

  @BuiltValueField(wireName: r'corrective_actions')
  BuiltList<CorrectiveActionResponse>? get correctiveActions;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<SafetyEvidenceResponse>? get evidence;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'reporter_id')
  String get reporterId;

  @BuiltValueField(wireName: r'resolved_at')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'severity')
  SafetyReportDetailSeverityEnum get severity;
  // enum severityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'status')
  SafetyReportDetailStatusEnum get status;
  // enum statusEnum {  reported,  under_review,  corrective_action,  resolved,  closed,  cancelled,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  SafetyReportDetail._();

  factory SafetyReportDetail([void updates(SafetyReportDetailBuilder b)]) =
      _$SafetyReportDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyReportDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyReportDetail> get serializer =>
      _$SafetyReportDetailSerializer();
}

class _$SafetyReportDetailSerializer
    implements PrimitiveSerializer<SafetyReportDetail> {
  @override
  final Iterable<Type> types = const [SafetyReportDetail, _$SafetyReportDetail];

  @override
  final String wireName = r'SafetyReportDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyReportDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.assignedAt != null) {
      yield r'assigned_at';
      yield serializers.serialize(
        object.assignedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.assignedManagerId != null) {
      yield r'assigned_manager_id';
      yield serializers.serialize(
        object.assignedManagerId,
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
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SafetyReportDetailCategoryEnum),
    );
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
    if (object.correctiveActions != null) {
      yield r'corrective_actions';
      yield serializers.serialize(
        object.correctiveActions,
        specifiedType:
            const FullType(BuiltList, [FullType(CorrectiveActionResponse)]),
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
    if (object.evidence != null) {
      yield r'evidence';
      yield serializers.serialize(
        object.evidence,
        specifiedType:
            const FullType(BuiltList, [FullType(SafetyEvidenceResponse)]),
      );
    }
    if (object.gpsLat != null) {
      yield r'gps_lat';
      yield serializers.serialize(
        object.gpsLat,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.gpsLng != null) {
      yield r'gps_lng';
      yield serializers.serialize(
        object.gpsLng,
        specifiedType: const FullType.nullable(num),
      );
    }
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
    if (object.resolvedAt != null) {
      yield r'resolved_at';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(SafetyReportDetailSeverityEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SafetyReportDetailStatusEnum),
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
    SafetyReportDetail object, {
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
    required SafetyReportDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assigned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.assignedAt = valueDes;
          break;
        case r'assigned_manager_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedManagerId = valueDes;
          break;
        case r'cancelled_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.cancelledAt = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyReportDetailCategoryEnum),
          ) as SafetyReportDetailCategoryEnum;
          result.category = valueDes;
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
        case r'corrective_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(CorrectiveActionResponse)]),
          ) as BuiltList<CorrectiveActionResponse>;
          result.correctiveActions.replace(valueDes);
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
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SafetyEvidenceResponse)]),
          ) as BuiltList<SafetyEvidenceResponse>;
          result.evidence.replace(valueDes);
          break;
        case r'gps_lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLat = valueDes;
          break;
        case r'gps_lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLng = valueDes;
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
        case r'resolved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
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
            specifiedType: const FullType(SafetyReportDetailSeverityEnum),
          ) as SafetyReportDetailSeverityEnum;
          result.severity = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyReportDetailStatusEnum),
          ) as SafetyReportDetailStatusEnum;
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
  SafetyReportDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyReportDetailBuilder();
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

class SafetyReportDetailCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'near_miss')
  static const SafetyReportDetailCategoryEnum nearMiss =
      _$safetyReportDetailCategoryEnum_nearMiss;
  @BuiltValueEnumConst(wireName: r'unsafe_condition')
  static const SafetyReportDetailCategoryEnum unsafeCondition =
      _$safetyReportDetailCategoryEnum_unsafeCondition;
  @BuiltValueEnumConst(wireName: r'unsafe_behavior')
  static const SafetyReportDetailCategoryEnum unsafeBehavior =
      _$safetyReportDetailCategoryEnum_unsafeBehavior;
  @BuiltValueEnumConst(wireName: r'fire')
  static const SafetyReportDetailCategoryEnum fire =
      _$safetyReportDetailCategoryEnum_fire;
  @BuiltValueEnumConst(wireName: r'gas_leak')
  static const SafetyReportDetailCategoryEnum gasLeak =
      _$safetyReportDetailCategoryEnum_gasLeak;
  @BuiltValueEnumConst(wireName: r'chemical_spill')
  static const SafetyReportDetailCategoryEnum chemicalSpill =
      _$safetyReportDetailCategoryEnum_chemicalSpill;
  @BuiltValueEnumConst(wireName: r'environmental_incident')
  static const SafetyReportDetailCategoryEnum environmentalIncident =
      _$safetyReportDetailCategoryEnum_environmentalIncident;
  @BuiltValueEnumConst(wireName: r'equipment_failure')
  static const SafetyReportDetailCategoryEnum equipmentFailure =
      _$safetyReportDetailCategoryEnum_equipmentFailure;
  @BuiltValueEnumConst(wireName: r'injury')
  static const SafetyReportDetailCategoryEnum injury =
      _$safetyReportDetailCategoryEnum_injury;

  static Serializer<SafetyReportDetailCategoryEnum> get serializer =>
      _$safetyReportDetailCategoryEnumSerializer;

  const SafetyReportDetailCategoryEnum._(String name) : super(name);

  static BuiltSet<SafetyReportDetailCategoryEnum> get values =>
      _$safetyReportDetailCategoryEnumValues;
  static SafetyReportDetailCategoryEnum valueOf(String name) =>
      _$safetyReportDetailCategoryEnumValueOf(name);
}

class SafetyReportDetailSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const SafetyReportDetailSeverityEnum low =
      _$safetyReportDetailSeverityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const SafetyReportDetailSeverityEnum medium =
      _$safetyReportDetailSeverityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const SafetyReportDetailSeverityEnum high =
      _$safetyReportDetailSeverityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const SafetyReportDetailSeverityEnum critical =
      _$safetyReportDetailSeverityEnum_critical;

  static Serializer<SafetyReportDetailSeverityEnum> get serializer =>
      _$safetyReportDetailSeverityEnumSerializer;

  const SafetyReportDetailSeverityEnum._(String name) : super(name);

  static BuiltSet<SafetyReportDetailSeverityEnum> get values =>
      _$safetyReportDetailSeverityEnumValues;
  static SafetyReportDetailSeverityEnum valueOf(String name) =>
      _$safetyReportDetailSeverityEnumValueOf(name);
}

class SafetyReportDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'reported')
  static const SafetyReportDetailStatusEnum reported =
      _$safetyReportDetailStatusEnum_reported;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const SafetyReportDetailStatusEnum underReview =
      _$safetyReportDetailStatusEnum_underReview;
  @BuiltValueEnumConst(wireName: r'corrective_action')
  static const SafetyReportDetailStatusEnum correctiveAction =
      _$safetyReportDetailStatusEnum_correctiveAction;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const SafetyReportDetailStatusEnum resolved =
      _$safetyReportDetailStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const SafetyReportDetailStatusEnum closed =
      _$safetyReportDetailStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const SafetyReportDetailStatusEnum cancelled =
      _$safetyReportDetailStatusEnum_cancelled;

  static Serializer<SafetyReportDetailStatusEnum> get serializer =>
      _$safetyReportDetailStatusEnumSerializer;

  const SafetyReportDetailStatusEnum._(String name) : super(name);

  static BuiltSet<SafetyReportDetailStatusEnum> get values =>
      _$safetyReportDetailStatusEnumValues;
  static SafetyReportDetailStatusEnum valueOf(String name) =>
      _$safetyReportDetailStatusEnumValueOf(name);
}
