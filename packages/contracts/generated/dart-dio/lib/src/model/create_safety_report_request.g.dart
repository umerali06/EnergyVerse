// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_safety_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_nearMiss =
    const CreateSafetyReportRequestCategoryEnum._('nearMiss');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_unsafeCondition =
    const CreateSafetyReportRequestCategoryEnum._('unsafeCondition');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_unsafeBehavior =
    const CreateSafetyReportRequestCategoryEnum._('unsafeBehavior');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_fire =
    const CreateSafetyReportRequestCategoryEnum._('fire');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_gasLeak =
    const CreateSafetyReportRequestCategoryEnum._('gasLeak');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_chemicalSpill =
    const CreateSafetyReportRequestCategoryEnum._('chemicalSpill');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_environmentalIncident =
    const CreateSafetyReportRequestCategoryEnum._('environmentalIncident');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_equipmentFailure =
    const CreateSafetyReportRequestCategoryEnum._('equipmentFailure');
const CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnum_injury =
    const CreateSafetyReportRequestCategoryEnum._('injury');

CreateSafetyReportRequestCategoryEnum
    _$createSafetyReportRequestCategoryEnumValueOf(String name) {
  switch (name) {
    case 'nearMiss':
      return _$createSafetyReportRequestCategoryEnum_nearMiss;
    case 'unsafeCondition':
      return _$createSafetyReportRequestCategoryEnum_unsafeCondition;
    case 'unsafeBehavior':
      return _$createSafetyReportRequestCategoryEnum_unsafeBehavior;
    case 'fire':
      return _$createSafetyReportRequestCategoryEnum_fire;
    case 'gasLeak':
      return _$createSafetyReportRequestCategoryEnum_gasLeak;
    case 'chemicalSpill':
      return _$createSafetyReportRequestCategoryEnum_chemicalSpill;
    case 'environmentalIncident':
      return _$createSafetyReportRequestCategoryEnum_environmentalIncident;
    case 'equipmentFailure':
      return _$createSafetyReportRequestCategoryEnum_equipmentFailure;
    case 'injury':
      return _$createSafetyReportRequestCategoryEnum_injury;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateSafetyReportRequestCategoryEnum>
    _$createSafetyReportRequestCategoryEnumValues = new BuiltSet<
        CreateSafetyReportRequestCategoryEnum>(const <CreateSafetyReportRequestCategoryEnum>[
  _$createSafetyReportRequestCategoryEnum_nearMiss,
  _$createSafetyReportRequestCategoryEnum_unsafeCondition,
  _$createSafetyReportRequestCategoryEnum_unsafeBehavior,
  _$createSafetyReportRequestCategoryEnum_fire,
  _$createSafetyReportRequestCategoryEnum_gasLeak,
  _$createSafetyReportRequestCategoryEnum_chemicalSpill,
  _$createSafetyReportRequestCategoryEnum_environmentalIncident,
  _$createSafetyReportRequestCategoryEnum_equipmentFailure,
  _$createSafetyReportRequestCategoryEnum_injury,
]);

const CreateSafetyReportRequestSeverityEnum
    _$createSafetyReportRequestSeverityEnum_low =
    const CreateSafetyReportRequestSeverityEnum._('low');
const CreateSafetyReportRequestSeverityEnum
    _$createSafetyReportRequestSeverityEnum_medium =
    const CreateSafetyReportRequestSeverityEnum._('medium');
const CreateSafetyReportRequestSeverityEnum
    _$createSafetyReportRequestSeverityEnum_high =
    const CreateSafetyReportRequestSeverityEnum._('high');
const CreateSafetyReportRequestSeverityEnum
    _$createSafetyReportRequestSeverityEnum_critical =
    const CreateSafetyReportRequestSeverityEnum._('critical');

CreateSafetyReportRequestSeverityEnum
    _$createSafetyReportRequestSeverityEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$createSafetyReportRequestSeverityEnum_low;
    case 'medium':
      return _$createSafetyReportRequestSeverityEnum_medium;
    case 'high':
      return _$createSafetyReportRequestSeverityEnum_high;
    case 'critical':
      return _$createSafetyReportRequestSeverityEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateSafetyReportRequestSeverityEnum>
    _$createSafetyReportRequestSeverityEnumValues = new BuiltSet<
        CreateSafetyReportRequestSeverityEnum>(const <CreateSafetyReportRequestSeverityEnum>[
  _$createSafetyReportRequestSeverityEnum_low,
  _$createSafetyReportRequestSeverityEnum_medium,
  _$createSafetyReportRequestSeverityEnum_high,
  _$createSafetyReportRequestSeverityEnum_critical,
]);

Serializer<CreateSafetyReportRequestCategoryEnum>
    _$createSafetyReportRequestCategoryEnumSerializer =
    new _$CreateSafetyReportRequestCategoryEnumSerializer();
Serializer<CreateSafetyReportRequestSeverityEnum>
    _$createSafetyReportRequestSeverityEnumSerializer =
    new _$CreateSafetyReportRequestSeverityEnumSerializer();

class _$CreateSafetyReportRequestCategoryEnumSerializer
    implements PrimitiveSerializer<CreateSafetyReportRequestCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nearMiss': 'near_miss',
    'unsafeCondition': 'unsafe_condition',
    'unsafeBehavior': 'unsafe_behavior',
    'fire': 'fire',
    'gasLeak': 'gas_leak',
    'chemicalSpill': 'chemical_spill',
    'environmentalIncident': 'environmental_incident',
    'equipmentFailure': 'equipment_failure',
    'injury': 'injury',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'near_miss': 'nearMiss',
    'unsafe_condition': 'unsafeCondition',
    'unsafe_behavior': 'unsafeBehavior',
    'fire': 'fire',
    'gas_leak': 'gasLeak',
    'chemical_spill': 'chemicalSpill',
    'environmental_incident': 'environmentalIncident',
    'equipment_failure': 'equipmentFailure',
    'injury': 'injury',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateSafetyReportRequestCategoryEnum
  ];
  @override
  final String wireName = 'CreateSafetyReportRequestCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, CreateSafetyReportRequestCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateSafetyReportRequestCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateSafetyReportRequestCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateSafetyReportRequestSeverityEnumSerializer
    implements PrimitiveSerializer<CreateSafetyReportRequestSeverityEnum> {
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
    CreateSafetyReportRequestSeverityEnum
  ];
  @override
  final String wireName = 'CreateSafetyReportRequestSeverityEnum';

  @override
  Object serialize(
          Serializers serializers, CreateSafetyReportRequestSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateSafetyReportRequestSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateSafetyReportRequestSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateSafetyReportRequest extends CreateSafetyReportRequest {
  @override
  final CreateSafetyReportRequestCategoryEnum category;
  @override
  final String description;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
  @override
  final DateTime occurredAt;
  @override
  final CreateSafetyReportRequestSeverityEnum severity;
  @override
  final String title;

  factory _$CreateSafetyReportRequest(
          [void Function(CreateSafetyReportRequestBuilder)? updates]) =>
      (new CreateSafetyReportRequestBuilder()..update(updates))._build();

  _$CreateSafetyReportRequest._(
      {required this.category,
      required this.description,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      required this.occurredAt,
      required this.severity,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'CreateSafetyReportRequest', 'category');
    BuiltValueNullFieldError.checkNotNull(
        description, r'CreateSafetyReportRequest', 'description');
    BuiltValueNullFieldError.checkNotNull(
        id, r'CreateSafetyReportRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        occurredAt, r'CreateSafetyReportRequest', 'occurredAt');
    BuiltValueNullFieldError.checkNotNull(
        severity, r'CreateSafetyReportRequest', 'severity');
    BuiltValueNullFieldError.checkNotNull(
        title, r'CreateSafetyReportRequest', 'title');
  }

  @override
  CreateSafetyReportRequest rebuild(
          void Function(CreateSafetyReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateSafetyReportRequestBuilder toBuilder() =>
      new CreateSafetyReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateSafetyReportRequest &&
        category == other.category &&
        description == other.description &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        occurredAt == other.occurredAt &&
        severity == other.severity &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateSafetyReportRequest')
          ..add('category', category)
          ..add('description', description)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('occurredAt', occurredAt)
          ..add('severity', severity)
          ..add('title', title))
        .toString();
  }
}

class CreateSafetyReportRequestBuilder
    implements
        Builder<CreateSafetyReportRequest, CreateSafetyReportRequestBuilder> {
  _$CreateSafetyReportRequest? _$v;

  CreateSafetyReportRequestCategoryEnum? _category;
  CreateSafetyReportRequestCategoryEnum? get category => _$this._category;
  set category(CreateSafetyReportRequestCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  CreateSafetyReportRequestSeverityEnum? _severity;
  CreateSafetyReportRequestSeverityEnum? get severity => _$this._severity;
  set severity(CreateSafetyReportRequestSeverityEnum? severity) =>
      _$this._severity = severity;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  CreateSafetyReportRequestBuilder() {
    CreateSafetyReportRequest._defaults(this);
  }

  CreateSafetyReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _description = $v.description;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _occurredAt = $v.occurredAt;
      _severity = $v.severity;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateSafetyReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateSafetyReportRequest;
  }

  @override
  void update(void Function(CreateSafetyReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateSafetyReportRequest build() => _build();

  _$CreateSafetyReportRequest _build() {
    final _$result = _$v ??
        new _$CreateSafetyReportRequest._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'CreateSafetyReportRequest', 'category'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'CreateSafetyReportRequest', 'description'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateSafetyReportRequest', 'id'),
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'CreateSafetyReportRequest', 'occurredAt'),
            severity: BuiltValueNullFieldError.checkNotNull(
                severity, r'CreateSafetyReportRequest', 'severity'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'CreateSafetyReportRequest', 'title'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
