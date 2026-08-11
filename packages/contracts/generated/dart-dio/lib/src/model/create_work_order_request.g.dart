// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_work_order_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateWorkOrderRequestPriorityEnum
    _$createWorkOrderRequestPriorityEnum_low =
    const CreateWorkOrderRequestPriorityEnum._('low');
const CreateWorkOrderRequestPriorityEnum
    _$createWorkOrderRequestPriorityEnum_medium =
    const CreateWorkOrderRequestPriorityEnum._('medium');
const CreateWorkOrderRequestPriorityEnum
    _$createWorkOrderRequestPriorityEnum_high =
    const CreateWorkOrderRequestPriorityEnum._('high');
const CreateWorkOrderRequestPriorityEnum
    _$createWorkOrderRequestPriorityEnum_critical =
    const CreateWorkOrderRequestPriorityEnum._('critical');

CreateWorkOrderRequestPriorityEnum _$createWorkOrderRequestPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'low':
      return _$createWorkOrderRequestPriorityEnum_low;
    case 'medium':
      return _$createWorkOrderRequestPriorityEnum_medium;
    case 'high':
      return _$createWorkOrderRequestPriorityEnum_high;
    case 'critical':
      return _$createWorkOrderRequestPriorityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateWorkOrderRequestPriorityEnum>
    _$createWorkOrderRequestPriorityEnumValues = new BuiltSet<
        CreateWorkOrderRequestPriorityEnum>(const <CreateWorkOrderRequestPriorityEnum>[
  _$createWorkOrderRequestPriorityEnum_low,
  _$createWorkOrderRequestPriorityEnum_medium,
  _$createWorkOrderRequestPriorityEnum_high,
  _$createWorkOrderRequestPriorityEnum_critical,
]);

Serializer<CreateWorkOrderRequestPriorityEnum>
    _$createWorkOrderRequestPriorityEnumSerializer =
    new _$CreateWorkOrderRequestPriorityEnumSerializer();

class _$CreateWorkOrderRequestPriorityEnumSerializer
    implements PrimitiveSerializer<CreateWorkOrderRequestPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[CreateWorkOrderRequestPriorityEnum];
  @override
  final String wireName = 'CreateWorkOrderRequestPriorityEnum';

  @override
  Object serialize(
          Serializers serializers, CreateWorkOrderRequestPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateWorkOrderRequestPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateWorkOrderRequestPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateWorkOrderRequest extends CreateWorkOrderRequest {
  @override
  final String assetId;
  @override
  final String? description;
  @override
  final DateTime? dueDate;
  @override
  final String id;
  @override
  final CreateWorkOrderRequestPriorityEnum? priority;
  @override
  final String? sourceInspectionId;
  @override
  final String title;

  factory _$CreateWorkOrderRequest(
          [void Function(CreateWorkOrderRequestBuilder)? updates]) =>
      (new CreateWorkOrderRequestBuilder()..update(updates))._build();

  _$CreateWorkOrderRequest._(
      {required this.assetId,
      this.description,
      this.dueDate,
      required this.id,
      this.priority,
      this.sourceInspectionId,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'CreateWorkOrderRequest', 'assetId');
    BuiltValueNullFieldError.checkNotNull(id, r'CreateWorkOrderRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        title, r'CreateWorkOrderRequest', 'title');
  }

  @override
  CreateWorkOrderRequest rebuild(
          void Function(CreateWorkOrderRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateWorkOrderRequestBuilder toBuilder() =>
      new CreateWorkOrderRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateWorkOrderRequest &&
        assetId == other.assetId &&
        description == other.description &&
        dueDate == other.dueDate &&
        id == other.id &&
        priority == other.priority &&
        sourceInspectionId == other.sourceInspectionId &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, sourceInspectionId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateWorkOrderRequest')
          ..add('assetId', assetId)
          ..add('description', description)
          ..add('dueDate', dueDate)
          ..add('id', id)
          ..add('priority', priority)
          ..add('sourceInspectionId', sourceInspectionId)
          ..add('title', title))
        .toString();
  }
}

class CreateWorkOrderRequestBuilder
    implements Builder<CreateWorkOrderRequest, CreateWorkOrderRequestBuilder> {
  _$CreateWorkOrderRequest? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateWorkOrderRequestPriorityEnum? _priority;
  CreateWorkOrderRequestPriorityEnum? get priority => _$this._priority;
  set priority(CreateWorkOrderRequestPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _sourceInspectionId;
  String? get sourceInspectionId => _$this._sourceInspectionId;
  set sourceInspectionId(String? sourceInspectionId) =>
      _$this._sourceInspectionId = sourceInspectionId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  CreateWorkOrderRequestBuilder() {
    CreateWorkOrderRequest._defaults(this);
  }

  CreateWorkOrderRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _description = $v.description;
      _dueDate = $v.dueDate;
      _id = $v.id;
      _priority = $v.priority;
      _sourceInspectionId = $v.sourceInspectionId;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateWorkOrderRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateWorkOrderRequest;
  }

  @override
  void update(void Function(CreateWorkOrderRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateWorkOrderRequest build() => _build();

  _$CreateWorkOrderRequest _build() {
    final _$result = _$v ??
        new _$CreateWorkOrderRequest._(
            assetId: BuiltValueNullFieldError.checkNotNull(
                assetId, r'CreateWorkOrderRequest', 'assetId'),
            description: description,
            dueDate: dueDate,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateWorkOrderRequest', 'id'),
            priority: priority,
            sourceInspectionId: sourceInspectionId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'CreateWorkOrderRequest', 'title'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
