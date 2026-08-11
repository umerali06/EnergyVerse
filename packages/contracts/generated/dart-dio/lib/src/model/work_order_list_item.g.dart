// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkOrderListItemPriorityEnum _$workOrderListItemPriorityEnum_low =
    const WorkOrderListItemPriorityEnum._('low');
const WorkOrderListItemPriorityEnum _$workOrderListItemPriorityEnum_medium =
    const WorkOrderListItemPriorityEnum._('medium');
const WorkOrderListItemPriorityEnum _$workOrderListItemPriorityEnum_high =
    const WorkOrderListItemPriorityEnum._('high');
const WorkOrderListItemPriorityEnum _$workOrderListItemPriorityEnum_critical =
    const WorkOrderListItemPriorityEnum._('critical');

WorkOrderListItemPriorityEnum _$workOrderListItemPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'low':
      return _$workOrderListItemPriorityEnum_low;
    case 'medium':
      return _$workOrderListItemPriorityEnum_medium;
    case 'high':
      return _$workOrderListItemPriorityEnum_high;
    case 'critical':
      return _$workOrderListItemPriorityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<WorkOrderListItemPriorityEnum>
    _$workOrderListItemPriorityEnumValues = new BuiltSet<
        WorkOrderListItemPriorityEnum>(const <WorkOrderListItemPriorityEnum>[
  _$workOrderListItemPriorityEnum_low,
  _$workOrderListItemPriorityEnum_medium,
  _$workOrderListItemPriorityEnum_high,
  _$workOrderListItemPriorityEnum_critical,
]);

const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_open =
    const WorkOrderListItemStatusEnum._('open');
const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_assigned =
    const WorkOrderListItemStatusEnum._('assigned');
const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_inProgress =
    const WorkOrderListItemStatusEnum._('inProgress');
const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_pendingReview =
    const WorkOrderListItemStatusEnum._('pendingReview');
const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_closed =
    const WorkOrderListItemStatusEnum._('closed');
const WorkOrderListItemStatusEnum _$workOrderListItemStatusEnum_cancelled =
    const WorkOrderListItemStatusEnum._('cancelled');

WorkOrderListItemStatusEnum _$workOrderListItemStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$workOrderListItemStatusEnum_open;
    case 'assigned':
      return _$workOrderListItemStatusEnum_assigned;
    case 'inProgress':
      return _$workOrderListItemStatusEnum_inProgress;
    case 'pendingReview':
      return _$workOrderListItemStatusEnum_pendingReview;
    case 'closed':
      return _$workOrderListItemStatusEnum_closed;
    case 'cancelled':
      return _$workOrderListItemStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<WorkOrderListItemStatusEnum>
    _$workOrderListItemStatusEnumValues = new BuiltSet<
        WorkOrderListItemStatusEnum>(const <WorkOrderListItemStatusEnum>[
  _$workOrderListItemStatusEnum_open,
  _$workOrderListItemStatusEnum_assigned,
  _$workOrderListItemStatusEnum_inProgress,
  _$workOrderListItemStatusEnum_pendingReview,
  _$workOrderListItemStatusEnum_closed,
  _$workOrderListItemStatusEnum_cancelled,
]);

Serializer<WorkOrderListItemPriorityEnum>
    _$workOrderListItemPriorityEnumSerializer =
    new _$WorkOrderListItemPriorityEnumSerializer();
Serializer<WorkOrderListItemStatusEnum>
    _$workOrderListItemStatusEnumSerializer =
    new _$WorkOrderListItemStatusEnumSerializer();

class _$WorkOrderListItemPriorityEnumSerializer
    implements PrimitiveSerializer<WorkOrderListItemPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[WorkOrderListItemPriorityEnum];
  @override
  final String wireName = 'WorkOrderListItemPriorityEnum';

  @override
  Object serialize(
          Serializers serializers, WorkOrderListItemPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkOrderListItemPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkOrderListItemPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkOrderListItemStatusEnumSerializer
    implements PrimitiveSerializer<WorkOrderListItemStatusEnum> {
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
  final Iterable<Type> types = const <Type>[WorkOrderListItemStatusEnum];
  @override
  final String wireName = 'WorkOrderListItemStatusEnum';

  @override
  Object serialize(Serializers serializers, WorkOrderListItemStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkOrderListItemStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkOrderListItemStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkOrderListItem extends WorkOrderListItem {
  @override
  final String assetId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? dueDate;
  @override
  final String facilityId;
  @override
  final String id;
  @override
  final WorkOrderListItemPriorityEnum priority;
  @override
  final int revision;
  @override
  final WorkOrderListItemStatusEnum status;
  @override
  final String? technicianId;
  @override
  final String title;
  @override
  final DateTime updatedAt;

  factory _$WorkOrderListItem(
          [void Function(WorkOrderListItemBuilder)? updates]) =>
      (new WorkOrderListItemBuilder()..update(updates))._build();

  _$WorkOrderListItem._(
      {required this.assetId,
      required this.createdAt,
      this.dueDate,
      required this.facilityId,
      required this.id,
      required this.priority,
      required this.revision,
      required this.status,
      this.technicianId,
      required this.title,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'WorkOrderListItem', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'WorkOrderListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'WorkOrderListItem', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'WorkOrderListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        priority, r'WorkOrderListItem', 'priority');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'WorkOrderListItem', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        status, r'WorkOrderListItem', 'status');
    BuiltValueNullFieldError.checkNotNull(title, r'WorkOrderListItem', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'WorkOrderListItem', 'updatedAt');
  }

  @override
  WorkOrderListItem rebuild(void Function(WorkOrderListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkOrderListItemBuilder toBuilder() =>
      new WorkOrderListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkOrderListItem &&
        assetId == other.assetId &&
        createdAt == other.createdAt &&
        dueDate == other.dueDate &&
        facilityId == other.facilityId &&
        id == other.id &&
        priority == other.priority &&
        revision == other.revision &&
        status == other.status &&
        technicianId == other.technicianId &&
        title == other.title &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, technicianId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkOrderListItem')
          ..add('assetId', assetId)
          ..add('createdAt', createdAt)
          ..add('dueDate', dueDate)
          ..add('facilityId', facilityId)
          ..add('id', id)
          ..add('priority', priority)
          ..add('revision', revision)
          ..add('status', status)
          ..add('technicianId', technicianId)
          ..add('title', title)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class WorkOrderListItemBuilder
    implements Builder<WorkOrderListItem, WorkOrderListItemBuilder> {
  _$WorkOrderListItem? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  WorkOrderListItemPriorityEnum? _priority;
  WorkOrderListItemPriorityEnum? get priority => _$this._priority;
  set priority(WorkOrderListItemPriorityEnum? priority) =>
      _$this._priority = priority;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  WorkOrderListItemStatusEnum? _status;
  WorkOrderListItemStatusEnum? get status => _$this._status;
  set status(WorkOrderListItemStatusEnum? status) => _$this._status = status;

  String? _technicianId;
  String? get technicianId => _$this._technicianId;
  set technicianId(String? technicianId) => _$this._technicianId = technicianId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  WorkOrderListItemBuilder() {
    WorkOrderListItem._defaults(this);
  }

  WorkOrderListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _createdAt = $v.createdAt;
      _dueDate = $v.dueDate;
      _facilityId = $v.facilityId;
      _id = $v.id;
      _priority = $v.priority;
      _revision = $v.revision;
      _status = $v.status;
      _technicianId = $v.technicianId;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkOrderListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkOrderListItem;
  }

  @override
  void update(void Function(WorkOrderListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkOrderListItem build() => _build();

  _$WorkOrderListItem _build() {
    final _$result = _$v ??
        new _$WorkOrderListItem._(
            assetId: BuiltValueNullFieldError.checkNotNull(
                assetId, r'WorkOrderListItem', 'assetId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'WorkOrderListItem', 'createdAt'),
            dueDate: dueDate,
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'WorkOrderListItem', 'facilityId'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkOrderListItem', 'id'),
            priority: BuiltValueNullFieldError.checkNotNull(
                priority, r'WorkOrderListItem', 'priority'),
            revision: BuiltValueNullFieldError.checkNotNull(
                revision, r'WorkOrderListItem', 'revision'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WorkOrderListItem', 'status'),
            technicianId: technicianId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'WorkOrderListItem', 'title'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'WorkOrderListItem', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
