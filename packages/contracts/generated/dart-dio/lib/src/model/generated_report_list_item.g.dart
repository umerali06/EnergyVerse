// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_report_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnum_inspection =
    const GeneratedReportListItemReportTypeEnum._('inspection');
const GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnum_maintenance =
    const GeneratedReportListItemReportTypeEnum._('maintenance');
const GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnum_safety =
    const GeneratedReportListItemReportTypeEnum._('safety');
const GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnum_executiveSummary =
    const GeneratedReportListItemReportTypeEnum._('executiveSummary');
const GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnum_assetHealth =
    const GeneratedReportListItemReportTypeEnum._('assetHealth');

GeneratedReportListItemReportTypeEnum
    _$generatedReportListItemReportTypeEnumValueOf(String name) {
  switch (name) {
    case 'inspection':
      return _$generatedReportListItemReportTypeEnum_inspection;
    case 'maintenance':
      return _$generatedReportListItemReportTypeEnum_maintenance;
    case 'safety':
      return _$generatedReportListItemReportTypeEnum_safety;
    case 'executiveSummary':
      return _$generatedReportListItemReportTypeEnum_executiveSummary;
    case 'assetHealth':
      return _$generatedReportListItemReportTypeEnum_assetHealth;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GeneratedReportListItemReportTypeEnum>
    _$generatedReportListItemReportTypeEnumValues = new BuiltSet<
        GeneratedReportListItemReportTypeEnum>(const <GeneratedReportListItemReportTypeEnum>[
  _$generatedReportListItemReportTypeEnum_inspection,
  _$generatedReportListItemReportTypeEnum_maintenance,
  _$generatedReportListItemReportTypeEnum_safety,
  _$generatedReportListItemReportTypeEnum_executiveSummary,
  _$generatedReportListItemReportTypeEnum_assetHealth,
]);

const GeneratedReportListItemStatusEnum
    _$generatedReportListItemStatusEnum_draft =
    const GeneratedReportListItemStatusEnum._('draft');
const GeneratedReportListItemStatusEnum
    _$generatedReportListItemStatusEnum_finalized =
    const GeneratedReportListItemStatusEnum._('finalized');

GeneratedReportListItemStatusEnum _$generatedReportListItemStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'draft':
      return _$generatedReportListItemStatusEnum_draft;
    case 'finalized':
      return _$generatedReportListItemStatusEnum_finalized;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GeneratedReportListItemStatusEnum>
    _$generatedReportListItemStatusEnumValues = new BuiltSet<
        GeneratedReportListItemStatusEnum>(const <GeneratedReportListItemStatusEnum>[
  _$generatedReportListItemStatusEnum_draft,
  _$generatedReportListItemStatusEnum_finalized,
]);

Serializer<GeneratedReportListItemReportTypeEnum>
    _$generatedReportListItemReportTypeEnumSerializer =
    new _$GeneratedReportListItemReportTypeEnumSerializer();
Serializer<GeneratedReportListItemStatusEnum>
    _$generatedReportListItemStatusEnumSerializer =
    new _$GeneratedReportListItemStatusEnumSerializer();

class _$GeneratedReportListItemReportTypeEnumSerializer
    implements PrimitiveSerializer<GeneratedReportListItemReportTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inspection': 'inspection',
    'maintenance': 'maintenance',
    'safety': 'safety',
    'executiveSummary': 'executive_summary',
    'assetHealth': 'asset_health',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'inspection': 'inspection',
    'maintenance': 'maintenance',
    'safety': 'safety',
    'executive_summary': 'executiveSummary',
    'asset_health': 'assetHealth',
  };

  @override
  final Iterable<Type> types = const <Type>[
    GeneratedReportListItemReportTypeEnum
  ];
  @override
  final String wireName = 'GeneratedReportListItemReportTypeEnum';

  @override
  Object serialize(
          Serializers serializers, GeneratedReportListItemReportTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeneratedReportListItemReportTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeneratedReportListItemReportTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeneratedReportListItemStatusEnumSerializer
    implements PrimitiveSerializer<GeneratedReportListItemStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'finalized': 'finalized',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'finalized': 'finalized',
  };

  @override
  final Iterable<Type> types = const <Type>[GeneratedReportListItemStatusEnum];
  @override
  final String wireName = 'GeneratedReportListItemStatusEnum';

  @override
  Object serialize(
          Serializers serializers, GeneratedReportListItemStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeneratedReportListItemStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeneratedReportListItemStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeneratedReportListItem extends GeneratedReportListItem {
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final DateTime? finalizedAt;
  @override
  final String? finalizedBy;
  @override
  final String id;
  @override
  final GeneratedReportListItemReportTypeEnum reportType;
  @override
  final int revision;
  @override
  final String? sourceId;
  @override
  final GeneratedReportListItemStatusEnum status;
  @override
  final String title;
  @override
  final DateTime updatedAt;

  factory _$GeneratedReportListItem(
          [void Function(GeneratedReportListItemBuilder)? updates]) =>
      (new GeneratedReportListItemBuilder()..update(updates))._build();

  _$GeneratedReportListItem._(
      {required this.createdAt,
      required this.createdBy,
      this.finalizedAt,
      this.finalizedBy,
      required this.id,
      required this.reportType,
      required this.revision,
      this.sourceId,
      required this.status,
      required this.title,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'GeneratedReportListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'GeneratedReportListItem', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(id, r'GeneratedReportListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        reportType, r'GeneratedReportListItem', 'reportType');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'GeneratedReportListItem', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        status, r'GeneratedReportListItem', 'status');
    BuiltValueNullFieldError.checkNotNull(
        title, r'GeneratedReportListItem', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'GeneratedReportListItem', 'updatedAt');
  }

  @override
  GeneratedReportListItem rebuild(
          void Function(GeneratedReportListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeneratedReportListItemBuilder toBuilder() =>
      new GeneratedReportListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeneratedReportListItem &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        finalizedAt == other.finalizedAt &&
        finalizedBy == other.finalizedBy &&
        id == other.id &&
        reportType == other.reportType &&
        revision == other.revision &&
        sourceId == other.sourceId &&
        status == other.status &&
        title == other.title &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, finalizedAt.hashCode);
    _$hash = $jc(_$hash, finalizedBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reportType.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeneratedReportListItem')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('finalizedAt', finalizedAt)
          ..add('finalizedBy', finalizedBy)
          ..add('id', id)
          ..add('reportType', reportType)
          ..add('revision', revision)
          ..add('sourceId', sourceId)
          ..add('status', status)
          ..add('title', title)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class GeneratedReportListItemBuilder
    implements
        Builder<GeneratedReportListItem, GeneratedReportListItemBuilder> {
  _$GeneratedReportListItem? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _finalizedAt;
  DateTime? get finalizedAt => _$this._finalizedAt;
  set finalizedAt(DateTime? finalizedAt) => _$this._finalizedAt = finalizedAt;

  String? _finalizedBy;
  String? get finalizedBy => _$this._finalizedBy;
  set finalizedBy(String? finalizedBy) => _$this._finalizedBy = finalizedBy;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  GeneratedReportListItemReportTypeEnum? _reportType;
  GeneratedReportListItemReportTypeEnum? get reportType => _$this._reportType;
  set reportType(GeneratedReportListItemReportTypeEnum? reportType) =>
      _$this._reportType = reportType;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  String? _sourceId;
  String? get sourceId => _$this._sourceId;
  set sourceId(String? sourceId) => _$this._sourceId = sourceId;

  GeneratedReportListItemStatusEnum? _status;
  GeneratedReportListItemStatusEnum? get status => _$this._status;
  set status(GeneratedReportListItemStatusEnum? status) =>
      _$this._status = status;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  GeneratedReportListItemBuilder() {
    GeneratedReportListItem._defaults(this);
  }

  GeneratedReportListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _finalizedAt = $v.finalizedAt;
      _finalizedBy = $v.finalizedBy;
      _id = $v.id;
      _reportType = $v.reportType;
      _revision = $v.revision;
      _sourceId = $v.sourceId;
      _status = $v.status;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeneratedReportListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GeneratedReportListItem;
  }

  @override
  void update(void Function(GeneratedReportListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeneratedReportListItem build() => _build();

  _$GeneratedReportListItem _build() {
    final _$result = _$v ??
        new _$GeneratedReportListItem._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'GeneratedReportListItem', 'createdAt'),
            createdBy: BuiltValueNullFieldError.checkNotNull(
                createdBy, r'GeneratedReportListItem', 'createdBy'),
            finalizedAt: finalizedAt,
            finalizedBy: finalizedBy,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GeneratedReportListItem', 'id'),
            reportType: BuiltValueNullFieldError.checkNotNull(
                reportType, r'GeneratedReportListItem', 'reportType'),
            revision: BuiltValueNullFieldError.checkNotNull(
                revision, r'GeneratedReportListItem', 'revision'),
            sourceId: sourceId,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GeneratedReportListItem', 'status'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'GeneratedReportListItem', 'title'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'GeneratedReportListItem', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
