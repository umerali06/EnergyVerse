// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermitDetailHighestResidualRiskEnum
    _$permitDetailHighestResidualRiskEnum_low =
    const PermitDetailHighestResidualRiskEnum._('low');
const PermitDetailHighestResidualRiskEnum
    _$permitDetailHighestResidualRiskEnum_medium =
    const PermitDetailHighestResidualRiskEnum._('medium');
const PermitDetailHighestResidualRiskEnum
    _$permitDetailHighestResidualRiskEnum_high =
    const PermitDetailHighestResidualRiskEnum._('high');
const PermitDetailHighestResidualRiskEnum
    _$permitDetailHighestResidualRiskEnum_critical =
    const PermitDetailHighestResidualRiskEnum._('critical');

PermitDetailHighestResidualRiskEnum
    _$permitDetailHighestResidualRiskEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$permitDetailHighestResidualRiskEnum_low;
    case 'medium':
      return _$permitDetailHighestResidualRiskEnum_medium;
    case 'high':
      return _$permitDetailHighestResidualRiskEnum_high;
    case 'critical':
      return _$permitDetailHighestResidualRiskEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitDetailHighestResidualRiskEnum>
    _$permitDetailHighestResidualRiskEnumValues = new BuiltSet<
        PermitDetailHighestResidualRiskEnum>(const <PermitDetailHighestResidualRiskEnum>[
  _$permitDetailHighestResidualRiskEnum_low,
  _$permitDetailHighestResidualRiskEnum_medium,
  _$permitDetailHighestResidualRiskEnum_high,
  _$permitDetailHighestResidualRiskEnum_critical,
]);

const PermitDetailPermitTypeEnum _$permitDetailPermitTypeEnum_hotWork =
    const PermitDetailPermitTypeEnum._('hotWork');
const PermitDetailPermitTypeEnum _$permitDetailPermitTypeEnum_confinedSpace =
    const PermitDetailPermitTypeEnum._('confinedSpace');
const PermitDetailPermitTypeEnum
    _$permitDetailPermitTypeEnum_electricalIsolationLoto =
    const PermitDetailPermitTypeEnum._('electricalIsolationLoto');
const PermitDetailPermitTypeEnum _$permitDetailPermitTypeEnum_excavation =
    const PermitDetailPermitTypeEnum._('excavation');
const PermitDetailPermitTypeEnum _$permitDetailPermitTypeEnum_workingAtHeight =
    const PermitDetailPermitTypeEnum._('workingAtHeight');
const PermitDetailPermitTypeEnum
    _$permitDetailPermitTypeEnum_generalMaintenance =
    const PermitDetailPermitTypeEnum._('generalMaintenance');

PermitDetailPermitTypeEnum _$permitDetailPermitTypeEnumValueOf(String name) {
  switch (name) {
    case 'hotWork':
      return _$permitDetailPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$permitDetailPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$permitDetailPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$permitDetailPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$permitDetailPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$permitDetailPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitDetailPermitTypeEnum> _$permitDetailPermitTypeEnumValues =
    new BuiltSet<PermitDetailPermitTypeEnum>(const <PermitDetailPermitTypeEnum>[
  _$permitDetailPermitTypeEnum_hotWork,
  _$permitDetailPermitTypeEnum_confinedSpace,
  _$permitDetailPermitTypeEnum_electricalIsolationLoto,
  _$permitDetailPermitTypeEnum_excavation,
  _$permitDetailPermitTypeEnum_workingAtHeight,
  _$permitDetailPermitTypeEnum_generalMaintenance,
]);

const PermitDetailStatusEnum _$permitDetailStatusEnum_draft =
    const PermitDetailStatusEnum._('draft');
const PermitDetailStatusEnum _$permitDetailStatusEnum_pendingApproval =
    const PermitDetailStatusEnum._('pendingApproval');
const PermitDetailStatusEnum _$permitDetailStatusEnum_pendingSignatures =
    const PermitDetailStatusEnum._('pendingSignatures');
const PermitDetailStatusEnum _$permitDetailStatusEnum_active =
    const PermitDetailStatusEnum._('active');
const PermitDetailStatusEnum _$permitDetailStatusEnum_closed =
    const PermitDetailStatusEnum._('closed');
const PermitDetailStatusEnum _$permitDetailStatusEnum_expired =
    const PermitDetailStatusEnum._('expired');
const PermitDetailStatusEnum _$permitDetailStatusEnum_suspended =
    const PermitDetailStatusEnum._('suspended');
const PermitDetailStatusEnum _$permitDetailStatusEnum_revoked =
    const PermitDetailStatusEnum._('revoked');

PermitDetailStatusEnum _$permitDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$permitDetailStatusEnum_draft;
    case 'pendingApproval':
      return _$permitDetailStatusEnum_pendingApproval;
    case 'pendingSignatures':
      return _$permitDetailStatusEnum_pendingSignatures;
    case 'active':
      return _$permitDetailStatusEnum_active;
    case 'closed':
      return _$permitDetailStatusEnum_closed;
    case 'expired':
      return _$permitDetailStatusEnum_expired;
    case 'suspended':
      return _$permitDetailStatusEnum_suspended;
    case 'revoked':
      return _$permitDetailStatusEnum_revoked;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitDetailStatusEnum> _$permitDetailStatusEnumValues =
    new BuiltSet<PermitDetailStatusEnum>(const <PermitDetailStatusEnum>[
  _$permitDetailStatusEnum_draft,
  _$permitDetailStatusEnum_pendingApproval,
  _$permitDetailStatusEnum_pendingSignatures,
  _$permitDetailStatusEnum_active,
  _$permitDetailStatusEnum_closed,
  _$permitDetailStatusEnum_expired,
  _$permitDetailStatusEnum_suspended,
  _$permitDetailStatusEnum_revoked,
]);

Serializer<PermitDetailHighestResidualRiskEnum>
    _$permitDetailHighestResidualRiskEnumSerializer =
    new _$PermitDetailHighestResidualRiskEnumSerializer();
Serializer<PermitDetailPermitTypeEnum> _$permitDetailPermitTypeEnumSerializer =
    new _$PermitDetailPermitTypeEnumSerializer();
Serializer<PermitDetailStatusEnum> _$permitDetailStatusEnumSerializer =
    new _$PermitDetailStatusEnumSerializer();

class _$PermitDetailHighestResidualRiskEnumSerializer
    implements PrimitiveSerializer<PermitDetailHighestResidualRiskEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PermitDetailHighestResidualRiskEnum
  ];
  @override
  final String wireName = 'PermitDetailHighestResidualRiskEnum';

  @override
  Object serialize(
          Serializers serializers, PermitDetailHighestResidualRiskEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitDetailHighestResidualRiskEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitDetailHighestResidualRiskEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitDetailPermitTypeEnumSerializer
    implements PrimitiveSerializer<PermitDetailPermitTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'hotWork': 'hot_work',
    'confinedSpace': 'confined_space',
    'electricalIsolationLoto': 'electrical_isolation_loto',
    'excavation': 'excavation',
    'workingAtHeight': 'working_at_height',
    'generalMaintenance': 'general_maintenance',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'hot_work': 'hotWork',
    'confined_space': 'confinedSpace',
    'electrical_isolation_loto': 'electricalIsolationLoto',
    'excavation': 'excavation',
    'working_at_height': 'workingAtHeight',
    'general_maintenance': 'generalMaintenance',
  };

  @override
  final Iterable<Type> types = const <Type>[PermitDetailPermitTypeEnum];
  @override
  final String wireName = 'PermitDetailPermitTypeEnum';

  @override
  Object serialize(Serializers serializers, PermitDetailPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitDetailPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitDetailPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitDetailStatusEnumSerializer
    implements PrimitiveSerializer<PermitDetailStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'pendingApproval': 'pending_approval',
    'pendingSignatures': 'pending_signatures',
    'active': 'active',
    'closed': 'closed',
    'expired': 'expired',
    'suspended': 'suspended',
    'revoked': 'revoked',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'pending_approval': 'pendingApproval',
    'pending_signatures': 'pendingSignatures',
    'active': 'active',
    'closed': 'closed',
    'expired': 'expired',
    'suspended': 'suspended',
    'revoked': 'revoked',
  };

  @override
  final Iterable<Type> types = const <Type>[PermitDetailStatusEnum];
  @override
  final String wireName = 'PermitDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, PermitDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitDetailStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitDetail extends PermitDetail {
  @override
  final DateTime? activatedAt;
  @override
  final String? activatedBy;
  @override
  final BuiltList<PermitApprovalSnapshotResponse> approvalSnapshot;
  @override
  final String? areaId;
  @override
  final String? assetId;
  @override
  final BuiltList<PermitChecklistSnapshotResponse> checklistSnapshot;
  @override
  final DateTime? closedAt;
  @override
  final String? closedBy;
  @override
  final String? closeoutNotes;
  @override
  final DateTime createdAt;
  @override
  final String description;
  @override
  final DateTime? expiredAt;
  @override
  final String facilityId;
  @override
  final PermitDetailHighestResidualRiskEnum highestResidualRisk;
  @override
  final String id;
  @override
  final PermitDigitalSignatureResponse? issuerSignature;
  @override
  final String permitNumber;
  @override
  final PermitDetailPermitTypeEnum permitType;
  @override
  final int revision;
  @override
  final String? revocationReason;
  @override
  final DateTime? revokedAt;
  @override
  final String? revokedBy;
  @override
  final BuiltList<PermitRiskAssessmentResponse> riskAssessment;
  @override
  final PermitDetailStatusEnum status;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? suspendedAt;
  @override
  final String? suspendedBy;
  @override
  final String? suspensionReason;
  @override
  final String templateId;
  @override
  final String templateName;
  @override
  final int templateVersion;
  @override
  final String title;
  @override
  final DateTime updatedAt;
  @override
  final DateTime validFrom;
  @override
  final DateTime validUntil;
  @override
  final BuiltList<PermitWorkerAcknowledgementResponse> workerAcknowledgements;
  @override
  final int workerCount;
  @override
  final BuiltList<String> workerIds;

  factory _$PermitDetail([void Function(PermitDetailBuilder)? updates]) =>
      (new PermitDetailBuilder()..update(updates))._build();

  _$PermitDetail._(
      {this.activatedAt,
      this.activatedBy,
      required this.approvalSnapshot,
      this.areaId,
      this.assetId,
      required this.checklistSnapshot,
      this.closedAt,
      this.closedBy,
      this.closeoutNotes,
      required this.createdAt,
      required this.description,
      this.expiredAt,
      required this.facilityId,
      required this.highestResidualRisk,
      required this.id,
      this.issuerSignature,
      required this.permitNumber,
      required this.permitType,
      required this.revision,
      this.revocationReason,
      this.revokedAt,
      this.revokedBy,
      required this.riskAssessment,
      required this.status,
      this.submittedAt,
      this.suspendedAt,
      this.suspendedBy,
      this.suspensionReason,
      required this.templateId,
      required this.templateName,
      required this.templateVersion,
      required this.title,
      required this.updatedAt,
      required this.validFrom,
      required this.validUntil,
      required this.workerAcknowledgements,
      required this.workerCount,
      required this.workerIds})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        approvalSnapshot, r'PermitDetail', 'approvalSnapshot');
    BuiltValueNullFieldError.checkNotNull(
        checklistSnapshot, r'PermitDetail', 'checklistSnapshot');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PermitDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        description, r'PermitDetail', 'description');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'PermitDetail', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(
        highestResidualRisk, r'PermitDetail', 'highestResidualRisk');
    BuiltValueNullFieldError.checkNotNull(id, r'PermitDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        permitNumber, r'PermitDetail', 'permitNumber');
    BuiltValueNullFieldError.checkNotNull(
        permitType, r'PermitDetail', 'permitType');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'PermitDetail', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        riskAssessment, r'PermitDetail', 'riskAssessment');
    BuiltValueNullFieldError.checkNotNull(status, r'PermitDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        templateId, r'PermitDetail', 'templateId');
    BuiltValueNullFieldError.checkNotNull(
        templateName, r'PermitDetail', 'templateName');
    BuiltValueNullFieldError.checkNotNull(
        templateVersion, r'PermitDetail', 'templateVersion');
    BuiltValueNullFieldError.checkNotNull(title, r'PermitDetail', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'PermitDetail', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        validFrom, r'PermitDetail', 'validFrom');
    BuiltValueNullFieldError.checkNotNull(
        validUntil, r'PermitDetail', 'validUntil');
    BuiltValueNullFieldError.checkNotNull(
        workerAcknowledgements, r'PermitDetail', 'workerAcknowledgements');
    BuiltValueNullFieldError.checkNotNull(
        workerCount, r'PermitDetail', 'workerCount');
    BuiltValueNullFieldError.checkNotNull(
        workerIds, r'PermitDetail', 'workerIds');
  }

  @override
  PermitDetail rebuild(void Function(PermitDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitDetailBuilder toBuilder() => new PermitDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitDetail &&
        activatedAt == other.activatedAt &&
        activatedBy == other.activatedBy &&
        approvalSnapshot == other.approvalSnapshot &&
        areaId == other.areaId &&
        assetId == other.assetId &&
        checklistSnapshot == other.checklistSnapshot &&
        closedAt == other.closedAt &&
        closedBy == other.closedBy &&
        closeoutNotes == other.closeoutNotes &&
        createdAt == other.createdAt &&
        description == other.description &&
        expiredAt == other.expiredAt &&
        facilityId == other.facilityId &&
        highestResidualRisk == other.highestResidualRisk &&
        id == other.id &&
        issuerSignature == other.issuerSignature &&
        permitNumber == other.permitNumber &&
        permitType == other.permitType &&
        revision == other.revision &&
        revocationReason == other.revocationReason &&
        revokedAt == other.revokedAt &&
        revokedBy == other.revokedBy &&
        riskAssessment == other.riskAssessment &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        suspendedAt == other.suspendedAt &&
        suspendedBy == other.suspendedBy &&
        suspensionReason == other.suspensionReason &&
        templateId == other.templateId &&
        templateName == other.templateName &&
        templateVersion == other.templateVersion &&
        title == other.title &&
        updatedAt == other.updatedAt &&
        validFrom == other.validFrom &&
        validUntil == other.validUntil &&
        workerAcknowledgements == other.workerAcknowledgements &&
        workerCount == other.workerCount &&
        workerIds == other.workerIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activatedAt.hashCode);
    _$hash = $jc(_$hash, activatedBy.hashCode);
    _$hash = $jc(_$hash, approvalSnapshot.hashCode);
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, checklistSnapshot.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedBy.hashCode);
    _$hash = $jc(_$hash, closeoutNotes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, expiredAt.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, highestResidualRisk.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, issuerSignature.hashCode);
    _$hash = $jc(_$hash, permitNumber.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, revocationReason.hashCode);
    _$hash = $jc(_$hash, revokedAt.hashCode);
    _$hash = $jc(_$hash, revokedBy.hashCode);
    _$hash = $jc(_$hash, riskAssessment.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, suspendedAt.hashCode);
    _$hash = $jc(_$hash, suspendedBy.hashCode);
    _$hash = $jc(_$hash, suspensionReason.hashCode);
    _$hash = $jc(_$hash, templateId.hashCode);
    _$hash = $jc(_$hash, templateName.hashCode);
    _$hash = $jc(_$hash, templateVersion.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validUntil.hashCode);
    _$hash = $jc(_$hash, workerAcknowledgements.hashCode);
    _$hash = $jc(_$hash, workerCount.hashCode);
    _$hash = $jc(_$hash, workerIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitDetail')
          ..add('activatedAt', activatedAt)
          ..add('activatedBy', activatedBy)
          ..add('approvalSnapshot', approvalSnapshot)
          ..add('areaId', areaId)
          ..add('assetId', assetId)
          ..add('checklistSnapshot', checklistSnapshot)
          ..add('closedAt', closedAt)
          ..add('closedBy', closedBy)
          ..add('closeoutNotes', closeoutNotes)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('expiredAt', expiredAt)
          ..add('facilityId', facilityId)
          ..add('highestResidualRisk', highestResidualRisk)
          ..add('id', id)
          ..add('issuerSignature', issuerSignature)
          ..add('permitNumber', permitNumber)
          ..add('permitType', permitType)
          ..add('revision', revision)
          ..add('revocationReason', revocationReason)
          ..add('revokedAt', revokedAt)
          ..add('revokedBy', revokedBy)
          ..add('riskAssessment', riskAssessment)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('suspendedAt', suspendedAt)
          ..add('suspendedBy', suspendedBy)
          ..add('suspensionReason', suspensionReason)
          ..add('templateId', templateId)
          ..add('templateName', templateName)
          ..add('templateVersion', templateVersion)
          ..add('title', title)
          ..add('updatedAt', updatedAt)
          ..add('validFrom', validFrom)
          ..add('validUntil', validUntil)
          ..add('workerAcknowledgements', workerAcknowledgements)
          ..add('workerCount', workerCount)
          ..add('workerIds', workerIds))
        .toString();
  }
}

class PermitDetailBuilder
    implements Builder<PermitDetail, PermitDetailBuilder> {
  _$PermitDetail? _$v;

  DateTime? _activatedAt;
  DateTime? get activatedAt => _$this._activatedAt;
  set activatedAt(DateTime? activatedAt) => _$this._activatedAt = activatedAt;

  String? _activatedBy;
  String? get activatedBy => _$this._activatedBy;
  set activatedBy(String? activatedBy) => _$this._activatedBy = activatedBy;

  ListBuilder<PermitApprovalSnapshotResponse>? _approvalSnapshot;
  ListBuilder<PermitApprovalSnapshotResponse> get approvalSnapshot =>
      _$this._approvalSnapshot ??=
          new ListBuilder<PermitApprovalSnapshotResponse>();
  set approvalSnapshot(
          ListBuilder<PermitApprovalSnapshotResponse>? approvalSnapshot) =>
      _$this._approvalSnapshot = approvalSnapshot;

  String? _areaId;
  String? get areaId => _$this._areaId;
  set areaId(String? areaId) => _$this._areaId = areaId;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  ListBuilder<PermitChecklistSnapshotResponse>? _checklistSnapshot;
  ListBuilder<PermitChecklistSnapshotResponse> get checklistSnapshot =>
      _$this._checklistSnapshot ??=
          new ListBuilder<PermitChecklistSnapshotResponse>();
  set checklistSnapshot(
          ListBuilder<PermitChecklistSnapshotResponse>? checklistSnapshot) =>
      _$this._checklistSnapshot = checklistSnapshot;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _closedBy;
  String? get closedBy => _$this._closedBy;
  set closedBy(String? closedBy) => _$this._closedBy = closedBy;

  String? _closeoutNotes;
  String? get closeoutNotes => _$this._closeoutNotes;
  set closeoutNotes(String? closeoutNotes) =>
      _$this._closeoutNotes = closeoutNotes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _expiredAt;
  DateTime? get expiredAt => _$this._expiredAt;
  set expiredAt(DateTime? expiredAt) => _$this._expiredAt = expiredAt;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  PermitDetailHighestResidualRiskEnum? _highestResidualRisk;
  PermitDetailHighestResidualRiskEnum? get highestResidualRisk =>
      _$this._highestResidualRisk;
  set highestResidualRisk(
          PermitDetailHighestResidualRiskEnum? highestResidualRisk) =>
      _$this._highestResidualRisk = highestResidualRisk;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PermitDigitalSignatureResponseBuilder? _issuerSignature;
  PermitDigitalSignatureResponseBuilder get issuerSignature =>
      _$this._issuerSignature ??= new PermitDigitalSignatureResponseBuilder();
  set issuerSignature(PermitDigitalSignatureResponseBuilder? issuerSignature) =>
      _$this._issuerSignature = issuerSignature;

  String? _permitNumber;
  String? get permitNumber => _$this._permitNumber;
  set permitNumber(String? permitNumber) => _$this._permitNumber = permitNumber;

  PermitDetailPermitTypeEnum? _permitType;
  PermitDetailPermitTypeEnum? get permitType => _$this._permitType;
  set permitType(PermitDetailPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  String? _revocationReason;
  String? get revocationReason => _$this._revocationReason;
  set revocationReason(String? revocationReason) =>
      _$this._revocationReason = revocationReason;

  DateTime? _revokedAt;
  DateTime? get revokedAt => _$this._revokedAt;
  set revokedAt(DateTime? revokedAt) => _$this._revokedAt = revokedAt;

  String? _revokedBy;
  String? get revokedBy => _$this._revokedBy;
  set revokedBy(String? revokedBy) => _$this._revokedBy = revokedBy;

  ListBuilder<PermitRiskAssessmentResponse>? _riskAssessment;
  ListBuilder<PermitRiskAssessmentResponse> get riskAssessment =>
      _$this._riskAssessment ??=
          new ListBuilder<PermitRiskAssessmentResponse>();
  set riskAssessment(
          ListBuilder<PermitRiskAssessmentResponse>? riskAssessment) =>
      _$this._riskAssessment = riskAssessment;

  PermitDetailStatusEnum? _status;
  PermitDetailStatusEnum? get status => _$this._status;
  set status(PermitDetailStatusEnum? status) => _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _suspendedAt;
  DateTime? get suspendedAt => _$this._suspendedAt;
  set suspendedAt(DateTime? suspendedAt) => _$this._suspendedAt = suspendedAt;

  String? _suspendedBy;
  String? get suspendedBy => _$this._suspendedBy;
  set suspendedBy(String? suspendedBy) => _$this._suspendedBy = suspendedBy;

  String? _suspensionReason;
  String? get suspensionReason => _$this._suspensionReason;
  set suspensionReason(String? suspensionReason) =>
      _$this._suspensionReason = suspensionReason;

  String? _templateId;
  String? get templateId => _$this._templateId;
  set templateId(String? templateId) => _$this._templateId = templateId;

  String? _templateName;
  String? get templateName => _$this._templateName;
  set templateName(String? templateName) => _$this._templateName = templateName;

  int? _templateVersion;
  int? get templateVersion => _$this._templateVersion;
  set templateVersion(int? templateVersion) =>
      _$this._templateVersion = templateVersion;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DateTime? _validFrom;
  DateTime? get validFrom => _$this._validFrom;
  set validFrom(DateTime? validFrom) => _$this._validFrom = validFrom;

  DateTime? _validUntil;
  DateTime? get validUntil => _$this._validUntil;
  set validUntil(DateTime? validUntil) => _$this._validUntil = validUntil;

  ListBuilder<PermitWorkerAcknowledgementResponse>? _workerAcknowledgements;
  ListBuilder<PermitWorkerAcknowledgementResponse> get workerAcknowledgements =>
      _$this._workerAcknowledgements ??=
          new ListBuilder<PermitWorkerAcknowledgementResponse>();
  set workerAcknowledgements(
          ListBuilder<PermitWorkerAcknowledgementResponse>?
              workerAcknowledgements) =>
      _$this._workerAcknowledgements = workerAcknowledgements;

  int? _workerCount;
  int? get workerCount => _$this._workerCount;
  set workerCount(int? workerCount) => _$this._workerCount = workerCount;

  ListBuilder<String>? _workerIds;
  ListBuilder<String> get workerIds =>
      _$this._workerIds ??= new ListBuilder<String>();
  set workerIds(ListBuilder<String>? workerIds) =>
      _$this._workerIds = workerIds;

  PermitDetailBuilder() {
    PermitDetail._defaults(this);
  }

  PermitDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activatedAt = $v.activatedAt;
      _activatedBy = $v.activatedBy;
      _approvalSnapshot = $v.approvalSnapshot.toBuilder();
      _areaId = $v.areaId;
      _assetId = $v.assetId;
      _checklistSnapshot = $v.checklistSnapshot.toBuilder();
      _closedAt = $v.closedAt;
      _closedBy = $v.closedBy;
      _closeoutNotes = $v.closeoutNotes;
      _createdAt = $v.createdAt;
      _description = $v.description;
      _expiredAt = $v.expiredAt;
      _facilityId = $v.facilityId;
      _highestResidualRisk = $v.highestResidualRisk;
      _id = $v.id;
      _issuerSignature = $v.issuerSignature?.toBuilder();
      _permitNumber = $v.permitNumber;
      _permitType = $v.permitType;
      _revision = $v.revision;
      _revocationReason = $v.revocationReason;
      _revokedAt = $v.revokedAt;
      _revokedBy = $v.revokedBy;
      _riskAssessment = $v.riskAssessment.toBuilder();
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _suspendedAt = $v.suspendedAt;
      _suspendedBy = $v.suspendedBy;
      _suspensionReason = $v.suspensionReason;
      _templateId = $v.templateId;
      _templateName = $v.templateName;
      _templateVersion = $v.templateVersion;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _validFrom = $v.validFrom;
      _validUntil = $v.validUntil;
      _workerAcknowledgements = $v.workerAcknowledgements.toBuilder();
      _workerCount = $v.workerCount;
      _workerIds = $v.workerIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitDetail;
  }

  @override
  void update(void Function(PermitDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitDetail build() => _build();

  _$PermitDetail _build() {
    _$PermitDetail _$result;
    try {
      _$result = _$v ??
          new _$PermitDetail._(
              activatedAt: activatedAt,
              activatedBy: activatedBy,
              approvalSnapshot: approvalSnapshot.build(),
              areaId: areaId,
              assetId: assetId,
              checklistSnapshot: checklistSnapshot.build(),
              closedAt: closedAt,
              closedBy: closedBy,
              closeoutNotes: closeoutNotes,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'PermitDetail', 'createdAt'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'PermitDetail', 'description'),
              expiredAt: expiredAt,
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'PermitDetail', 'facilityId'),
              highestResidualRisk: BuiltValueNullFieldError.checkNotNull(
                  highestResidualRisk, r'PermitDetail', 'highestResidualRisk'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'PermitDetail', 'id'),
              issuerSignature: _issuerSignature?.build(),
              permitNumber: BuiltValueNullFieldError.checkNotNull(
                  permitNumber, r'PermitDetail', 'permitNumber'),
              permitType: BuiltValueNullFieldError.checkNotNull(
                  permitType, r'PermitDetail', 'permitType'),
              revision: BuiltValueNullFieldError.checkNotNull(
                  revision, r'PermitDetail', 'revision'),
              revocationReason: revocationReason,
              revokedAt: revokedAt,
              revokedBy: revokedBy,
              riskAssessment: riskAssessment.build(),
              status: BuiltValueNullFieldError.checkNotNull(status, r'PermitDetail', 'status'),
              submittedAt: submittedAt,
              suspendedAt: suspendedAt,
              suspendedBy: suspendedBy,
              suspensionReason: suspensionReason,
              templateId: BuiltValueNullFieldError.checkNotNull(templateId, r'PermitDetail', 'templateId'),
              templateName: BuiltValueNullFieldError.checkNotNull(templateName, r'PermitDetail', 'templateName'),
              templateVersion: BuiltValueNullFieldError.checkNotNull(templateVersion, r'PermitDetail', 'templateVersion'),
              title: BuiltValueNullFieldError.checkNotNull(title, r'PermitDetail', 'title'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'PermitDetail', 'updatedAt'),
              validFrom: BuiltValueNullFieldError.checkNotNull(validFrom, r'PermitDetail', 'validFrom'),
              validUntil: BuiltValueNullFieldError.checkNotNull(validUntil, r'PermitDetail', 'validUntil'),
              workerAcknowledgements: workerAcknowledgements.build(),
              workerCount: BuiltValueNullFieldError.checkNotNull(workerCount, r'PermitDetail', 'workerCount'),
              workerIds: workerIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvalSnapshot';
        approvalSnapshot.build();

        _$failedField = 'checklistSnapshot';
        checklistSnapshot.build();

        _$failedField = 'issuerSignature';
        _issuerSignature?.build();

        _$failedField = 'riskAssessment';
        riskAssessment.build();

        _$failedField = 'workerAcknowledgements';
        workerAcknowledgements.build();

        _$failedField = 'workerIds';
        workerIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermitDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
