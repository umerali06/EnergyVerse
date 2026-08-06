// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inspection_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateInspectionRequestInspectionTypeEnum
    _$updateInspectionRequestInspectionTypeEnum_routine =
    const UpdateInspectionRequestInspectionTypeEnum._('routine');
const UpdateInspectionRequestInspectionTypeEnum
    _$updateInspectionRequestInspectionTypeEnum_scheduled =
    const UpdateInspectionRequestInspectionTypeEnum._('scheduled');
const UpdateInspectionRequestInspectionTypeEnum
    _$updateInspectionRequestInspectionTypeEnum_adHoc =
    const UpdateInspectionRequestInspectionTypeEnum._('adHoc');

UpdateInspectionRequestInspectionTypeEnum
    _$updateInspectionRequestInspectionTypeEnumValueOf(String name) {
  switch (name) {
    case 'routine':
      return _$updateInspectionRequestInspectionTypeEnum_routine;
    case 'scheduled':
      return _$updateInspectionRequestInspectionTypeEnum_scheduled;
    case 'adHoc':
      return _$updateInspectionRequestInspectionTypeEnum_adHoc;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateInspectionRequestInspectionTypeEnum>
    _$updateInspectionRequestInspectionTypeEnumValues = new BuiltSet<
        UpdateInspectionRequestInspectionTypeEnum>(const <UpdateInspectionRequestInspectionTypeEnum>[
  _$updateInspectionRequestInspectionTypeEnum_routine,
  _$updateInspectionRequestInspectionTypeEnum_scheduled,
  _$updateInspectionRequestInspectionTypeEnum_adHoc,
]);

Serializer<UpdateInspectionRequestInspectionTypeEnum>
    _$updateInspectionRequestInspectionTypeEnumSerializer =
    new _$UpdateInspectionRequestInspectionTypeEnumSerializer();

class _$UpdateInspectionRequestInspectionTypeEnumSerializer
    implements PrimitiveSerializer<UpdateInspectionRequestInspectionTypeEnum> {
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
    UpdateInspectionRequestInspectionTypeEnum
  ];
  @override
  final String wireName = 'UpdateInspectionRequestInspectionTypeEnum';

  @override
  Object serialize(Serializers serializers,
          UpdateInspectionRequestInspectionTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateInspectionRequestInspectionTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateInspectionRequestInspectionTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateInspectionRequest extends UpdateInspectionRequest {
  @override
  final BuiltList<ChecklistResponse>? checklistResponses;
  @override
  final int? expectedRevision;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final UpdateInspectionRequestInspectionTypeEnum? inspectionType;
  @override
  final String? notes;
  @override
  final ReadingsInput? readings;
  @override
  final String? title;

  factory _$UpdateInspectionRequest(
          [void Function(UpdateInspectionRequestBuilder)? updates]) =>
      (new UpdateInspectionRequestBuilder()..update(updates))._build();

  _$UpdateInspectionRequest._(
      {this.checklistResponses,
      this.expectedRevision,
      this.gpsLat,
      this.gpsLng,
      this.inspectionType,
      this.notes,
      this.readings,
      this.title})
      : super._();

  @override
  UpdateInspectionRequest rebuild(
          void Function(UpdateInspectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateInspectionRequestBuilder toBuilder() =>
      new UpdateInspectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateInspectionRequest &&
        checklistResponses == other.checklistResponses &&
        expectedRevision == other.expectedRevision &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        inspectionType == other.inspectionType &&
        notes == other.notes &&
        readings == other.readings &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistResponses.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, inspectionType.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, readings.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateInspectionRequest')
          ..add('checklistResponses', checklistResponses)
          ..add('expectedRevision', expectedRevision)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('inspectionType', inspectionType)
          ..add('notes', notes)
          ..add('readings', readings)
          ..add('title', title))
        .toString();
  }
}

class UpdateInspectionRequestBuilder
    implements
        Builder<UpdateInspectionRequest, UpdateInspectionRequestBuilder> {
  _$UpdateInspectionRequest? _$v;

  ListBuilder<ChecklistResponse>? _checklistResponses;
  ListBuilder<ChecklistResponse> get checklistResponses =>
      _$this._checklistResponses ??= new ListBuilder<ChecklistResponse>();
  set checklistResponses(ListBuilder<ChecklistResponse>? checklistResponses) =>
      _$this._checklistResponses = checklistResponses;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  UpdateInspectionRequestInspectionTypeEnum? _inspectionType;
  UpdateInspectionRequestInspectionTypeEnum? get inspectionType =>
      _$this._inspectionType;
  set inspectionType(
          UpdateInspectionRequestInspectionTypeEnum? inspectionType) =>
      _$this._inspectionType = inspectionType;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ReadingsInputBuilder? _readings;
  ReadingsInputBuilder get readings =>
      _$this._readings ??= new ReadingsInputBuilder();
  set readings(ReadingsInputBuilder? readings) => _$this._readings = readings;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  UpdateInspectionRequestBuilder() {
    UpdateInspectionRequest._defaults(this);
  }

  UpdateInspectionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistResponses = $v.checklistResponses?.toBuilder();
      _expectedRevision = $v.expectedRevision;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _inspectionType = $v.inspectionType;
      _notes = $v.notes;
      _readings = $v.readings?.toBuilder();
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateInspectionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateInspectionRequest;
  }

  @override
  void update(void Function(UpdateInspectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateInspectionRequest build() => _build();

  _$UpdateInspectionRequest _build() {
    _$UpdateInspectionRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateInspectionRequest._(
              checklistResponses: _checklistResponses?.build(),
              expectedRevision: expectedRevision,
              gpsLat: gpsLat,
              gpsLng: gpsLng,
              inspectionType: inspectionType,
              notes: notes,
              readings: _readings?.build(),
              title: title);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'checklistResponses';
        _checklistResponses?.build();

        _$failedField = 'readings';
        _readings?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateInspectionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
