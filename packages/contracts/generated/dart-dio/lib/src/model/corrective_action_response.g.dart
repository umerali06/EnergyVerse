// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corrective_action_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CorrectiveActionResponsePriorityEnum
    _$correctiveActionResponsePriorityEnum_low =
    const CorrectiveActionResponsePriorityEnum._('low');
const CorrectiveActionResponsePriorityEnum
    _$correctiveActionResponsePriorityEnum_medium =
    const CorrectiveActionResponsePriorityEnum._('medium');
const CorrectiveActionResponsePriorityEnum
    _$correctiveActionResponsePriorityEnum_high =
    const CorrectiveActionResponsePriorityEnum._('high');
const CorrectiveActionResponsePriorityEnum
    _$correctiveActionResponsePriorityEnum_critical =
    const CorrectiveActionResponsePriorityEnum._('critical');

CorrectiveActionResponsePriorityEnum
    _$correctiveActionResponsePriorityEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$correctiveActionResponsePriorityEnum_low;
    case 'medium':
      return _$correctiveActionResponsePriorityEnum_medium;
    case 'high':
      return _$correctiveActionResponsePriorityEnum_high;
    case 'critical':
      return _$correctiveActionResponsePriorityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CorrectiveActionResponsePriorityEnum>
    _$correctiveActionResponsePriorityEnumValues = new BuiltSet<
        CorrectiveActionResponsePriorityEnum>(const <CorrectiveActionResponsePriorityEnum>[
  _$correctiveActionResponsePriorityEnum_low,
  _$correctiveActionResponsePriorityEnum_medium,
  _$correctiveActionResponsePriorityEnum_high,
  _$correctiveActionResponsePriorityEnum_critical,
]);

const CorrectiveActionResponseStatusEnum
    _$correctiveActionResponseStatusEnum_open =
    const CorrectiveActionResponseStatusEnum._('open');
const CorrectiveActionResponseStatusEnum
    _$correctiveActionResponseStatusEnum_inProgress =
    const CorrectiveActionResponseStatusEnum._('inProgress');
const CorrectiveActionResponseStatusEnum
    _$correctiveActionResponseStatusEnum_completed =
    const CorrectiveActionResponseStatusEnum._('completed');
const CorrectiveActionResponseStatusEnum
    _$correctiveActionResponseStatusEnum_cancelled =
    const CorrectiveActionResponseStatusEnum._('cancelled');

CorrectiveActionResponseStatusEnum _$correctiveActionResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'open':
      return _$correctiveActionResponseStatusEnum_open;
    case 'inProgress':
      return _$correctiveActionResponseStatusEnum_inProgress;
    case 'completed':
      return _$correctiveActionResponseStatusEnum_completed;
    case 'cancelled':
      return _$correctiveActionResponseStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CorrectiveActionResponseStatusEnum>
    _$correctiveActionResponseStatusEnumValues = new BuiltSet<
        CorrectiveActionResponseStatusEnum>(const <CorrectiveActionResponseStatusEnum>[
  _$correctiveActionResponseStatusEnum_open,
  _$correctiveActionResponseStatusEnum_inProgress,
  _$correctiveActionResponseStatusEnum_completed,
  _$correctiveActionResponseStatusEnum_cancelled,
]);

Serializer<CorrectiveActionResponsePriorityEnum>
    _$correctiveActionResponsePriorityEnumSerializer =
    new _$CorrectiveActionResponsePriorityEnumSerializer();
Serializer<CorrectiveActionResponseStatusEnum>
    _$correctiveActionResponseStatusEnumSerializer =
    new _$CorrectiveActionResponseStatusEnumSerializer();

class _$CorrectiveActionResponsePriorityEnumSerializer
    implements PrimitiveSerializer<CorrectiveActionResponsePriorityEnum> {
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
    CorrectiveActionResponsePriorityEnum
  ];
  @override
  final String wireName = 'CorrectiveActionResponsePriorityEnum';

  @override
  Object serialize(
          Serializers serializers, CorrectiveActionResponsePriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CorrectiveActionResponsePriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CorrectiveActionResponsePriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CorrectiveActionResponseStatusEnumSerializer
    implements PrimitiveSerializer<CorrectiveActionResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'inProgress': 'in_progress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'in_progress': 'inProgress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[CorrectiveActionResponseStatusEnum];
  @override
  final String wireName = 'CorrectiveActionResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CorrectiveActionResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CorrectiveActionResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CorrectiveActionResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CorrectiveActionResponse extends CorrectiveActionResponse {
  @override
  final String assigneeId;
  @override
  final String? cancellationReason;
  @override
  final DateTime? cancelledAt;
  @override
  final String? cancelledBy;
  @override
  final DateTime? completedAt;
  @override
  final String? completedBy;
  @override
  final String? completionNotes;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final String description;
  @override
  final DateTime dueDate;
  @override
  final String id;
  @override
  final CorrectiveActionResponsePriorityEnum priority;
  @override
  final DateTime? startedAt;
  @override
  final CorrectiveActionResponseStatusEnum status;
  @override
  final DateTime updatedAt;

  factory _$CorrectiveActionResponse(
          [void Function(CorrectiveActionResponseBuilder)? updates]) =>
      (new CorrectiveActionResponseBuilder()..update(updates))._build();

  _$CorrectiveActionResponse._(
      {required this.assigneeId,
      this.cancellationReason,
      this.cancelledAt,
      this.cancelledBy,
      this.completedAt,
      this.completedBy,
      this.completionNotes,
      required this.createdAt,
      required this.createdBy,
      required this.description,
      required this.dueDate,
      required this.id,
      required this.priority,
      this.startedAt,
      required this.status,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assigneeId, r'CorrectiveActionResponse', 'assigneeId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'CorrectiveActionResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'CorrectiveActionResponse', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(
        description, r'CorrectiveActionResponse', 'description');
    BuiltValueNullFieldError.checkNotNull(
        dueDate, r'CorrectiveActionResponse', 'dueDate');
    BuiltValueNullFieldError.checkNotNull(
        id, r'CorrectiveActionResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        priority, r'CorrectiveActionResponse', 'priority');
    BuiltValueNullFieldError.checkNotNull(
        status, r'CorrectiveActionResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'CorrectiveActionResponse', 'updatedAt');
  }

  @override
  CorrectiveActionResponse rebuild(
          void Function(CorrectiveActionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CorrectiveActionResponseBuilder toBuilder() =>
      new CorrectiveActionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CorrectiveActionResponse &&
        assigneeId == other.assigneeId &&
        cancellationReason == other.cancellationReason &&
        cancelledAt == other.cancelledAt &&
        cancelledBy == other.cancelledBy &&
        completedAt == other.completedAt &&
        completedBy == other.completedBy &&
        completionNotes == other.completionNotes &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        description == other.description &&
        dueDate == other.dueDate &&
        id == other.id &&
        priority == other.priority &&
        startedAt == other.startedAt &&
        status == other.status &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assigneeId.hashCode);
    _$hash = $jc(_$hash, cancellationReason.hashCode);
    _$hash = $jc(_$hash, cancelledAt.hashCode);
    _$hash = $jc(_$hash, cancelledBy.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, completedBy.hashCode);
    _$hash = $jc(_$hash, completionNotes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CorrectiveActionResponse')
          ..add('assigneeId', assigneeId)
          ..add('cancellationReason', cancellationReason)
          ..add('cancelledAt', cancelledAt)
          ..add('cancelledBy', cancelledBy)
          ..add('completedAt', completedAt)
          ..add('completedBy', completedBy)
          ..add('completionNotes', completionNotes)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('dueDate', dueDate)
          ..add('id', id)
          ..add('priority', priority)
          ..add('startedAt', startedAt)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class CorrectiveActionResponseBuilder
    implements
        Builder<CorrectiveActionResponse, CorrectiveActionResponseBuilder> {
  _$CorrectiveActionResponse? _$v;

  String? _assigneeId;
  String? get assigneeId => _$this._assigneeId;
  set assigneeId(String? assigneeId) => _$this._assigneeId = assigneeId;

  String? _cancellationReason;
  String? get cancellationReason => _$this._cancellationReason;
  set cancellationReason(String? cancellationReason) =>
      _$this._cancellationReason = cancellationReason;

  DateTime? _cancelledAt;
  DateTime? get cancelledAt => _$this._cancelledAt;
  set cancelledAt(DateTime? cancelledAt) => _$this._cancelledAt = cancelledAt;

  String? _cancelledBy;
  String? get cancelledBy => _$this._cancelledBy;
  set cancelledBy(String? cancelledBy) => _$this._cancelledBy = cancelledBy;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  String? _completedBy;
  String? get completedBy => _$this._completedBy;
  set completedBy(String? completedBy) => _$this._completedBy = completedBy;

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

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CorrectiveActionResponsePriorityEnum? _priority;
  CorrectiveActionResponsePriorityEnum? get priority => _$this._priority;
  set priority(CorrectiveActionResponsePriorityEnum? priority) =>
      _$this._priority = priority;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  CorrectiveActionResponseStatusEnum? _status;
  CorrectiveActionResponseStatusEnum? get status => _$this._status;
  set status(CorrectiveActionResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  CorrectiveActionResponseBuilder() {
    CorrectiveActionResponse._defaults(this);
  }

  CorrectiveActionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assigneeId = $v.assigneeId;
      _cancellationReason = $v.cancellationReason;
      _cancelledAt = $v.cancelledAt;
      _cancelledBy = $v.cancelledBy;
      _completedAt = $v.completedAt;
      _completedBy = $v.completedBy;
      _completionNotes = $v.completionNotes;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _description = $v.description;
      _dueDate = $v.dueDate;
      _id = $v.id;
      _priority = $v.priority;
      _startedAt = $v.startedAt;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CorrectiveActionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CorrectiveActionResponse;
  }

  @override
  void update(void Function(CorrectiveActionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CorrectiveActionResponse build() => _build();

  _$CorrectiveActionResponse _build() {
    final _$result = _$v ??
        new _$CorrectiveActionResponse._(
            assigneeId: BuiltValueNullFieldError.checkNotNull(
                assigneeId, r'CorrectiveActionResponse', 'assigneeId'),
            cancellationReason: cancellationReason,
            cancelledAt: cancelledAt,
            cancelledBy: cancelledBy,
            completedAt: completedAt,
            completedBy: completedBy,
            completionNotes: completionNotes,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CorrectiveActionResponse', 'createdAt'),
            createdBy: BuiltValueNullFieldError.checkNotNull(
                createdBy, r'CorrectiveActionResponse', 'createdBy'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'CorrectiveActionResponse', 'description'),
            dueDate: BuiltValueNullFieldError.checkNotNull(
                dueDate, r'CorrectiveActionResponse', 'dueDate'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CorrectiveActionResponse', 'id'),
            priority: BuiltValueNullFieldError.checkNotNull(
                priority, r'CorrectiveActionResponse', 'priority'),
            startedAt: startedAt,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CorrectiveActionResponse', 'status'),
            updatedAt:
                BuiltValueNullFieldError.checkNotNull(updatedAt, r'CorrectiveActionResponse', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
