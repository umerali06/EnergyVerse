// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inspection_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateInspectionRequestInspectionTypeEnum
    _$createInspectionRequestInspectionTypeEnum_routine =
    const CreateInspectionRequestInspectionTypeEnum._('routine');
const CreateInspectionRequestInspectionTypeEnum
    _$createInspectionRequestInspectionTypeEnum_scheduled =
    const CreateInspectionRequestInspectionTypeEnum._('scheduled');
const CreateInspectionRequestInspectionTypeEnum
    _$createInspectionRequestInspectionTypeEnum_adHoc =
    const CreateInspectionRequestInspectionTypeEnum._('adHoc');

CreateInspectionRequestInspectionTypeEnum
    _$createInspectionRequestInspectionTypeEnumValueOf(String name) {
  switch (name) {
    case 'routine':
      return _$createInspectionRequestInspectionTypeEnum_routine;
    case 'scheduled':
      return _$createInspectionRequestInspectionTypeEnum_scheduled;
    case 'adHoc':
      return _$createInspectionRequestInspectionTypeEnum_adHoc;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateInspectionRequestInspectionTypeEnum>
    _$createInspectionRequestInspectionTypeEnumValues = new BuiltSet<
        CreateInspectionRequestInspectionTypeEnum>(const <CreateInspectionRequestInspectionTypeEnum>[
  _$createInspectionRequestInspectionTypeEnum_routine,
  _$createInspectionRequestInspectionTypeEnum_scheduled,
  _$createInspectionRequestInspectionTypeEnum_adHoc,
]);

Serializer<CreateInspectionRequestInspectionTypeEnum>
    _$createInspectionRequestInspectionTypeEnumSerializer =
    new _$CreateInspectionRequestInspectionTypeEnumSerializer();

class _$CreateInspectionRequestInspectionTypeEnumSerializer
    implements PrimitiveSerializer<CreateInspectionRequestInspectionTypeEnum> {
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
    CreateInspectionRequestInspectionTypeEnum
  ];
  @override
  final String wireName = 'CreateInspectionRequestInspectionTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CreateInspectionRequestInspectionTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateInspectionRequestInspectionTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateInspectionRequestInspectionTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateInspectionRequest extends CreateInspectionRequest {
  @override
  final String assetId;
  @override
  final DateTime clientCreatedAt;
  @override
  final String? deviceId;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
  @override
  final CreateInspectionRequestInspectionTypeEnum inspectionType;
  @override
  final String? notes;
  @override
  final String? origin;
  @override
  final String? title;

  factory _$CreateInspectionRequest(
          [void Function(CreateInspectionRequestBuilder)? updates]) =>
      (new CreateInspectionRequestBuilder()..update(updates))._build();

  _$CreateInspectionRequest._(
      {required this.assetId,
      required this.clientCreatedAt,
      this.deviceId,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      required this.inspectionType,
      this.notes,
      this.origin,
      this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'CreateInspectionRequest', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        clientCreatedAt, r'CreateInspectionRequest', 'clientCreatedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'CreateInspectionRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        inspectionType, r'CreateInspectionRequest', 'inspectionType');
  }

  @override
  CreateInspectionRequest rebuild(
          void Function(CreateInspectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateInspectionRequestBuilder toBuilder() =>
      new CreateInspectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateInspectionRequest &&
        assetId == other.assetId &&
        clientCreatedAt == other.clientCreatedAt &&
        deviceId == other.deviceId &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        inspectionType == other.inspectionType &&
        notes == other.notes &&
        origin == other.origin &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, clientCreatedAt.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inspectionType.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateInspectionRequest')
          ..add('assetId', assetId)
          ..add('clientCreatedAt', clientCreatedAt)
          ..add('deviceId', deviceId)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('inspectionType', inspectionType)
          ..add('notes', notes)
          ..add('origin', origin)
          ..add('title', title))
        .toString();
  }
}

class CreateInspectionRequestBuilder
    implements
        Builder<CreateInspectionRequest, CreateInspectionRequestBuilder> {
  _$CreateInspectionRequest? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  DateTime? _clientCreatedAt;
  DateTime? get clientCreatedAt => _$this._clientCreatedAt;
  set clientCreatedAt(DateTime? clientCreatedAt) =>
      _$this._clientCreatedAt = clientCreatedAt;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateInspectionRequestInspectionTypeEnum? _inspectionType;
  CreateInspectionRequestInspectionTypeEnum? get inspectionType =>
      _$this._inspectionType;
  set inspectionType(
          CreateInspectionRequestInspectionTypeEnum? inspectionType) =>
      _$this._inspectionType = inspectionType;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  CreateInspectionRequestBuilder() {
    CreateInspectionRequest._defaults(this);
  }

  CreateInspectionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _clientCreatedAt = $v.clientCreatedAt;
      _deviceId = $v.deviceId;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _inspectionType = $v.inspectionType;
      _notes = $v.notes;
      _origin = $v.origin;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateInspectionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateInspectionRequest;
  }

  @override
  void update(void Function(CreateInspectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateInspectionRequest build() => _build();

  _$CreateInspectionRequest _build() {
    final _$result = _$v ??
        new _$CreateInspectionRequest._(
            assetId: BuiltValueNullFieldError.checkNotNull(
                assetId, r'CreateInspectionRequest', 'assetId'),
            clientCreatedAt: BuiltValueNullFieldError.checkNotNull(
                clientCreatedAt, r'CreateInspectionRequest', 'clientCreatedAt'),
            deviceId: deviceId,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateInspectionRequest', 'id'),
            inspectionType: BuiltValueNullFieldError.checkNotNull(
                inspectionType, r'CreateInspectionRequest', 'inspectionType'),
            notes: notes,
            origin: origin,
            title: title);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
