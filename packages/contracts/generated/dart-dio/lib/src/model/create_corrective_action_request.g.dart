// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_corrective_action_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateCorrectiveActionRequestPriorityEnum
    _$createCorrectiveActionRequestPriorityEnum_low =
    const CreateCorrectiveActionRequestPriorityEnum._('low');
const CreateCorrectiveActionRequestPriorityEnum
    _$createCorrectiveActionRequestPriorityEnum_medium =
    const CreateCorrectiveActionRequestPriorityEnum._('medium');
const CreateCorrectiveActionRequestPriorityEnum
    _$createCorrectiveActionRequestPriorityEnum_high =
    const CreateCorrectiveActionRequestPriorityEnum._('high');
const CreateCorrectiveActionRequestPriorityEnum
    _$createCorrectiveActionRequestPriorityEnum_critical =
    const CreateCorrectiveActionRequestPriorityEnum._('critical');

CreateCorrectiveActionRequestPriorityEnum
    _$createCorrectiveActionRequestPriorityEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$createCorrectiveActionRequestPriorityEnum_low;
    case 'medium':
      return _$createCorrectiveActionRequestPriorityEnum_medium;
    case 'high':
      return _$createCorrectiveActionRequestPriorityEnum_high;
    case 'critical':
      return _$createCorrectiveActionRequestPriorityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateCorrectiveActionRequestPriorityEnum>
    _$createCorrectiveActionRequestPriorityEnumValues = new BuiltSet<
        CreateCorrectiveActionRequestPriorityEnum>(const <CreateCorrectiveActionRequestPriorityEnum>[
  _$createCorrectiveActionRequestPriorityEnum_low,
  _$createCorrectiveActionRequestPriorityEnum_medium,
  _$createCorrectiveActionRequestPriorityEnum_high,
  _$createCorrectiveActionRequestPriorityEnum_critical,
]);

Serializer<CreateCorrectiveActionRequestPriorityEnum>
    _$createCorrectiveActionRequestPriorityEnumSerializer =
    new _$CreateCorrectiveActionRequestPriorityEnumSerializer();

class _$CreateCorrectiveActionRequestPriorityEnumSerializer
    implements PrimitiveSerializer<CreateCorrectiveActionRequestPriorityEnum> {
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
    CreateCorrectiveActionRequestPriorityEnum
  ];
  @override
  final String wireName = 'CreateCorrectiveActionRequestPriorityEnum';

  @override
  Object serialize(Serializers serializers,
          CreateCorrectiveActionRequestPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateCorrectiveActionRequestPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateCorrectiveActionRequestPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateCorrectiveActionRequest extends CreateCorrectiveActionRequest {
  @override
  final String assigneeId;
  @override
  final String description;
  @override
  final DateTime dueDate;
  @override
  final String id;
  @override
  final CreateCorrectiveActionRequestPriorityEnum? priority;

  factory _$CreateCorrectiveActionRequest(
          [void Function(CreateCorrectiveActionRequestBuilder)? updates]) =>
      (new CreateCorrectiveActionRequestBuilder()..update(updates))._build();

  _$CreateCorrectiveActionRequest._(
      {required this.assigneeId,
      required this.description,
      required this.dueDate,
      required this.id,
      this.priority})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assigneeId, r'CreateCorrectiveActionRequest', 'assigneeId');
    BuiltValueNullFieldError.checkNotNull(
        description, r'CreateCorrectiveActionRequest', 'description');
    BuiltValueNullFieldError.checkNotNull(
        dueDate, r'CreateCorrectiveActionRequest', 'dueDate');
    BuiltValueNullFieldError.checkNotNull(
        id, r'CreateCorrectiveActionRequest', 'id');
  }

  @override
  CreateCorrectiveActionRequest rebuild(
          void Function(CreateCorrectiveActionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCorrectiveActionRequestBuilder toBuilder() =>
      new CreateCorrectiveActionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCorrectiveActionRequest &&
        assigneeId == other.assigneeId &&
        description == other.description &&
        dueDate == other.dueDate &&
        id == other.id &&
        priority == other.priority;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assigneeId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCorrectiveActionRequest')
          ..add('assigneeId', assigneeId)
          ..add('description', description)
          ..add('dueDate', dueDate)
          ..add('id', id)
          ..add('priority', priority))
        .toString();
  }
}

class CreateCorrectiveActionRequestBuilder
    implements
        Builder<CreateCorrectiveActionRequest,
            CreateCorrectiveActionRequestBuilder> {
  _$CreateCorrectiveActionRequest? _$v;

  String? _assigneeId;
  String? get assigneeId => _$this._assigneeId;
  set assigneeId(String? assigneeId) => _$this._assigneeId = assigneeId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateCorrectiveActionRequestPriorityEnum? _priority;
  CreateCorrectiveActionRequestPriorityEnum? get priority => _$this._priority;
  set priority(CreateCorrectiveActionRequestPriorityEnum? priority) =>
      _$this._priority = priority;

  CreateCorrectiveActionRequestBuilder() {
    CreateCorrectiveActionRequest._defaults(this);
  }

  CreateCorrectiveActionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assigneeId = $v.assigneeId;
      _description = $v.description;
      _dueDate = $v.dueDate;
      _id = $v.id;
      _priority = $v.priority;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCorrectiveActionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateCorrectiveActionRequest;
  }

  @override
  void update(void Function(CreateCorrectiveActionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCorrectiveActionRequest build() => _build();

  _$CreateCorrectiveActionRequest _build() {
    final _$result = _$v ??
        new _$CreateCorrectiveActionRequest._(
            assigneeId: BuiltValueNullFieldError.checkNotNull(
                assigneeId, r'CreateCorrectiveActionRequest', 'assigneeId'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'CreateCorrectiveActionRequest', 'description'),
            dueDate: BuiltValueNullFieldError.checkNotNull(
                dueDate, r'CreateCorrectiveActionRequest', 'dueDate'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateCorrectiveActionRequest', 'id'),
            priority: priority);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
