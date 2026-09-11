// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_report_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnum_inspection =
    const GeneratedReportDetailReportTypeEnum._('inspection');
const GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnum_maintenance =
    const GeneratedReportDetailReportTypeEnum._('maintenance');
const GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnum_safety =
    const GeneratedReportDetailReportTypeEnum._('safety');
const GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnum_executiveSummary =
    const GeneratedReportDetailReportTypeEnum._('executiveSummary');
const GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnum_assetHealth =
    const GeneratedReportDetailReportTypeEnum._('assetHealth');

GeneratedReportDetailReportTypeEnum
    _$generatedReportDetailReportTypeEnumValueOf(String name) {
  switch (name) {
    case 'inspection':
      return _$generatedReportDetailReportTypeEnum_inspection;
    case 'maintenance':
      return _$generatedReportDetailReportTypeEnum_maintenance;
    case 'safety':
      return _$generatedReportDetailReportTypeEnum_safety;
    case 'executiveSummary':
      return _$generatedReportDetailReportTypeEnum_executiveSummary;
    case 'assetHealth':
      return _$generatedReportDetailReportTypeEnum_assetHealth;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GeneratedReportDetailReportTypeEnum>
    _$generatedReportDetailReportTypeEnumValues = new BuiltSet<
        GeneratedReportDetailReportTypeEnum>(const <GeneratedReportDetailReportTypeEnum>[
  _$generatedReportDetailReportTypeEnum_inspection,
  _$generatedReportDetailReportTypeEnum_maintenance,
  _$generatedReportDetailReportTypeEnum_safety,
  _$generatedReportDetailReportTypeEnum_executiveSummary,
  _$generatedReportDetailReportTypeEnum_assetHealth,
]);

const GeneratedReportDetailStatusEnum _$generatedReportDetailStatusEnum_draft =
    const GeneratedReportDetailStatusEnum._('draft');
const GeneratedReportDetailStatusEnum
    _$generatedReportDetailStatusEnum_finalized =
    const GeneratedReportDetailStatusEnum._('finalized');

GeneratedReportDetailStatusEnum _$generatedReportDetailStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'draft':
      return _$generatedReportDetailStatusEnum_draft;
    case 'finalized':
      return _$generatedReportDetailStatusEnum_finalized;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GeneratedReportDetailStatusEnum>
    _$generatedReportDetailStatusEnumValues = new BuiltSet<
        GeneratedReportDetailStatusEnum>(const <GeneratedReportDetailStatusEnum>[
  _$generatedReportDetailStatusEnum_draft,
  _$generatedReportDetailStatusEnum_finalized,
]);

Serializer<GeneratedReportDetailReportTypeEnum>
    _$generatedReportDetailReportTypeEnumSerializer =
    new _$GeneratedReportDetailReportTypeEnumSerializer();
Serializer<GeneratedReportDetailStatusEnum>
    _$generatedReportDetailStatusEnumSerializer =
    new _$GeneratedReportDetailStatusEnumSerializer();

class _$GeneratedReportDetailReportTypeEnumSerializer
    implements PrimitiveSerializer<GeneratedReportDetailReportTypeEnum> {
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
    GeneratedReportDetailReportTypeEnum
  ];
  @override
  final String wireName = 'GeneratedReportDetailReportTypeEnum';

  @override
  Object serialize(
          Serializers serializers, GeneratedReportDetailReportTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeneratedReportDetailReportTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeneratedReportDetailReportTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeneratedReportDetailStatusEnumSerializer
    implements PrimitiveSerializer<GeneratedReportDetailStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'finalized': 'finalized',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'finalized': 'finalized',
  };

  @override
  final Iterable<Type> types = const <Type>[GeneratedReportDetailStatusEnum];
  @override
  final String wireName = 'GeneratedReportDetailStatusEnum';

  @override
  Object serialize(
          Serializers serializers, GeneratedReportDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeneratedReportDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeneratedReportDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeneratedReportDetail extends GeneratedReportDetail {
  @override
  final String aiModel;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final bool finalizationAttestation;
  @override
  final DateTime? finalizedAt;
  @override
  final String? finalizedBy;
  @override
  final String id;
  @override
  final ReportNarrativeResponse narrative;
  @override
  final GeneratedReportDetailReportTypeEnum reportType;
  @override
  final int revision;
  @override
  final String? sourceId;
  @override
  final int? sourceRevision;
  @override
  final BuiltMap<String, JsonObject?> sourceSnapshot;
  @override
  final GeneratedReportDetailStatusEnum status;
  @override
  final String title;
  @override
  final DateTime updatedAt;

  factory _$GeneratedReportDetail(
          [void Function(GeneratedReportDetailBuilder)? updates]) =>
      (new GeneratedReportDetailBuilder()..update(updates))._build();

  _$GeneratedReportDetail._(
      {required this.aiModel,
      required this.createdAt,
      required this.createdBy,
      required this.finalizationAttestation,
      this.finalizedAt,
      this.finalizedBy,
      required this.id,
      required this.narrative,
      required this.reportType,
      required this.revision,
      this.sourceId,
      this.sourceRevision,
      required this.sourceSnapshot,
      required this.status,
      required this.title,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        aiModel, r'GeneratedReportDetail', 'aiModel');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'GeneratedReportDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'GeneratedReportDetail', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(finalizationAttestation,
        r'GeneratedReportDetail', 'finalizationAttestation');
    BuiltValueNullFieldError.checkNotNull(id, r'GeneratedReportDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        narrative, r'GeneratedReportDetail', 'narrative');
    BuiltValueNullFieldError.checkNotNull(
        reportType, r'GeneratedReportDetail', 'reportType');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'GeneratedReportDetail', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        sourceSnapshot, r'GeneratedReportDetail', 'sourceSnapshot');
    BuiltValueNullFieldError.checkNotNull(
        status, r'GeneratedReportDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        title, r'GeneratedReportDetail', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'GeneratedReportDetail', 'updatedAt');
  }

  @override
  GeneratedReportDetail rebuild(
          void Function(GeneratedReportDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeneratedReportDetailBuilder toBuilder() =>
      new GeneratedReportDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeneratedReportDetail &&
        aiModel == other.aiModel &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        finalizationAttestation == other.finalizationAttestation &&
        finalizedAt == other.finalizedAt &&
        finalizedBy == other.finalizedBy &&
        id == other.id &&
        narrative == other.narrative &&
        reportType == other.reportType &&
        revision == other.revision &&
        sourceId == other.sourceId &&
        sourceRevision == other.sourceRevision &&
        sourceSnapshot == other.sourceSnapshot &&
        status == other.status &&
        title == other.title &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, aiModel.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, finalizationAttestation.hashCode);
    _$hash = $jc(_$hash, finalizedAt.hashCode);
    _$hash = $jc(_$hash, finalizedBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, narrative.hashCode);
    _$hash = $jc(_$hash, reportType.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, sourceRevision.hashCode);
    _$hash = $jc(_$hash, sourceSnapshot.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeneratedReportDetail')
          ..add('aiModel', aiModel)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('finalizationAttestation', finalizationAttestation)
          ..add('finalizedAt', finalizedAt)
          ..add('finalizedBy', finalizedBy)
          ..add('id', id)
          ..add('narrative', narrative)
          ..add('reportType', reportType)
          ..add('revision', revision)
          ..add('sourceId', sourceId)
          ..add('sourceRevision', sourceRevision)
          ..add('sourceSnapshot', sourceSnapshot)
          ..add('status', status)
          ..add('title', title)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class GeneratedReportDetailBuilder
    implements Builder<GeneratedReportDetail, GeneratedReportDetailBuilder> {
  _$GeneratedReportDetail? _$v;

  String? _aiModel;
  String? get aiModel => _$this._aiModel;
  set aiModel(String? aiModel) => _$this._aiModel = aiModel;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  bool? _finalizationAttestation;
  bool? get finalizationAttestation => _$this._finalizationAttestation;
  set finalizationAttestation(bool? finalizationAttestation) =>
      _$this._finalizationAttestation = finalizationAttestation;

  DateTime? _finalizedAt;
  DateTime? get finalizedAt => _$this._finalizedAt;
  set finalizedAt(DateTime? finalizedAt) => _$this._finalizedAt = finalizedAt;

  String? _finalizedBy;
  String? get finalizedBy => _$this._finalizedBy;
  set finalizedBy(String? finalizedBy) => _$this._finalizedBy = finalizedBy;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ReportNarrativeResponseBuilder? _narrative;
  ReportNarrativeResponseBuilder get narrative =>
      _$this._narrative ??= new ReportNarrativeResponseBuilder();
  set narrative(ReportNarrativeResponseBuilder? narrative) =>
      _$this._narrative = narrative;

  GeneratedReportDetailReportTypeEnum? _reportType;
  GeneratedReportDetailReportTypeEnum? get reportType => _$this._reportType;
  set reportType(GeneratedReportDetailReportTypeEnum? reportType) =>
      _$this._reportType = reportType;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  String? _sourceId;
  String? get sourceId => _$this._sourceId;
  set sourceId(String? sourceId) => _$this._sourceId = sourceId;

  int? _sourceRevision;
  int? get sourceRevision => _$this._sourceRevision;
  set sourceRevision(int? sourceRevision) =>
      _$this._sourceRevision = sourceRevision;

  MapBuilder<String, JsonObject?>? _sourceSnapshot;
  MapBuilder<String, JsonObject?> get sourceSnapshot =>
      _$this._sourceSnapshot ??= new MapBuilder<String, JsonObject?>();
  set sourceSnapshot(MapBuilder<String, JsonObject?>? sourceSnapshot) =>
      _$this._sourceSnapshot = sourceSnapshot;

  GeneratedReportDetailStatusEnum? _status;
  GeneratedReportDetailStatusEnum? get status => _$this._status;
  set status(GeneratedReportDetailStatusEnum? status) =>
      _$this._status = status;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  GeneratedReportDetailBuilder() {
    GeneratedReportDetail._defaults(this);
  }

  GeneratedReportDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _aiModel = $v.aiModel;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _finalizationAttestation = $v.finalizationAttestation;
      _finalizedAt = $v.finalizedAt;
      _finalizedBy = $v.finalizedBy;
      _id = $v.id;
      _narrative = $v.narrative.toBuilder();
      _reportType = $v.reportType;
      _revision = $v.revision;
      _sourceId = $v.sourceId;
      _sourceRevision = $v.sourceRevision;
      _sourceSnapshot = $v.sourceSnapshot.toBuilder();
      _status = $v.status;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeneratedReportDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GeneratedReportDetail;
  }

  @override
  void update(void Function(GeneratedReportDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeneratedReportDetail build() => _build();

  _$GeneratedReportDetail _build() {
    _$GeneratedReportDetail _$result;
    try {
      _$result = _$v ??
          new _$GeneratedReportDetail._(
              aiModel: BuiltValueNullFieldError.checkNotNull(
                  aiModel, r'GeneratedReportDetail', 'aiModel'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'GeneratedReportDetail', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'GeneratedReportDetail', 'createdBy'),
              finalizationAttestation: BuiltValueNullFieldError.checkNotNull(
                  finalizationAttestation, r'GeneratedReportDetail', 'finalizationAttestation'),
              finalizedAt: finalizedAt,
              finalizedBy: finalizedBy,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'GeneratedReportDetail', 'id'),
              narrative: narrative.build(),
              reportType: BuiltValueNullFieldError.checkNotNull(
                  reportType, r'GeneratedReportDetail', 'reportType'),
              revision: BuiltValueNullFieldError.checkNotNull(
                  revision, r'GeneratedReportDetail', 'revision'),
              sourceId: sourceId,
              sourceRevision: sourceRevision,
              sourceSnapshot: sourceSnapshot.build(),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'GeneratedReportDetail', 'status'),
              title: BuiltValueNullFieldError.checkNotNull(title, r'GeneratedReportDetail', 'title'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'GeneratedReportDetail', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'narrative';
        narrative.build();

        _$failedField = 'sourceSnapshot';
        sourceSnapshot.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GeneratedReportDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
