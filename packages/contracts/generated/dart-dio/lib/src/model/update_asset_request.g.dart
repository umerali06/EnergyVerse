// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_asset_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateAssetRequestCurrentStatusEnum
    _$updateAssetRequestCurrentStatusEnum_healthy =
    const UpdateAssetRequestCurrentStatusEnum._('healthy');
const UpdateAssetRequestCurrentStatusEnum
    _$updateAssetRequestCurrentStatusEnum_warning =
    const UpdateAssetRequestCurrentStatusEnum._('warning');
const UpdateAssetRequestCurrentStatusEnum
    _$updateAssetRequestCurrentStatusEnum_critical =
    const UpdateAssetRequestCurrentStatusEnum._('critical');

UpdateAssetRequestCurrentStatusEnum
    _$updateAssetRequestCurrentStatusEnumValueOf(String name) {
  switch (name) {
    case 'healthy':
      return _$updateAssetRequestCurrentStatusEnum_healthy;
    case 'warning':
      return _$updateAssetRequestCurrentStatusEnum_warning;
    case 'critical':
      return _$updateAssetRequestCurrentStatusEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateAssetRequestCurrentStatusEnum>
    _$updateAssetRequestCurrentStatusEnumValues = new BuiltSet<
        UpdateAssetRequestCurrentStatusEnum>(const <UpdateAssetRequestCurrentStatusEnum>[
  _$updateAssetRequestCurrentStatusEnum_healthy,
  _$updateAssetRequestCurrentStatusEnum_warning,
  _$updateAssetRequestCurrentStatusEnum_critical,
]);

Serializer<UpdateAssetRequestCurrentStatusEnum>
    _$updateAssetRequestCurrentStatusEnumSerializer =
    new _$UpdateAssetRequestCurrentStatusEnumSerializer();

class _$UpdateAssetRequestCurrentStatusEnumSerializer
    implements PrimitiveSerializer<UpdateAssetRequestCurrentStatusEnum> {
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
    UpdateAssetRequestCurrentStatusEnum
  ];
  @override
  final String wireName = 'UpdateAssetRequestCurrentStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateAssetRequestCurrentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateAssetRequestCurrentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateAssetRequestCurrentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateAssetRequest extends UpdateAssetRequest {
  @override
  final String? areaId;
  @override
  final String? assetTag;
  @override
  final String? category;
  @override
  final String? categoryOther;
  @override
  final UpdateAssetRequestCurrentStatusEnum? currentStatus;
  @override
  final String? description;
  @override
  final String? facilityId;
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
  final String? name;
  @override
  final String? parentAssetId;
  @override
  final String? serialNumber;

  factory _$UpdateAssetRequest(
          [void Function(UpdateAssetRequestBuilder)? updates]) =>
      (new UpdateAssetRequestBuilder()..update(updates))._build();

  _$UpdateAssetRequest._(
      {this.areaId,
      this.assetTag,
      this.category,
      this.categoryOther,
      this.currentStatus,
      this.description,
      this.facilityId,
      this.gpsLat,
      this.gpsLng,
      this.installationDate,
      this.manufacturer,
      this.model,
      this.name,
      this.parentAssetId,
      this.serialNumber})
      : super._();

  @override
  UpdateAssetRequest rebuild(
          void Function(UpdateAssetRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateAssetRequestBuilder toBuilder() =>
      new UpdateAssetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateAssetRequest &&
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
    return (newBuiltValueToStringHelper(r'UpdateAssetRequest')
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

class UpdateAssetRequestBuilder
    implements Builder<UpdateAssetRequest, UpdateAssetRequestBuilder> {
  _$UpdateAssetRequest? _$v;

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

  UpdateAssetRequestCurrentStatusEnum? _currentStatus;
  UpdateAssetRequestCurrentStatusEnum? get currentStatus =>
      _$this._currentStatus;
  set currentStatus(UpdateAssetRequestCurrentStatusEnum? currentStatus) =>
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

  UpdateAssetRequestBuilder() {
    UpdateAssetRequest._defaults(this);
  }

  UpdateAssetRequestBuilder get _$this {
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
  void replace(UpdateAssetRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateAssetRequest;
  }

  @override
  void update(void Function(UpdateAssetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateAssetRequest build() => _build();

  _$UpdateAssetRequest _build() {
    final _$result = _$v ??
        new _$UpdateAssetRequest._(
            areaId: areaId,
            assetTag: assetTag,
            category: category,
            categoryOther: categoryOther,
            currentStatus: currentStatus,
            description: description,
            facilityId: facilityId,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            installationDate: installationDate,
            manufacturer: manufacturer,
            model: model,
            name: name,
            parentAssetId: parentAssetId,
            serialNumber: serialNumber);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
