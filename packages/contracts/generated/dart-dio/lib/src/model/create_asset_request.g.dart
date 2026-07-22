// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_asset_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateAssetRequestCurrentStatusEnum
    _$createAssetRequestCurrentStatusEnum_healthy =
    const CreateAssetRequestCurrentStatusEnum._('healthy');
const CreateAssetRequestCurrentStatusEnum
    _$createAssetRequestCurrentStatusEnum_warning =
    const CreateAssetRequestCurrentStatusEnum._('warning');
const CreateAssetRequestCurrentStatusEnum
    _$createAssetRequestCurrentStatusEnum_critical =
    const CreateAssetRequestCurrentStatusEnum._('critical');

CreateAssetRequestCurrentStatusEnum
    _$createAssetRequestCurrentStatusEnumValueOf(String name) {
  switch (name) {
    case 'healthy':
      return _$createAssetRequestCurrentStatusEnum_healthy;
    case 'warning':
      return _$createAssetRequestCurrentStatusEnum_warning;
    case 'critical':
      return _$createAssetRequestCurrentStatusEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateAssetRequestCurrentStatusEnum>
    _$createAssetRequestCurrentStatusEnumValues = new BuiltSet<
        CreateAssetRequestCurrentStatusEnum>(const <CreateAssetRequestCurrentStatusEnum>[
  _$createAssetRequestCurrentStatusEnum_healthy,
  _$createAssetRequestCurrentStatusEnum_warning,
  _$createAssetRequestCurrentStatusEnum_critical,
]);

Serializer<CreateAssetRequestCurrentStatusEnum>
    _$createAssetRequestCurrentStatusEnumSerializer =
    new _$CreateAssetRequestCurrentStatusEnumSerializer();

class _$CreateAssetRequestCurrentStatusEnumSerializer
    implements PrimitiveSerializer<CreateAssetRequestCurrentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'healthy': 'Healthy',
    'warning': 'Warning',
    'critical': 'Critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Healthy': 'healthy',
    'Warning': 'warning',
    'Critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateAssetRequestCurrentStatusEnum
  ];
  @override
  final String wireName = 'CreateAssetRequestCurrentStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CreateAssetRequestCurrentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateAssetRequestCurrentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateAssetRequestCurrentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateAssetRequest extends CreateAssetRequest {
  @override
  final String? areaId;
  @override
  final String assetTag;
  @override
  final String category;
  @override
  final String? categoryOther;
  @override
  final CreateAssetRequestCurrentStatusEnum? currentStatus;
  @override
  final String? description;
  @override
  final String facilityId;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final Date? installationDate;
  @override
  final String? manufacturer;
  @override
  final String? model;
  @override
  final String name;
  @override
  final String? parentAssetId;
  @override
  final String? serialNumber;

  factory _$CreateAssetRequest(
          [void Function(CreateAssetRequestBuilder)? updates]) =>
      (new CreateAssetRequestBuilder()..update(updates))._build();

  _$CreateAssetRequest._(
      {this.areaId,
      required this.assetTag,
      required this.category,
      this.categoryOther,
      this.currentStatus,
      this.description,
      required this.facilityId,
      this.gpsLat,
      this.gpsLng,
      this.installationDate,
      this.manufacturer,
      this.model,
      required this.name,
      this.parentAssetId,
      this.serialNumber})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetTag, r'CreateAssetRequest', 'assetTag');
    BuiltValueNullFieldError.checkNotNull(
        category, r'CreateAssetRequest', 'category');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'CreateAssetRequest', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(name, r'CreateAssetRequest', 'name');
  }

  @override
  CreateAssetRequest rebuild(
          void Function(CreateAssetRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAssetRequestBuilder toBuilder() =>
      new CreateAssetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAssetRequest &&
        areaId == other.areaId &&
        assetTag == other.assetTag &&
        category == other.category &&
        categoryOther == other.categoryOther &&
        currentStatus == other.currentStatus &&
        description == other.description &&
        facilityId == other.facilityId &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        installationDate == other.installationDate &&
        manufacturer == other.manufacturer &&
        model == other.model &&
        name == other.name &&
        parentAssetId == other.parentAssetId &&
        serialNumber == other.serialNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetTag.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, categoryOther.hashCode);
    _$hash = $jc(_$hash, currentStatus.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, installationDate.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentAssetId.hashCode);
    _$hash = $jc(_$hash, serialNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAssetRequest')
          ..add('areaId', areaId)
          ..add('assetTag', assetTag)
          ..add('category', category)
          ..add('categoryOther', categoryOther)
          ..add('currentStatus', currentStatus)
          ..add('description', description)
          ..add('facilityId', facilityId)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('installationDate', installationDate)
          ..add('manufacturer', manufacturer)
          ..add('model', model)
          ..add('name', name)
          ..add('parentAssetId', parentAssetId)
          ..add('serialNumber', serialNumber))
        .toString();
  }
}

class CreateAssetRequestBuilder
    implements Builder<CreateAssetRequest, CreateAssetRequestBuilder> {
  _$CreateAssetRequest? _$v;

  String? _areaId;
  String? get areaId => _$this._areaId;
  set areaId(String? areaId) => _$this._areaId = areaId;

  String? _assetTag;
  String? get assetTag => _$this._assetTag;
  set assetTag(String? assetTag) => _$this._assetTag = assetTag;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _categoryOther;
  String? get categoryOther => _$this._categoryOther;
  set categoryOther(String? categoryOther) =>
      _$this._categoryOther = categoryOther;

  CreateAssetRequestCurrentStatusEnum? _currentStatus;
  CreateAssetRequestCurrentStatusEnum? get currentStatus =>
      _$this._currentStatus;
  set currentStatus(CreateAssetRequestCurrentStatusEnum? currentStatus) =>
      _$this._currentStatus = currentStatus;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  Date? _installationDate;
  Date? get installationDate => _$this._installationDate;
  set installationDate(Date? installationDate) =>
      _$this._installationDate = installationDate;

  String? _manufacturer;
  String? get manufacturer => _$this._manufacturer;
  set manufacturer(String? manufacturer) => _$this._manufacturer = manufacturer;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentAssetId;
  String? get parentAssetId => _$this._parentAssetId;
  set parentAssetId(String? parentAssetId) =>
      _$this._parentAssetId = parentAssetId;

  String? _serialNumber;
  String? get serialNumber => _$this._serialNumber;
  set serialNumber(String? serialNumber) => _$this._serialNumber = serialNumber;

  CreateAssetRequestBuilder() {
    CreateAssetRequest._defaults(this);
  }

  CreateAssetRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _areaId = $v.areaId;
      _assetTag = $v.assetTag;
      _category = $v.category;
      _categoryOther = $v.categoryOther;
      _currentStatus = $v.currentStatus;
      _description = $v.description;
      _facilityId = $v.facilityId;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _installationDate = $v.installationDate;
      _manufacturer = $v.manufacturer;
      _model = $v.model;
      _name = $v.name;
      _parentAssetId = $v.parentAssetId;
      _serialNumber = $v.serialNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAssetRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAssetRequest;
  }

  @override
  void update(void Function(CreateAssetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAssetRequest build() => _build();

  _$CreateAssetRequest _build() {
    final _$result = _$v ??
        new _$CreateAssetRequest._(
            areaId: areaId,
            assetTag: BuiltValueNullFieldError.checkNotNull(
                assetTag, r'CreateAssetRequest', 'assetTag'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'CreateAssetRequest', 'category'),
            categoryOther: categoryOther,
            currentStatus: currentStatus,
            description: description,
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'CreateAssetRequest', 'facilityId'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            installationDate: installationDate,
            manufacturer: manufacturer,
            model: model,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateAssetRequest', 'name'),
            parentAssetId: parentAssetId,
            serialNumber: serialNumber);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
