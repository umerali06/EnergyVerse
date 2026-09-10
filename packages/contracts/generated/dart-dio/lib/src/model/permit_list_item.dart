//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_list_item.g.dart';

/// PermitListItem
///
/// Properties:
/// * [createdAt]
/// * [facilityId]
/// * [highestResidualRisk]
/// * [id]
/// * [permitNumber]
/// * [permitType]
/// * [revision]
/// * [status]
/// * [title]
/// * [updatedAt]
/// * [validFrom]
/// * [validUntil]
/// * [workerCount]
@BuiltValue()
abstract class PermitListItem
    implements Built<PermitListItem, PermitListItemBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'highest_residual_risk')
  PermitListItemHighestResidualRiskEnum get highestResidualRisk;
  // enum highestResidualRiskEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'permit_number')
  String get permitNumber;

  @BuiltValueField(wireName: r'permit_type')
  PermitListItemPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'status')
  PermitListItemStatusEnum get status;
  // enum statusEnum {  draft,  pending_approval,  pending_signatures,  active,  closed,  expired,  suspended,  revoked,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'valid_from')
  DateTime get validFrom;

  @BuiltValueField(wireName: r'valid_until')
  DateTime get validUntil;

  @BuiltValueField(wireName: r'worker_count')
  int get workerCount;

  PermitListItem._();

  factory PermitListItem([void updates(PermitListItemBuilder b)]) =
      _$PermitListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitListItem> get serializer =>
      _$PermitListItemSerializer();
}

class _$PermitListItemSerializer
    implements PrimitiveSerializer<PermitListItem> {
  @override
  final Iterable<Type> types = const [PermitListItem, _$PermitListItem];

  @override
  final String wireName = r'PermitListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'highest_residual_risk';
    yield serializers.serialize(
      object.highestResidualRisk,
      specifiedType: const FullType(PermitListItemHighestResidualRiskEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'permit_number';
    yield serializers.serialize(
      object.permitNumber,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(PermitListItemPermitTypeEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PermitListItemStatusEnum),
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
    yield r'valid_from';
    yield serializers.serialize(
      object.validFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'valid_until';
    yield serializers.serialize(
      object.validUntil,
      specifiedType: const FullType(DateTime),
    );
    yield r'worker_count';
    yield serializers.serialize(
      object.workerCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitListItem object, {
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
    required PermitListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'highest_residual_risk':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(PermitListItemHighestResidualRiskEnum),
          ) as PermitListItemHighestResidualRiskEnum;
          result.highestResidualRisk = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'permit_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.permitNumber = valueDes;
          break;
        case r'permit_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PermitListItemPermitTypeEnum),
          ) as PermitListItemPermitTypeEnum;
          result.permitType = valueDes;
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
            specifiedType: const FullType(PermitListItemStatusEnum),
          ) as PermitListItemStatusEnum;
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
        case r'valid_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.validFrom = valueDes;
          break;
        case r'valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.validUntil = valueDes;
          break;
        case r'worker_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workerCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitListItemBuilder();
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

class PermitListItemHighestResidualRiskEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const PermitListItemHighestResidualRiskEnum low =
      _$permitListItemHighestResidualRiskEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const PermitListItemHighestResidualRiskEnum medium =
      _$permitListItemHighestResidualRiskEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const PermitListItemHighestResidualRiskEnum high =
      _$permitListItemHighestResidualRiskEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const PermitListItemHighestResidualRiskEnum critical =
      _$permitListItemHighestResidualRiskEnum_critical;

  static Serializer<PermitListItemHighestResidualRiskEnum> get serializer =>
      _$permitListItemHighestResidualRiskEnumSerializer;

  const PermitListItemHighestResidualRiskEnum._(String name) : super(name);

  static BuiltSet<PermitListItemHighestResidualRiskEnum> get values =>
      _$permitListItemHighestResidualRiskEnumValues;
  static PermitListItemHighestResidualRiskEnum valueOf(String name) =>
      _$permitListItemHighestResidualRiskEnumValueOf(name);
}

class PermitListItemPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const PermitListItemPermitTypeEnum hotWork =
      _$permitListItemPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const PermitListItemPermitTypeEnum confinedSpace =
      _$permitListItemPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const PermitListItemPermitTypeEnum electricalIsolationLoto =
      _$permitListItemPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const PermitListItemPermitTypeEnum excavation =
      _$permitListItemPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const PermitListItemPermitTypeEnum workingAtHeight =
      _$permitListItemPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const PermitListItemPermitTypeEnum generalMaintenance =
      _$permitListItemPermitTypeEnum_generalMaintenance;

  static Serializer<PermitListItemPermitTypeEnum> get serializer =>
      _$permitListItemPermitTypeEnumSerializer;

  const PermitListItemPermitTypeEnum._(String name) : super(name);

  static BuiltSet<PermitListItemPermitTypeEnum> get values =>
      _$permitListItemPermitTypeEnumValues;
  static PermitListItemPermitTypeEnum valueOf(String name) =>
      _$permitListItemPermitTypeEnumValueOf(name);
}

class PermitListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const PermitListItemStatusEnum draft =
      _$permitListItemStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'pending_approval')
  static const PermitListItemStatusEnum pendingApproval =
      _$permitListItemStatusEnum_pendingApproval;
  @BuiltValueEnumConst(wireName: r'pending_signatures')
  static const PermitListItemStatusEnum pendingSignatures =
      _$permitListItemStatusEnum_pendingSignatures;
  @BuiltValueEnumConst(wireName: r'active')
  static const PermitListItemStatusEnum active =
      _$permitListItemStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'closed')
  static const PermitListItemStatusEnum closed =
      _$permitListItemStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'expired')
  static const PermitListItemStatusEnum expired =
      _$permitListItemStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const PermitListItemStatusEnum suspended =
      _$permitListItemStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'revoked')
  static const PermitListItemStatusEnum revoked =
      _$permitListItemStatusEnum_revoked;

  static Serializer<PermitListItemStatusEnum> get serializer =>
      _$permitListItemStatusEnumSerializer;

  const PermitListItemStatusEnum._(String name) : super(name);

  static BuiltSet<PermitListItemStatusEnum> get values =>
      _$permitListItemStatusEnumValues;
  static PermitListItemStatusEnum valueOf(String name) =>
      _$permitListItemStatusEnumValueOf(name);
}
