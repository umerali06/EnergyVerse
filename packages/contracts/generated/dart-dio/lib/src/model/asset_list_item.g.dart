// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssetListItemCurrentStatusEnum _$assetListItemCurrentStatusEnum_healthy =
    const AssetListItemCurrentStatusEnum._('healthy');
const AssetListItemCurrentStatusEnum _$assetListItemCurrentStatusEnum_warning =
    const AssetListItemCurrentStatusEnum._('warning');
const AssetListItemCurrentStatusEnum _$assetListItemCurrentStatusEnum_critical =
    const AssetListItemCurrentStatusEnum._('critical');

AssetListItemCurrentStatusEnum _$assetListItemCurrentStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'healthy':
      return _$assetListItemCurrentStatusEnum_healthy;
    case 'warning':
      return _$assetListItemCurrentStatusEnum_warning;
    case 'critical':
      return _$assetListItemCurrentStatusEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AssetListItemCurrentStatusEnum>
    _$assetListItemCurrentStatusEnumValues = new BuiltSet<
        AssetListItemCurrentStatusEnum>(const <AssetListItemCurrentStatusEnum>[
  _$assetListItemCurrentStatusEnum_healthy,
  _$assetListItemCurrentStatusEnum_warning,
  _$assetListItemCurrentStatusEnum_critical,
]);

Serializer<AssetListItemCurrentStatusEnum>
    _$assetListItemCurrentStatusEnumSerializer =
    new _$AssetListItemCurrentStatusEnumSerializer();

class _$AssetListItemCurrentStatusEnumSerializer
    implements PrimitiveSerializer<AssetListItemCurrentStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AssetListItemCurrentStatusEnum];
  @override
  final String wireName = 'AssetListItemCurrentStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AssetListItemCurrentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssetListItemCurrentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssetListItemCurrentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssetListItem extends AssetListItem {
  @override
  final String? areaId;
  @override
  final String assetTag;
  @override
  final String category;
  @override
  final String? categoryOther;
  @override
  final DateTime createdAt;
  @override
  final AssetListItemCurrentStatusEnum currentStatus;
  @override
  final String facilityId;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
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
  final String? qrCodeId;
  @override
  final String? serialNumber;
  @override
  final DateTime updatedAt;

  factory _$AssetListItem([void Function(AssetListItemBuilder)? updates]) =>
      (new AssetListItemBuilder()..update(updates))._build();

  _$AssetListItem._(
      {this.areaId,
      required this.assetTag,
      required this.category,
      this.categoryOther,
      required this.createdAt,
      required this.currentStatus,
      required this.facilityId,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      this.installationDate,
      this.manufacturer,
      this.model,
      required this.name,
      this.parentAssetId,
      this.qrCodeId,
      this.serialNumber,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetTag, r'AssetListItem', 'assetTag');
    BuiltValueNullFieldError.checkNotNull(
        category, r'AssetListItem', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AssetListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        currentStatus, r'AssetListItem', 'currentStatus');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'AssetListItem', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'AssetListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'AssetListItem', 'name');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'AssetListItem', 'updatedAt');
  }

  @override
  AssetListItem rebuild(void Function(AssetListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetListItemBuilder toBuilder() => new AssetListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetListItem &&
        areaId == other.areaId &&
        assetTag == other.assetTag &&
        category == other.category &&
        categoryOther == other.categoryOther &&
        createdAt == other.createdAt &&
        currentStatus == other.currentStatus &&
        facilityId == other.facilityId &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        installationDate == other.installationDate &&
        manufacturer == other.manufacturer &&
        model == other.model &&
        name == other.name &&
        parentAssetId == other.parentAssetId &&
        qrCodeId == other.qrCodeId &&
        serialNumber == other.serialNumber &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetTag.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, categoryOther.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, currentStatus.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, installationDate.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentAssetId.hashCode);
    _$hash = $jc(_$hash, qrCodeId.hashCode);
    _$hash = $jc(_$hash, serialNumber.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetListItem')
          ..add('areaId', areaId)
          ..add('assetTag', assetTag)
          ..add('category', category)
          ..add('categoryOther', categoryOther)
          ..add('createdAt', createdAt)
          ..add('currentStatus', currentStatus)
          ..add('facilityId', facilityId)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('installationDate', installationDate)
          ..add('manufacturer', manufacturer)
          ..add('model', model)
          ..add('name', name)
          ..add('parentAssetId', parentAssetId)
          ..add('qrCodeId', qrCodeId)
          ..add('serialNumber', serialNumber)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AssetListItemBuilder
    implements Builder<AssetListItem, AssetListItemBuilder> {
  _$AssetListItem? _$v;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AssetListItemCurrentStatusEnum? _currentStatus;
  AssetListItemCurrentStatusEnum? get currentStatus => _$this._currentStatus;
  set currentStatus(AssetListItemCurrentStatusEnum? currentStatus) =>
      _$this._currentStatus = currentStatus;

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

  String? _qrCodeId;
  String? get qrCodeId => _$this._qrCodeId;
  set qrCodeId(String? qrCodeId) => _$this._qrCodeId = qrCodeId;

  String? _serialNumber;
  String? get serialNumber => _$this._serialNumber;
  set serialNumber(String? serialNumber) => _$this._serialNumber = serialNumber;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AssetListItemBuilder() {
    AssetListItem._defaults(this);
  }

  AssetListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _areaId = $v.areaId;
      _assetTag = $v.assetTag;
      _category = $v.category;
      _categoryOther = $v.categoryOther;
      _createdAt = $v.createdAt;
      _currentStatus = $v.currentStatus;
      _facilityId = $v.facilityId;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _installationDate = $v.installationDate;
      _manufacturer = $v.manufacturer;
      _model = $v.model;
      _name = $v.name;
      _parentAssetId = $v.parentAssetId;
      _qrCodeId = $v.qrCodeId;
      _serialNumber = $v.serialNumber;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetListItem;
  }

  @override
  void update(void Function(AssetListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetListItem build() => _build();

  _$AssetListItem _build() {
    final _$result = _$v ??
        new _$AssetListItem._(
            areaId: areaId,
            assetTag: BuiltValueNullFieldError.checkNotNull(
                assetTag, r'AssetListItem', 'assetTag'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'AssetListItem', 'category'),
            categoryOther: categoryOther,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AssetListItem', 'createdAt'),
            currentStatus: BuiltValueNullFieldError.checkNotNull(
                currentStatus, r'AssetListItem', 'currentStatus'),
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'AssetListItem', 'facilityId'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AssetListItem', 'id'),
            installationDate: installationDate,
            manufacturer: manufacturer,
            model: model,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AssetListItem', 'name'),
            parentAssetId: parentAssetId,
            qrCodeId: qrCodeId,
            serialNumber: serialNumber,
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'AssetListItem', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
