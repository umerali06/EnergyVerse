// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InspectionDetailInspectionTypeEnum
    _$inspectionDetailInspectionTypeEnum_routine =
    const InspectionDetailInspectionTypeEnum._('routine');
const InspectionDetailInspectionTypeEnum
    _$inspectionDetailInspectionTypeEnum_scheduled =
    const InspectionDetailInspectionTypeEnum._('scheduled');
const InspectionDetailInspectionTypeEnum
    _$inspectionDetailInspectionTypeEnum_adHoc =
    const InspectionDetailInspectionTypeEnum._('adHoc');

InspectionDetailInspectionTypeEnum _$inspectionDetailInspectionTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'routine':
      return _$inspectionDetailInspectionTypeEnum_routine;
    case 'scheduled':
      return _$inspectionDetailInspectionTypeEnum_scheduled;
    case 'adHoc':
      return _$inspectionDetailInspectionTypeEnum_adHoc;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionDetailInspectionTypeEnum>
    _$inspectionDetailInspectionTypeEnumValues = new BuiltSet<
        InspectionDetailInspectionTypeEnum>(const <InspectionDetailInspectionTypeEnum>[
  _$inspectionDetailInspectionTypeEnum_routine,
  _$inspectionDetailInspectionTypeEnum_scheduled,
  _$inspectionDetailInspectionTypeEnum_adHoc,
]);

const InspectionDetailStatusEnum _$inspectionDetailStatusEnum_draft =
    const InspectionDetailStatusEnum._('draft');
const InspectionDetailStatusEnum _$inspectionDetailStatusEnum_inProgress =
    const InspectionDetailStatusEnum._('inProgress');
const InspectionDetailStatusEnum _$inspectionDetailStatusEnum_completed =
    const InspectionDetailStatusEnum._('completed');
const InspectionDetailStatusEnum _$inspectionDetailStatusEnum_cancelled =
    const InspectionDetailStatusEnum._('cancelled');

InspectionDetailStatusEnum _$inspectionDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$inspectionDetailStatusEnum_draft;
    case 'inProgress':
      return _$inspectionDetailStatusEnum_inProgress;
    case 'completed':
      return _$inspectionDetailStatusEnum_completed;
    case 'cancelled':
      return _$inspectionDetailStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionDetailStatusEnum> _$inspectionDetailStatusEnumValues =
    new BuiltSet<InspectionDetailStatusEnum>(const <InspectionDetailStatusEnum>[
  _$inspectionDetailStatusEnum_draft,
  _$inspectionDetailStatusEnum_inProgress,
  _$inspectionDetailStatusEnum_completed,
  _$inspectionDetailStatusEnum_cancelled,
]);

Serializer<InspectionDetailInspectionTypeEnum>
    _$inspectionDetailInspectionTypeEnumSerializer =
    new _$InspectionDetailInspectionTypeEnumSerializer();
Serializer<InspectionDetailStatusEnum> _$inspectionDetailStatusEnumSerializer =
    new _$InspectionDetailStatusEnumSerializer();

class _$InspectionDetailInspectionTypeEnumSerializer
    implements PrimitiveSerializer<InspectionDetailInspectionTypeEnum> {
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
  final Iterable<Type> types = const <Type>[InspectionDetailInspectionTypeEnum];
  @override
  final String wireName = 'InspectionDetailInspectionTypeEnum';

  @override
  Object serialize(
          Serializers serializers, InspectionDetailInspectionTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionDetailInspectionTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionDetailInspectionTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionDetailStatusEnumSerializer
    implements PrimitiveSerializer<InspectionDetailStatusEnum> {
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
  final Iterable<Type> types = const <Type>[InspectionDetailStatusEnum];
  @override
  final String wireName = 'InspectionDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, InspectionDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionDetail extends InspectionDetail {
  @override
  final BuiltMap<String, JsonObject?>? aiAnalysis;
  @override
  final BuiltList<AnnotationResponse>? annotations;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? arMeasurements;
  @override
  final String? areaId;
  @override
  final String assetId;
  @override
  final BuiltList<ChecklistTemplateItem>? checklistItemsSnapshot;
  @override
  final BuiltList<ChecklistResponse>? checklistResponses;
  @override
  final String? checklistTemplateId;
  @override
  final int? checklistTemplateVersion;
  @override
  final DateTime clientCreatedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final String? deviceId;
  @override
  final String facilityId;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
  @override
  final InspectionDetailInspectionTypeEnum inspectionType;
  @override
  final String inspectorId;
  @override
  final BuiltList<InspectionMediaResponse>? media;
  @override
  final String? notes;
  @override
  final String? origin;
  @override
  final BuiltMap<String, JsonObject?>? readings;
  @override
  final int revision;
  @override
  final BuiltMap<String, JsonObject?>? signature;
  @override
  final DateTime? startedAt;
  @override
  final InspectionDetailStatusEnum status;
  @override
  final String? title;
  @override
  final DateTime updatedAt;
  @override
  final BuiltList<VoiceNoteResponse>? voiceNotes;

  factory _$InspectionDetail(
          [void Function(InspectionDetailBuilder)? updates]) =>
      (new InspectionDetailBuilder()..update(updates))._build();

  _$InspectionDetail._(
      {this.aiAnalysis,
      this.annotations,
      this.arMeasurements,
      this.areaId,
      required this.assetId,
      this.checklistItemsSnapshot,
      this.checklistResponses,
      this.checklistTemplateId,
      this.checklistTemplateVersion,
      required this.clientCreatedAt,
      this.completedAt,
      required this.createdAt,
      this.deviceId,
      required this.facilityId,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      required this.inspectionType,
      required this.inspectorId,
      this.media,
      this.notes,
      this.origin,
      this.readings,
      required this.revision,
      this.signature,
      this.startedAt,
      required this.status,
      this.title,
      required this.updatedAt,
      this.voiceNotes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'InspectionDetail', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        clientCreatedAt, r'InspectionDetail', 'clientCreatedAt');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'InspectionDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'InspectionDetail', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'InspectionDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        inspectionType, r'InspectionDetail', 'inspectionType');
    BuiltValueNullFieldError.checkNotNull(
        inspectorId, r'InspectionDetail', 'inspectorId');
    BuiltValueNullFieldError.checkNotNull(
        revision, r'InspectionDetail', 'revision');
    BuiltValueNullFieldError.checkNotNull(
        status, r'InspectionDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'InspectionDetail', 'updatedAt');
  }

  @override
  InspectionDetail rebuild(void Function(InspectionDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InspectionDetailBuilder toBuilder() =>
      new InspectionDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InspectionDetail &&
        aiAnalysis == other.aiAnalysis &&
        annotations == other.annotations &&
        arMeasurements == other.arMeasurements &&
        areaId == other.areaId &&
        assetId == other.assetId &&
        checklistItemsSnapshot == other.checklistItemsSnapshot &&
        checklistResponses == other.checklistResponses &&
        checklistTemplateId == other.checklistTemplateId &&
        checklistTemplateVersion == other.checklistTemplateVersion &&
        clientCreatedAt == other.clientCreatedAt &&
        completedAt == other.completedAt &&
        createdAt == other.createdAt &&
        deviceId == other.deviceId &&
        facilityId == other.facilityId &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        inspectionType == other.inspectionType &&
        inspectorId == other.inspectorId &&
        media == other.media &&
        notes == other.notes &&
        origin == other.origin &&
        readings == other.readings &&
        revision == other.revision &&
        signature == other.signature &&
        startedAt == other.startedAt &&
        status == other.status &&
        title == other.title &&
        updatedAt == other.updatedAt &&
        voiceNotes == other.voiceNotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, aiAnalysis.hashCode);
    _$hash = $jc(_$hash, annotations.hashCode);
    _$hash = $jc(_$hash, arMeasurements.hashCode);
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, checklistItemsSnapshot.hashCode);
    _$hash = $jc(_$hash, checklistResponses.hashCode);
    _$hash = $jc(_$hash, checklistTemplateId.hashCode);
    _$hash = $jc(_$hash, checklistTemplateVersion.hashCode);
    _$hash = $jc(_$hash, clientCreatedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inspectionType.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, readings.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, signature.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, voiceNotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InspectionDetail')
          ..add('aiAnalysis', aiAnalysis)
          ..add('annotations', annotations)
          ..add('arMeasurements', arMeasurements)
          ..add('areaId', areaId)
          ..add('assetId', assetId)
          ..add('checklistItemsSnapshot', checklistItemsSnapshot)
          ..add('checklistResponses', checklistResponses)
          ..add('checklistTemplateId', checklistTemplateId)
          ..add('checklistTemplateVersion', checklistTemplateVersion)
          ..add('clientCreatedAt', clientCreatedAt)
          ..add('completedAt', completedAt)
          ..add('createdAt', createdAt)
          ..add('deviceId', deviceId)
          ..add('facilityId', facilityId)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('inspectionType', inspectionType)
          ..add('inspectorId', inspectorId)
          ..add('media', media)
          ..add('notes', notes)
          ..add('origin', origin)
          ..add('readings', readings)
          ..add('revision', revision)
          ..add('signature', signature)
          ..add('startedAt', startedAt)
          ..add('status', status)
          ..add('title', title)
          ..add('updatedAt', updatedAt)
          ..add('voiceNotes', voiceNotes))
        .toString();
  }
}

class InspectionDetailBuilder
    implements Builder<InspectionDetail, InspectionDetailBuilder> {
  _$InspectionDetail? _$v;

  MapBuilder<String, JsonObject?>? _aiAnalysis;
  MapBuilder<String, JsonObject?> get aiAnalysis =>
      _$this._aiAnalysis ??= new MapBuilder<String, JsonObject?>();
  set aiAnalysis(MapBuilder<String, JsonObject?>? aiAnalysis) =>
      _$this._aiAnalysis = aiAnalysis;

  ListBuilder<AnnotationResponse>? _annotations;
  ListBuilder<AnnotationResponse> get annotations =>
      _$this._annotations ??= new ListBuilder<AnnotationResponse>();
  set annotations(ListBuilder<AnnotationResponse>? annotations) =>
      _$this._annotations = annotations;

  ListBuilder<BuiltMap<String, JsonObject?>>? _arMeasurements;
  ListBuilder<BuiltMap<String, JsonObject?>> get arMeasurements =>
      _$this._arMeasurements ??=
          new ListBuilder<BuiltMap<String, JsonObject?>>();
  set arMeasurements(
          ListBuilder<BuiltMap<String, JsonObject?>>? arMeasurements) =>
      _$this._arMeasurements = arMeasurements;

  String? _areaId;
  String? get areaId => _$this._areaId;
  set areaId(String? areaId) => _$this._areaId = areaId;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  ListBuilder<ChecklistTemplateItem>? _checklistItemsSnapshot;
  ListBuilder<ChecklistTemplateItem> get checklistItemsSnapshot =>
      _$this._checklistItemsSnapshot ??=
          new ListBuilder<ChecklistTemplateItem>();
  set checklistItemsSnapshot(
          ListBuilder<ChecklistTemplateItem>? checklistItemsSnapshot) =>
      _$this._checklistItemsSnapshot = checklistItemsSnapshot;

  ListBuilder<ChecklistResponse>? _checklistResponses;
  ListBuilder<ChecklistResponse> get checklistResponses =>
      _$this._checklistResponses ??= new ListBuilder<ChecklistResponse>();
  set checklistResponses(ListBuilder<ChecklistResponse>? checklistResponses) =>
      _$this._checklistResponses = checklistResponses;

  String? _checklistTemplateId;
  String? get checklistTemplateId => _$this._checklistTemplateId;
  set checklistTemplateId(String? checklistTemplateId) =>
      _$this._checklistTemplateId = checklistTemplateId;

  int? _checklistTemplateVersion;
  int? get checklistTemplateVersion => _$this._checklistTemplateVersion;
  set checklistTemplateVersion(int? checklistTemplateVersion) =>
      _$this._checklistTemplateVersion = checklistTemplateVersion;

  DateTime? _clientCreatedAt;
  DateTime? get clientCreatedAt => _$this._clientCreatedAt;
  set clientCreatedAt(DateTime? clientCreatedAt) =>
      _$this._clientCreatedAt = clientCreatedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InspectionDetailInspectionTypeEnum? _inspectionType;
  InspectionDetailInspectionTypeEnum? get inspectionType =>
      _$this._inspectionType;
  set inspectionType(InspectionDetailInspectionTypeEnum? inspectionType) =>
      _$this._inspectionType = inspectionType;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  ListBuilder<InspectionMediaResponse>? _media;
  ListBuilder<InspectionMediaResponse> get media =>
      _$this._media ??= new ListBuilder<InspectionMediaResponse>();
  set media(ListBuilder<InspectionMediaResponse>? media) =>
      _$this._media = media;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  MapBuilder<String, JsonObject?>? _readings;
  MapBuilder<String, JsonObject?> get readings =>
      _$this._readings ??= new MapBuilder<String, JsonObject?>();
  set readings(MapBuilder<String, JsonObject?>? readings) =>
      _$this._readings = readings;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  MapBuilder<String, JsonObject?>? _signature;
  MapBuilder<String, JsonObject?> get signature =>
      _$this._signature ??= new MapBuilder<String, JsonObject?>();
  set signature(MapBuilder<String, JsonObject?>? signature) =>
      _$this._signature = signature;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  InspectionDetailStatusEnum? _status;
  InspectionDetailStatusEnum? get status => _$this._status;
  set status(InspectionDetailStatusEnum? status) => _$this._status = status;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<VoiceNoteResponse>? _voiceNotes;
  ListBuilder<VoiceNoteResponse> get voiceNotes =>
      _$this._voiceNotes ??= new ListBuilder<VoiceNoteResponse>();
  set voiceNotes(ListBuilder<VoiceNoteResponse>? voiceNotes) =>
      _$this._voiceNotes = voiceNotes;

  InspectionDetailBuilder() {
    InspectionDetail._defaults(this);
  }

  InspectionDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _aiAnalysis = $v.aiAnalysis?.toBuilder();
      _annotations = $v.annotations?.toBuilder();
      _arMeasurements = $v.arMeasurements?.toBuilder();
      _areaId = $v.areaId;
      _assetId = $v.assetId;
      _checklistItemsSnapshot = $v.checklistItemsSnapshot?.toBuilder();
      _checklistResponses = $v.checklistResponses?.toBuilder();
      _checklistTemplateId = $v.checklistTemplateId;
      _checklistTemplateVersion = $v.checklistTemplateVersion;
      _clientCreatedAt = $v.clientCreatedAt;
      _completedAt = $v.completedAt;
      _createdAt = $v.createdAt;
      _deviceId = $v.deviceId;
      _facilityId = $v.facilityId;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _inspectionType = $v.inspectionType;
      _inspectorId = $v.inspectorId;
      _media = $v.media?.toBuilder();
      _notes = $v.notes;
      _origin = $v.origin;
      _readings = $v.readings?.toBuilder();
      _revision = $v.revision;
      _signature = $v.signature?.toBuilder();
      _startedAt = $v.startedAt;
      _status = $v.status;
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _voiceNotes = $v.voiceNotes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InspectionDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InspectionDetail;
  }

  @override
  void update(void Function(InspectionDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InspectionDetail build() => _build();

  _$InspectionDetail _build() {
    _$InspectionDetail _$result;
    try {
      _$result = _$v ??
          new _$InspectionDetail._(
              aiAnalysis: _aiAnalysis?.build(),
              annotations: _annotations?.build(),
              arMeasurements: _arMeasurements?.build(),
              areaId: areaId,
              assetId: BuiltValueNullFieldError.checkNotNull(
                  assetId, r'InspectionDetail', 'assetId'),
              checklistItemsSnapshot: _checklistItemsSnapshot?.build(),
              checklistResponses: _checklistResponses?.build(),
              checklistTemplateId: checklistTemplateId,
              checklistTemplateVersion: checklistTemplateVersion,
              clientCreatedAt: BuiltValueNullFieldError.checkNotNull(
                  clientCreatedAt, r'InspectionDetail', 'clientCreatedAt'),
              completedAt: completedAt,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'InspectionDetail', 'createdAt'),
              deviceId: deviceId,
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'InspectionDetail', 'facilityId'),
              gpsLat: gpsLat,
              gpsLng: gpsLng,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'InspectionDetail', 'id'),
              inspectionType: BuiltValueNullFieldError.checkNotNull(
                  inspectionType, r'InspectionDetail', 'inspectionType'),
              inspectorId: BuiltValueNullFieldError.checkNotNull(
                  inspectorId, r'InspectionDetail', 'inspectorId'),
              media: _media?.build(),
              notes: notes,
              origin: origin,
              readings: _readings?.build(),
              revision: BuiltValueNullFieldError.checkNotNull(
                  revision, r'InspectionDetail', 'revision'),
              signature: _signature?.build(),
              startedAt: startedAt,
              status: BuiltValueNullFieldError.checkNotNull(status, r'InspectionDetail', 'status'),
              title: title,
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'InspectionDetail', 'updatedAt'),
              voiceNotes: _voiceNotes?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'aiAnalysis';
        _aiAnalysis?.build();
        _$failedField = 'annotations';
        _annotations?.build();
        _$failedField = 'arMeasurements';
        _arMeasurements?.build();

        _$failedField = 'checklistItemsSnapshot';
        _checklistItemsSnapshot?.build();
        _$failedField = 'checklistResponses';
        _checklistResponses?.build();

        _$failedField = 'media';
        _media?.build();

        _$failedField = 'readings';
        _readings?.build();

        _$failedField = 'signature';
        _signature?.build();

        _$failedField = 'voiceNotes';
        _voiceNotes?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'InspectionDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
