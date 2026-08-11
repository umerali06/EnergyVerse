// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkOrderDetailPriorityEnum _$workOrderDetailPriorityEnum_low =
    const WorkOrderDetailPriorityEnum._('low');
const WorkOrderDetailPriorityEnum _$workOrderDetailPriorityEnum_medium =
    const WorkOrderDetailPriorityEnum._('medium');
const WorkOrderDetailPriorityEnum _$workOrderDetailPriorityEnum_high =
    const WorkOrderDetailPriorityEnum._('high');
const WorkOrderDetailPriorityEnum _$workOrderDetailPriorityEnum_critical =
    const WorkOrderDetailPriorityEnum._('critical');

WorkOrderDetailPriorityEnum _$workOrderDetailPriorityEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$workOrderDetailPriorityEnum_low;
    case 'medium':
      return _$workOrderDetailPriorityEnum_medium;
    case 'high':
      return _$workOrderDetailPriorityEnum_high;
    case 'critical':
      return _$workOrderDetailPriorityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<WorkOrderDetailPriorityEnum>
    _$workOrderDetailPriorityEnumValues = new BuiltSet<
        WorkOrderDetailPriorityEnum>(const <WorkOrderDetailPriorityEnum>[
  _$workOrderDetailPriorityEnum_low,
  _$workOrderDetailPriorityEnum_medium,
  _$workOrderDetailPriorityEnum_high,
  _$workOrderDetailPriorityEnum_critical,
]);

const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_open =
    const WorkOrderDetailStatusEnum._('open');
const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_assigned =
    const WorkOrderDetailStatusEnum._('assigned');
const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_inProgress =
    const WorkOrderDetailStatusEnum._('inProgress');
const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_pendingReview =
    const WorkOrderDetailStatusEnum._('pendingReview');
const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_closed =
    const WorkOrderDetailStatusEnum._('closed');
const WorkOrderDetailStatusEnum _$workOrderDetailStatusEnum_cancelled =
    const WorkOrderDetailStatusEnum._('cancelled');

WorkOrderDetailStatusEnum _$workOrderDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$workOrderDetailStatusEnum_open;
    case 'assigned':
      return _$workOrderDetailStatusEnum_assigned;
    case 'inProgress':
      return _$workOrderDetailStatusEnum_inProgress;
    case 'pendingReview':
      return _$workOrderDetailStatusEnum_pendingReview;
    case 'closed':
      return _$workOrderDetailStatusEnum_closed;
    case 'cancelled':
      return _$workOrderDetailStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<WorkOrderDetailStatusEnum> _$workOrderDetailStatusEnumValues =
    new BuiltSet<WorkOrderDetailStatusEnum>(const <WorkOrderDetailStatusEnum>[
  _$workOrderDetailStatusEnum_open,
  _$workOrderDetailStatusEnum_assigned,
  _$workOrderDetailStatusEnum_inProgress,
  _$workOrderDetailStatusEnum_pendingReview,
  _$workOrderDetailStatusEnum_closed,
  _$workOrderDetailStatusEnum_cancelled,
]);

Serializer<WorkOrderDetailPriorityEnum>
    _$workOrderDetailPriorityEnumSerializer =
    new _$WorkOrderDetailPriorityEnumSerializer();
Serializer<WorkOrderDetailStatusEnum> _$workOrderDetailStatusEnumSerializer =
    new _$WorkOrderDetailStatusEnumSerializer();

class _$WorkOrderDetailPriorityEnumSerializer
    implements PrimitiveSerializer<WorkOrderDetailPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[WorkOrderDetailPriorityEnum];
  @override
  final String wireName = 'WorkOrderDetailPriorityEnum';

  @override
  Object serialize(Serializers serializers, WorkOrderDetailPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkOrderDetailPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkOrderDetailPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkOrderDetailStatusEnumSerializer
    implements PrimitiveSerializer<WorkOrderDetailStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'assigned': 'assigned',
    'inProgress': 'in_progress',
    'pendingReview': 'pending_review',
    'closed': 'closed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'assigned': 'assigned',
    'in_progress': 'inProgress',
    'pending_review': 'pendingReview',
    'closed': 'closed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkOrderDetailStatusEnum];
  @override
  final String wireName = 'WorkOrderDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, WorkOrderDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkOrderDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkOrderDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkOrderDetail extends WorkOrderDetail {
  @override
  final DateTime? acceptedAt;
  @override
  final String assetId;
  @override
  final DateTime? assignedAt;
  @override
  final String? assignedBy;
  @override
  final DateTime? cancelledAt;
  @override
  final DateTime? closedAt;
  @override
  final String? closedBy;
  @override
  final String? completionNotes;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final String? description;
  @override
  final DateTime? dueDate;
  @override
  final String facilityId;
  @override
  final String id;
  @override
  final num? laborHours;
  @override
  final BuiltList<String>? materialsUsed;
  @override
  final WorkOrderDetailPriorityEnum priority;
  @override
  final int revision;
  @override
  final String? sourceInspectionId;
  @override
  final WorkOrderDetailStatusEnum status;
  @override
  final DateTime? submittedAt;
  @override
  final String? technicianId;
  @override
  final String title;
  @override
  final DateTime updatedAt;

  factory _$WorkOrderDetail([void Function(WorkOrderDetailBuilder)? updates]) =>
      (new WorkOrderDetailBuilder()..update(updates))._build();

  _$WorkOrderDetail._(
      {this.acceptedAt,
      required this.assetId,
      this.assignedAt,
      this.assignedBy,
      this.cancelledAt,
      this.closedAt,
      this.closedBy,
      this.completionNotes,
      required this.createdAt,
      required this.createdBy,
      this.description,
      this.dueDate,
      required this.facilityId,
      required this.id,
      this.laborHours,
      this.materialsUsed,
      required this.priority,
      required this.revision,
      this.sourceInspectionId,
      required this.status,
      this.submittedAt,
      this.technicianId,
      required this.title,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'WorkOrderDetail', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'WorkOrderDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'WorkOrderDetail', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'WorkOrderDetail', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'WorkOrderDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        priority, r'WorkOrderDetail', 'priority');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'WorkOrderDetail', 'revision');
    BuiltValueNullFieldError.checkNotNull(status, r'WorkOrderDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(title, r'WorkOrderDetail', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'WorkOrderDetail', 'updatedAt');
  }

  @override
  WorkOrderDetail rebuild(void Function(WorkOrderDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkOrderDetailBuilder toBuilder() =>
      new WorkOrderDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkOrderDetail &&
        acceptedAt == other.acceptedAt &&
        assetId == other.assetId &&
        assignedAt == other.assignedAt &&
        assignedBy == other.assignedBy &&
        cancelledAt == other.cancelledAt &&
        closedAt == other.closedAt &&
        closedBy == other.closedBy &&
        completionNotes == other.completionNotes &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        description == other.description &&
        dueDate == other.dueDate &&
        facilityId == other.facilityId &&
        id == other.id &&
        laborHours == other.laborHours &&
        materialsUsed == other.materialsUsed &&
        priority == other.priority &&
        revision == other.revision &&
        sourceInspectionId == other.sourceInspectionId &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        technicianId == other.technicianId &&
        title == other.title &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, assignedAt.hashCode);
    _$hash = $jc(_$hash, assignedBy.hashCode);
    _$hash = $jc(_$hash, cancelledAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedBy.hashCode);
    _$hash = $jc(_$hash, completionNotes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, laborHours.hashCode);
    _$hash = $jc(_$hash, materialsUsed.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, sourceInspectionId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, technicianId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkOrderDetail')
          ..add('acceptedAt', acceptedAt)
          ..add('assetId', assetId)
          ..add('assignedAt', assignedAt)
          ..add('assignedBy', assignedBy)
          ..add('cancelledAt', cancelledAt)
          ..add('closedAt', closedAt)
          ..add('closedBy', closedBy)
          ..add('completionNotes', completionNotes)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('dueDate', dueDate)
          ..add('facilityId', facilityId)
          ..add('id', id)
          ..add('laborHours', laborHours)
          ..add('materialsUsed', materialsUsed)
          ..add('priority', priority)
          ..add('revision', revision)
          ..add('sourceInspectionId', sourceInspectionId)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('technicianId', technicianId)
          ..add('title', title)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class WorkOrderDetailBuilder
    implements Builder<WorkOrderDetail, WorkOrderDetailBuilder> {
  _$WorkOrderDetail? _$v;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  DateTime? _assignedAt;
  DateTime? get assignedAt => _$this._assignedAt;
  set assignedAt(DateTime? assignedAt) => _$this._assignedAt = assignedAt;

  String? _assignedBy;
  String? get assignedBy => _$this._assignedBy;
  set assignedBy(String? assignedBy) => _$this._assignedBy = assignedBy;

  DateTime? _cancelledAt;
  DateTime? get cancelledAt => _$this._cancelledAt;
  set cancelledAt(DateTime? cancelledAt) => _$this._cancelledAt = cancelledAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _closedBy;
  String? get closedBy => _$this._closedBy;
  set closedBy(String? closedBy) => _$this._closedBy = closedBy;

  String? _completionNotes;
  String? get completionNotes => _$this._completionNotes;
  set completionNotes(String? completionNotes) =>
      _$this._completionNotes = completionNotes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  num? _laborHours;
  num? get laborHours => _$this._laborHours;
  set laborHours(num? laborHours) => _$this._laborHours = laborHours;

  ListBuilder<String>? _materialsUsed;
  ListBuilder<String> get materialsUsed =>
      _$this._materialsUsed ??= new ListBuilder<String>();
  set materialsUsed(ListBuilder<String>? materialsUsed) =>
      _$this._materialsUsed = materialsUsed;

  WorkOrderDetailPriorityEnum? _priority;
  WorkOrderDetailPriorityEnum? get priority => _$this._priority;
  set priority(WorkOrderDetailPriorityEnum? priority) =>
      _$this._priority = priority;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  String? _sourceInspectionId;
  String? get sourceInspectionId => _$this._sourceInspectionId;
  set sourceInspectionId(String? sourceInspectionId) =>
      _$this._sourceInspectionId = sourceInspectionId;

  WorkOrderDetailStatusEnum? _status;
  WorkOrderDetailStatusEnum? get status => _$this._status;
  set status(WorkOrderDetailStatusEnum? status) => _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  String? _technicianId;
  String? get technicianId => _$this._technicianId;
  set technicianId(String? technicianId) => _$this._technicianId = technicianId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  WorkOrderDetailBuilder() {
    WorkOrderDetail._defaults(this);
  }

  WorkOrderDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptedAt = $v.acceptedAt;
      _assetId = $v.assetId;
      _assignedAt = $v.assignedAt;
      _assignedBy = $v.assignedBy;
      _cancelledAt = $v.cancelledAt;
      _closedAt = $v.closedAt;
      _closedBy = $v.closedBy;
      _completionNotes = $v.completionNotes;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _description = $v.description;
      _dueDate = $v.dueDate;
      _facilityId = $v.facilityId;
      _id = $v.id;
      _laborHours = $v.laborHours;
      _materialsUsed = $v.materialsUsed?.toBuilder();
      _priority = $v.priority;
      _revision = $v.revision;
      _sourceInspectionId = $v.sourceInspectionId;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _technicianId = $v.technicianId;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkOrderDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkOrderDetail;
  }

  @override
  void update(void Function(WorkOrderDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkOrderDetail build() => _build();

  _$WorkOrderDetail _build() {
    _$WorkOrderDetail _$result;
    try {
      _$result = _$v ??
          new _$WorkOrderDetail._(
              acceptedAt: acceptedAt,
              assetId: BuiltValueNullFieldError.checkNotNull(
                  assetId, r'WorkOrderDetail', 'assetId'),
              assignedAt: assignedAt,
              assignedBy: assignedBy,
              cancelledAt: cancelledAt,
              closedAt: closedAt,
              closedBy: closedBy,
              completionNotes: completionNotes,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'WorkOrderDetail', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'WorkOrderDetail', 'createdBy'),
              description: description,
              dueDate: dueDate,
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'WorkOrderDetail', 'facilityId'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'WorkOrderDetail', 'id'),
              laborHours: laborHours,
              materialsUsed: _materialsUsed?.build(),
              priority: BuiltValueNullFieldError.checkNotNull(
                  priority, r'WorkOrderDetail', 'priority'),
              revision: BuiltValueNullFieldError.checkNotNull(
                  revision, r'WorkOrderDetail', 'revision'),
              sourceInspectionId: sourceInspectionId,
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'WorkOrderDetail', 'status'),
              submittedAt: submittedAt,
              technicianId: technicianId,
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'WorkOrderDetail', 'title'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'WorkOrderDetail', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'materialsUsed';
        _materialsUsed?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkOrderDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
