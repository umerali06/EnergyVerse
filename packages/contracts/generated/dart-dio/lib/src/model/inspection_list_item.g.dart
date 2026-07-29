// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InspectionListItemInspectionTypeEnum
    _$inspectionListItemInspectionTypeEnum_routine =
    const InspectionListItemInspectionTypeEnum._('routine');
const InspectionListItemInspectionTypeEnum
    _$inspectionListItemInspectionTypeEnum_scheduled =
    const InspectionListItemInspectionTypeEnum._('scheduled');
const InspectionListItemInspectionTypeEnum
    _$inspectionListItemInspectionTypeEnum_adHoc =
    const InspectionListItemInspectionTypeEnum._('adHoc');

InspectionListItemInspectionTypeEnum
    _$inspectionListItemInspectionTypeEnumValueOf(String name) {
  switch (name) {
    case 'routine':
      return _$inspectionListItemInspectionTypeEnum_routine;
    case 'scheduled':
      return _$inspectionListItemInspectionTypeEnum_scheduled;
    case 'adHoc':
      return _$inspectionListItemInspectionTypeEnum_adHoc;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionListItemInspectionTypeEnum>
    _$inspectionListItemInspectionTypeEnumValues = new BuiltSet<
        InspectionListItemInspectionTypeEnum>(const <InspectionListItemInspectionTypeEnum>[
  _$inspectionListItemInspectionTypeEnum_routine,
  _$inspectionListItemInspectionTypeEnum_scheduled,
  _$inspectionListItemInspectionTypeEnum_adHoc,
]);

const InspectionListItemStatusEnum _$inspectionListItemStatusEnum_draft =
    const InspectionListItemStatusEnum._('draft');
const InspectionListItemStatusEnum _$inspectionListItemStatusEnum_inProgress =
    const InspectionListItemStatusEnum._('inProgress');
const InspectionListItemStatusEnum _$inspectionListItemStatusEnum_completed =
    const InspectionListItemStatusEnum._('completed');
const InspectionListItemStatusEnum _$inspectionListItemStatusEnum_cancelled =
    const InspectionListItemStatusEnum._('cancelled');

InspectionListItemStatusEnum _$inspectionListItemStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'draft':
      return _$inspectionListItemStatusEnum_draft;
    case 'inProgress':
      return _$inspectionListItemStatusEnum_inProgress;
    case 'completed':
      return _$inspectionListItemStatusEnum_completed;
    case 'cancelled':
      return _$inspectionListItemStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionListItemStatusEnum>
    _$inspectionListItemStatusEnumValues = new BuiltSet<
        InspectionListItemStatusEnum>(const <InspectionListItemStatusEnum>[
  _$inspectionListItemStatusEnum_draft,
  _$inspectionListItemStatusEnum_inProgress,
  _$inspectionListItemStatusEnum_completed,
  _$inspectionListItemStatusEnum_cancelled,
]);

Serializer<InspectionListItemInspectionTypeEnum>
    _$inspectionListItemInspectionTypeEnumSerializer =
    new _$InspectionListItemInspectionTypeEnumSerializer();
Serializer<InspectionListItemStatusEnum>
    _$inspectionListItemStatusEnumSerializer =
    new _$InspectionListItemStatusEnumSerializer();

class _$InspectionListItemInspectionTypeEnumSerializer
    implements PrimitiveSerializer<InspectionListItemInspectionTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'routine': 'routine',
    'scheduled': 'scheduled',
    'adHoc': 'ad_hoc',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'routine': 'routine',
    'scheduled': 'scheduled',
    'ad_hoc': 'adHoc',
  };

  @override
  final Iterable<Type> types = const <Type>[
    InspectionListItemInspectionTypeEnum
  ];
  @override
  final String wireName = 'InspectionListItemInspectionTypeEnum';

  @override
  Object serialize(
          Serializers serializers, InspectionListItemInspectionTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionListItemInspectionTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionListItemInspectionTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionListItemStatusEnumSerializer
    implements PrimitiveSerializer<InspectionListItemStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'inProgress': 'in_progress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'in_progress': 'inProgress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[InspectionListItemStatusEnum];
  @override
  final String wireName = 'InspectionListItemStatusEnum';

  @override
  Object serialize(Serializers serializers, InspectionListItemStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionListItemStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionListItemStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionListItem extends InspectionListItem {
  @override
  final String? areaId;
  @override
  final String assetId;
  @override
  final String? checklistTemplateId;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final String facilityId;
  @override
  final String id;
  @override
  final InspectionListItemInspectionTypeEnum inspectionType;
  @override
  final String inspectorId;
  @override
  final int revision;
  @override
  final DateTime? startedAt;
  @override
  final InspectionListItemStatusEnum status;
  @override
  final String? title;
  @override
  final DateTime updatedAt;

  factory _$InspectionListItem(
          [void Function(InspectionListItemBuilder)? updates]) =>
      (new InspectionListItemBuilder()..update(updates))._build();

  _$InspectionListItem._(
      {this.areaId,
      required this.assetId,
      this.checklistTemplateId,
      this.completedAt,
      required this.createdAt,
      required this.facilityId,
      required this.id,
      required this.inspectionType,
      required this.inspectorId,
      required this.revision,
      this.startedAt,
      required this.status,
      this.title,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'InspectionListItem', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'InspectionListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'InspectionListItem', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'InspectionListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        inspectionType, r'InspectionListItem', 'inspectionType');
    BuiltValueNullFieldError.checkNotNull(
        inspectorId, r'InspectionListItem', 'inspectorId');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'InspectionListItem', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        status, r'InspectionListItem', 'status');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'InspectionListItem', 'updatedAt');
  }

  @override
  InspectionListItem rebuild(
          void Function(InspectionListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InspectionListItemBuilder toBuilder() =>
      new InspectionListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InspectionListItem &&
        areaId == other.areaId &&
        assetId == other.assetId &&
        checklistTemplateId == other.checklistTemplateId &&
        completedAt == other.completedAt &&
        createdAt == other.createdAt &&
        facilityId == other.facilityId &&
        id == other.id &&
        inspectionType == other.inspectionType &&
        inspectorId == other.inspectorId &&
        revision == other.revision &&
        startedAt == other.startedAt &&
        status == other.status &&
        title == other.title &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, checklistTemplateId.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inspectionType.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InspectionListItem')
          ..add('areaId', areaId)
          ..add('assetId', assetId)
          ..add('checklistTemplateId', checklistTemplateId)
          ..add('completedAt', completedAt)
          ..add('createdAt', createdAt)
          ..add('facilityId', facilityId)
          ..add('id', id)
          ..add('inspectionType', inspectionType)
          ..add('inspectorId', inspectorId)
          ..add('revision', revision)
          ..add('startedAt', startedAt)
          ..add('status', status)
          ..add('title', title)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class InspectionListItemBuilder
    implements Builder<InspectionListItem, InspectionListItemBuilder> {
  _$InspectionListItem? _$v;

  String? _areaId;
  String? get areaId => _$this._areaId;
  set areaId(String? areaId) => _$this._areaId = areaId;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _checklistTemplateId;
  String? get checklistTemplateId => _$this._checklistTemplateId;
  set checklistTemplateId(String? checklistTemplateId) =>
      _$this._checklistTemplateId = checklistTemplateId;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InspectionListItemInspectionTypeEnum? _inspectionType;
  InspectionListItemInspectionTypeEnum? get inspectionType =>
      _$this._inspectionType;
  set inspectionType(InspectionListItemInspectionTypeEnum? inspectionType) =>
      _$this._inspectionType = inspectionType;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  InspectionListItemStatusEnum? _status;
  InspectionListItemStatusEnum? get status => _$this._status;
  set status(InspectionListItemStatusEnum? status) => _$this._status = status;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  InspectionListItemBuilder() {
    InspectionListItem._defaults(this);
  }

  InspectionListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _areaId = $v.areaId;
      _assetId = $v.assetId;
      _checklistTemplateId = $v.checklistTemplateId;
      _completedAt = $v.completedAt;
      _createdAt = $v.createdAt;
      _facilityId = $v.facilityId;
      _id = $v.id;
      _inspectionType = $v.inspectionType;
      _inspectorId = $v.inspectorId;
      _revision = $v.revision;
      _startedAt = $v.startedAt;
      _status = $v.status;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InspectionListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InspectionListItem;
  }

  @override
  void update(void Function(InspectionListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InspectionListItem build() => _build();

  _$InspectionListItem _build() {
    final _$result = _$v ??
        new _$InspectionListItem._(
            areaId: areaId,
            assetId: BuiltValueNullFieldError.checkNotNull(
                assetId, r'InspectionListItem', 'assetId'),
            checklistTemplateId: checklistTemplateId,
            completedAt: completedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'InspectionListItem', 'createdAt'),
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'InspectionListItem', 'facilityId'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InspectionListItem', 'id'),
            inspectionType: BuiltValueNullFieldError.checkNotNull(
                inspectionType, r'InspectionListItem', 'inspectionType'),
            inspectorId: BuiltValueNullFieldError.checkNotNull(
                inspectorId, r'InspectionListItem', 'inspectorId'),
            revision: BuiltValueNullFieldError.checkNotNull(
                revision, r'InspectionListItem', 'revision'),
            startedAt: startedAt,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'InspectionListItem', 'status'),
            title: title,
            updatedAt:
                BuiltValueNullFieldError.checkNotNull(updatedAt, r'InspectionListItem', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
