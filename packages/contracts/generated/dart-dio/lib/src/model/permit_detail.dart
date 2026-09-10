//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/permit_risk_assessment_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_approval_snapshot_response.dart';
import 'package:fev_api_client/src/model/permit_checklist_snapshot_response.dart';
import 'package:fev_api_client/src/model/permit_worker_acknowledgement_response.dart';
import 'package:fev_api_client/src/model/permit_digital_signature_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_detail.g.dart';

/// PermitDetail
///
/// Properties:
/// * [activatedAt]
/// * [activatedBy]
/// * [approvalSnapshot]
/// * [areaId]
/// * [assetId]
/// * [checklistSnapshot]
/// * [closedAt]
/// * [closedBy]
/// * [closeoutNotes]
/// * [createdAt]
/// * [description]
/// * [expiredAt]
/// * [facilityId]
/// * [highestResidualRisk]
/// * [id]
/// * [issuerSignature]
/// * [permitNumber]
/// * [permitType]
/// * [revision]
/// * [revocationReason]
/// * [revokedAt]
/// * [revokedBy]
/// * [riskAssessment]
/// * [status]
/// * [submittedAt]
/// * [suspendedAt]
/// * [suspendedBy]
/// * [suspensionReason]
/// * [templateId]
/// * [templateName]
/// * [templateVersion]
/// * [title]
/// * [updatedAt]
/// * [validFrom]
/// * [validUntil]
/// * [workerAcknowledgements]
/// * [workerCount]
/// * [workerIds]
@BuiltValue()
abstract class PermitDetail
    implements Built<PermitDetail, PermitDetailBuilder> {
  @BuiltValueField(wireName: r'activated_at')
  DateTime? get activatedAt;

  @BuiltValueField(wireName: r'activated_by')
  String? get activatedBy;

  @BuiltValueField(wireName: r'approval_snapshot')
  BuiltList<PermitApprovalSnapshotResponse> get approvalSnapshot;

  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'checklist_snapshot')
  BuiltList<PermitChecklistSnapshotResponse> get checklistSnapshot;

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closed_by')
  String? get closedBy;

  @BuiltValueField(wireName: r'closeout_notes')
  String? get closeoutNotes;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'expired_at')
  DateTime? get expiredAt;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'highest_residual_risk')
  PermitDetailHighestResidualRiskEnum get highestResidualRisk;
  // enum highestResidualRiskEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'issuer_signature')
  PermitDigitalSignatureResponse? get issuerSignature;

  @BuiltValueField(wireName: r'permit_number')
  String get permitNumber;

  @BuiltValueField(wireName: r'permit_type')
  PermitDetailPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'revocation_reason')
  String? get revocationReason;

  @BuiltValueField(wireName: r'revoked_at')
  DateTime? get revokedAt;

  @BuiltValueField(wireName: r'revoked_by')
  String? get revokedBy;

  @BuiltValueField(wireName: r'risk_assessment')
  BuiltList<PermitRiskAssessmentResponse> get riskAssessment;

  @BuiltValueField(wireName: r'status')
  PermitDetailStatusEnum get status;
  // enum statusEnum {  draft,  pending_approval,  pending_signatures,  active,  closed,  expired,  suspended,  revoked,  };

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'suspended_at')
  DateTime? get suspendedAt;

  @BuiltValueField(wireName: r'suspended_by')
  String? get suspendedBy;

  @BuiltValueField(wireName: r'suspension_reason')
  String? get suspensionReason;

  @BuiltValueField(wireName: r'template_id')
  String get templateId;

  @BuiltValueField(wireName: r'template_name')
  String get templateName;

  @BuiltValueField(wireName: r'template_version')
  int get templateVersion;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'valid_from')
  DateTime get validFrom;

  @BuiltValueField(wireName: r'valid_until')
  DateTime get validUntil;

  @BuiltValueField(wireName: r'worker_acknowledgements')
  BuiltList<PermitWorkerAcknowledgementResponse> get workerAcknowledgements;

  @BuiltValueField(wireName: r'worker_count')
  int get workerCount;

  @BuiltValueField(wireName: r'worker_ids')
  BuiltList<String> get workerIds;

  PermitDetail._();

  factory PermitDetail([void updates(PermitDetailBuilder b)]) = _$PermitDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitDetail> get serializer => _$PermitDetailSerializer();
}

class _$PermitDetailSerializer implements PrimitiveSerializer<PermitDetail> {
  @override
  final Iterable<Type> types = const [PermitDetail, _$PermitDetail];

  @override
  final String wireName = r'PermitDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.activatedAt != null) {
      yield r'activated_at';
      yield serializers.serialize(
        object.activatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.activatedBy != null) {
      yield r'activated_by';
      yield serializers.serialize(
        object.activatedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'approval_snapshot';
    yield serializers.serialize(
      object.approvalSnapshot,
      specifiedType:
          const FullType(BuiltList, [FullType(PermitApprovalSnapshotResponse)]),
    );
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.assetId != null) {
      yield r'asset_id';
      yield serializers.serialize(
        object.assetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'checklist_snapshot';
    yield serializers.serialize(
      object.checklistSnapshot,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitChecklistSnapshotResponse)]),
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
    if (object.closeoutNotes != null) {
      yield r'closeout_notes';
      yield serializers.serialize(
        object.closeoutNotes,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.expiredAt != null) {
      yield r'expired_at';
      yield serializers.serialize(
        object.expiredAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'highest_residual_risk';
    yield serializers.serialize(
      object.highestResidualRisk,
      specifiedType: const FullType(PermitDetailHighestResidualRiskEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.issuerSignature != null) {
      yield r'issuer_signature';
      yield serializers.serialize(
        object.issuerSignature,
        specifiedType: const FullType.nullable(PermitDigitalSignatureResponse),
      );
    }
    yield r'permit_number';
    yield serializers.serialize(
      object.permitNumber,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(PermitDetailPermitTypeEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.revocationReason != null) {
      yield r'revocation_reason';
      yield serializers.serialize(
        object.revocationReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.revokedAt != null) {
      yield r'revoked_at';
      yield serializers.serialize(
        object.revokedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.revokedBy != null) {
      yield r'revoked_by';
      yield serializers.serialize(
        object.revokedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'risk_assessment';
    yield serializers.serialize(
      object.riskAssessment,
      specifiedType:
          const FullType(BuiltList, [FullType(PermitRiskAssessmentResponse)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PermitDetailStatusEnum),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.suspendedAt != null) {
      yield r'suspended_at';
      yield serializers.serialize(
        object.suspendedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.suspendedBy != null) {
      yield r'suspended_by';
      yield serializers.serialize(
        object.suspendedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.suspensionReason != null) {
      yield r'suspension_reason';
      yield serializers.serialize(
        object.suspensionReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'template_id';
    yield serializers.serialize(
      object.templateId,
      specifiedType: const FullType(String),
    );
    yield r'template_name';
    yield serializers.serialize(
      object.templateName,
      specifiedType: const FullType(String),
    );
    yield r'template_version';
    yield serializers.serialize(
      object.templateVersion,
      specifiedType: const FullType(int),
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
    yield r'worker_acknowledgements';
    yield serializers.serialize(
      object.workerAcknowledgements,
      specifiedType: const FullType(
          BuiltList, [FullType(PermitWorkerAcknowledgementResponse)]),
    );
    yield r'worker_count';
    yield serializers.serialize(
      object.workerCount,
      specifiedType: const FullType(int),
    );
    yield r'worker_ids';
    yield serializers.serialize(
      object.workerIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitDetail object, {
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
    required PermitDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'activated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.activatedAt = valueDes;
          break;
        case r'activated_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activatedBy = valueDes;
          break;
        case r'approval_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitApprovalSnapshotResponse)]),
          ) as BuiltList<PermitApprovalSnapshotResponse>;
          result.approvalSnapshot.replace(valueDes);
          break;
        case r'area_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.areaId = valueDes;
          break;
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetId = valueDes;
          break;
        case r'checklist_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitChecklistSnapshotResponse)]),
          ) as BuiltList<PermitChecklistSnapshotResponse>;
          result.checklistSnapshot.replace(valueDes);
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
        case r'closeout_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closeoutNotes = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'expired_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiredAt = valueDes;
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
            specifiedType: const FullType(PermitDetailHighestResidualRiskEnum),
          ) as PermitDetailHighestResidualRiskEnum;
          result.highestResidualRisk = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'issuer_signature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(PermitDigitalSignatureResponse),
          ) as PermitDigitalSignatureResponse?;
          if (valueDes == null) continue;
          result.issuerSignature.replace(valueDes);
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
            specifiedType: const FullType(PermitDetailPermitTypeEnum),
          ) as PermitDetailPermitTypeEnum;
          result.permitType = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'revocation_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.revocationReason = valueDes;
          break;
        case r'revoked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.revokedAt = valueDes;
          break;
        case r'revoked_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.revokedBy = valueDes;
          break;
        case r'risk_assessment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitRiskAssessmentResponse)]),
          ) as BuiltList<PermitRiskAssessmentResponse>;
          result.riskAssessment.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PermitDetailStatusEnum),
          ) as PermitDetailStatusEnum;
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
        case r'suspended_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.suspendedAt = valueDes;
          break;
        case r'suspended_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suspendedBy = valueDes;
          break;
        case r'suspension_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suspensionReason = valueDes;
          break;
        case r'template_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateId = valueDes;
          break;
        case r'template_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateName = valueDes;
          break;
        case r'template_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.templateVersion = valueDes;
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
        case r'worker_acknowledgements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PermitWorkerAcknowledgementResponse)]),
          ) as BuiltList<PermitWorkerAcknowledgementResponse>;
          result.workerAcknowledgements.replace(valueDes);
          break;
        case r'worker_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workerCount = valueDes;
          break;
        case r'worker_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.workerIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitDetailBuilder();
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

class PermitDetailHighestResidualRiskEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const PermitDetailHighestResidualRiskEnum low =
      _$permitDetailHighestResidualRiskEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const PermitDetailHighestResidualRiskEnum medium =
      _$permitDetailHighestResidualRiskEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const PermitDetailHighestResidualRiskEnum high =
      _$permitDetailHighestResidualRiskEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const PermitDetailHighestResidualRiskEnum critical =
      _$permitDetailHighestResidualRiskEnum_critical;

  static Serializer<PermitDetailHighestResidualRiskEnum> get serializer =>
      _$permitDetailHighestResidualRiskEnumSerializer;

  const PermitDetailHighestResidualRiskEnum._(String name) : super(name);

  static BuiltSet<PermitDetailHighestResidualRiskEnum> get values =>
      _$permitDetailHighestResidualRiskEnumValues;
  static PermitDetailHighestResidualRiskEnum valueOf(String name) =>
      _$permitDetailHighestResidualRiskEnumValueOf(name);
}

class PermitDetailPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const PermitDetailPermitTypeEnum hotWork =
      _$permitDetailPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const PermitDetailPermitTypeEnum confinedSpace =
      _$permitDetailPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const PermitDetailPermitTypeEnum electricalIsolationLoto =
      _$permitDetailPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const PermitDetailPermitTypeEnum excavation =
      _$permitDetailPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const PermitDetailPermitTypeEnum workingAtHeight =
      _$permitDetailPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const PermitDetailPermitTypeEnum generalMaintenance =
      _$permitDetailPermitTypeEnum_generalMaintenance;

  static Serializer<PermitDetailPermitTypeEnum> get serializer =>
      _$permitDetailPermitTypeEnumSerializer;

  const PermitDetailPermitTypeEnum._(String name) : super(name);

  static BuiltSet<PermitDetailPermitTypeEnum> get values =>
      _$permitDetailPermitTypeEnumValues;
  static PermitDetailPermitTypeEnum valueOf(String name) =>
      _$permitDetailPermitTypeEnumValueOf(name);
}

class PermitDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const PermitDetailStatusEnum draft = _$permitDetailStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'pending_approval')
  static const PermitDetailStatusEnum pendingApproval =
      _$permitDetailStatusEnum_pendingApproval;
  @BuiltValueEnumConst(wireName: r'pending_signatures')
  static const PermitDetailStatusEnum pendingSignatures =
      _$permitDetailStatusEnum_pendingSignatures;
  @BuiltValueEnumConst(wireName: r'active')
  static const PermitDetailStatusEnum active = _$permitDetailStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'closed')
  static const PermitDetailStatusEnum closed = _$permitDetailStatusEnum_closed;
  @BuiltValueEnumConst(wireName: r'expired')
  static const PermitDetailStatusEnum expired =
      _$permitDetailStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const PermitDetailStatusEnum suspended =
      _$permitDetailStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'revoked')
  static const PermitDetailStatusEnum revoked =
      _$permitDetailStatusEnum_revoked;

  static Serializer<PermitDetailStatusEnum> get serializer =>
      _$permitDetailStatusEnumSerializer;

  const PermitDetailStatusEnum._(String name) : super(name);

  static BuiltSet<PermitDetailStatusEnum> get values =>
      _$permitDetailStatusEnumValues;
  static PermitDetailStatusEnum valueOf(String name) =>
      _$permitDetailStatusEnumValueOf(name);
}
