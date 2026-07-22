// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssetDetailCurrentStatusEnum _$assetDetailCurrentStatusEnum_healthy =
    const AssetDetailCurrentStatusEnum._('healthy');
const AssetDetailCurrentStatusEnum _$assetDetailCurrentStatusEnum_warning =
    const AssetDetailCurrentStatusEnum._('warning');
const AssetDetailCurrentStatusEnum _$assetDetailCurrentStatusEnum_critical =
    const AssetDetailCurrentStatusEnum._('critical');

AssetDetailCurrentStatusEnum _$assetDetailCurrentStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'healthy':
      return _$assetDetailCurrentStatusEnum_healthy;
    case 'warning':
      return _$assetDetailCurrentStatusEnum_warning;
    case 'critical':
      return _$assetDetailCurrentStatusEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AssetDetailCurrentStatusEnum>
    _$assetDetailCurrentStatusEnumValues = new BuiltSet<
        AssetDetailCurrentStatusEnum>(const <AssetDetailCurrentStatusEnum>[
  _$assetDetailCurrentStatusEnum_healthy,
  _$assetDetailCurrentStatusEnum_warning,
  _$assetDetailCurrentStatusEnum_critical,
]);

Serializer<AssetDetailCurrentStatusEnum>
    _$assetDetailCurrentStatusEnumSerializer =
    new _$AssetDetailCurrentStatusEnumSerializer();

class _$AssetDetailCurrentStatusEnumSerializer
    implements PrimitiveSerializer<AssetDetailCurrentStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AssetDetailCurrentStatusEnum];
  @override
  final String wireName = 'AssetDetailCurrentStatusEnum';

  @override
  Object serialize(Serializers serializers, AssetDetailCurrentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssetDetailCurrentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssetDetailCurrentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssetDetail extends AssetDetail {
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
  final AssetDetailCurrentStatusEnum currentStatus;
  @override
  final String? description;
  @override
  final BuiltList<String>? documents;
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
  final BuiltList<String>? manuals;
  @override
  final String? manufacturer;
  @override
  final String? model;
  @override
  final String? model3dUrl;
  @override
  final String name;
  @override
  final String? parentAssetId;
  @override
  final BuiltList<String>? photos;
  @override
  final String? qrCodeId;
  @override
  final String? serialNumber;
  @override
  final DateTime updatedAt;

  factory _$AssetDetail([void Function(AssetDetailBuilder)? updates]) =>
      (new AssetDetailBuilder()..update(updates))._build();

  _$AssetDetail._(
      {this.areaId,
      required this.assetTag,
      required this.category,
      this.categoryOther,
      required this.createdAt,
      required this.currentStatus,
      this.description,
      this.documents,
      required this.facilityId,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      this.installationDate,
      this.manuals,
      this.manufacturer,
      this.model,
      this.model3dUrl,
      required this.name,
      this.parentAssetId,
      this.photos,
      this.qrCodeId,
      this.serialNumber,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(assetTag, r'AssetDetail', 'assetTag');
    BuiltValueNullFieldError.checkNotNull(category, r'AssetDetail', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AssetDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        currentStatus, r'AssetDetail', 'currentStatus');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'AssetDetail', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'AssetDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'AssetDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'AssetDetail', 'updatedAt');
  }

  @override
  AssetDetail rebuild(void Function(AssetDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetDetailBuilder toBuilder() => new AssetDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetDetail &&
        areaId == other.areaId &&
        assetTag == other.assetTag &&
        category == other.category &&
        categoryOther == other.categoryOther &&
        createdAt == other.createdAt &&
        currentStatus == other.currentStatus &&
        description == other.description &&
        documents == other.documents &&
        facilityId == other.facilityId &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        installationDate == other.installationDate &&
        manuals == other.manuals &&
        manufacturer == other.manufacturer &&
        model == other.model &&
        model3dUrl == other.model3dUrl &&
        name == other.name &&
        parentAssetId == other.parentAssetId &&
        photos == other.photos &&
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
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, installationDate.hashCode);
    _$hash = $jc(_$hash, manuals.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, model3dUrl.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentAssetId.hashCode);
    _$hash = $jc(_$hash, photos.hashCode);
    _$hash = $jc(_$hash, qrCodeId.hashCode);
    _$hash = $jc(_$hash, serialNumber.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetDetail')
          ..add('areaId', areaId)
          ..add('assetTag', assetTag)
          ..add('category', category)
          ..add('categoryOther', categoryOther)
          ..add('createdAt', createdAt)
          ..add('currentStatus', currentStatus)
          ..add('description', description)
          ..add('documents', documents)
          ..add('facilityId', facilityId)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('installationDate', installationDate)
          ..add('manuals', manuals)
          ..add('manufacturer', manufacturer)
          ..add('model', model)
          ..add('model3dUrl', model3dUrl)
          ..add('name', name)
          ..add('parentAssetId', parentAssetId)
          ..add('photos', photos)
          ..add('qrCodeId', qrCodeId)
          ..add('serialNumber', serialNumber)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AssetDetailBuilder implements Builder<AssetDetail, AssetDetailBuilder> {
  _$AssetDetail? _$v;

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

  AssetDetailCurrentStatusEnum? _currentStatus;
  AssetDetailCurrentStatusEnum? get currentStatus => _$this._currentStatus;
  set currentStatus(AssetDetailCurrentStatusEnum? currentStatus) =>
      _$this._currentStatus = currentStatus;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<String>? _documents;
  ListBuilder<String> get documents =>
      _$this._documents ??= new ListBuilder<String>();
  set documents(ListBuilder<String>? documents) =>
      _$this._documents = documents;

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

  ListBuilder<String>? _manuals;
  ListBuilder<String> get manuals =>
      _$this._manuals ??= new ListBuilder<String>();
  set manuals(ListBuilder<String>? manuals) => _$this._manuals = manuals;

  String? _manufacturer;
  String? get manufacturer => _$this._manufacturer;
  set manufacturer(String? manufacturer) => _$this._manufacturer = manufacturer;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _model3dUrl;
  String? get model3dUrl => _$this._model3dUrl;
  set model3dUrl(String? model3dUrl) => _$this._model3dUrl = model3dUrl;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentAssetId;
  String? get parentAssetId => _$this._parentAssetId;
  set parentAssetId(String? parentAssetId) =>
      _$this._parentAssetId = parentAssetId;

  ListBuilder<String>? _photos;
  ListBuilder<String> get photos =>
      _$this._photos ??= new ListBuilder<String>();
  set photos(ListBuilder<String>? photos) => _$this._photos = photos;

  String? _qrCodeId;
  String? get qrCodeId => _$this._qrCodeId;
  set qrCodeId(String? qrCodeId) => _$this._qrCodeId = qrCodeId;

  String? _serialNumber;
  String? get serialNumber => _$this._serialNumber;
  set serialNumber(String? serialNumber) => _$this._serialNumber = serialNumber;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AssetDetailBuilder() {
    AssetDetail._defaults(this);
  }

  AssetDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _areaId = $v.areaId;
      _assetTag = $v.assetTag;
      _category = $v.category;
      _categoryOther = $v.categoryOther;
      _createdAt = $v.createdAt;
      _currentStatus = $v.currentStatus;
      _description = $v.description;
      _documents = $v.documents?.toBuilder();
      _facilityId = $v.facilityId;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _installationDate = $v.installationDate;
      _manuals = $v.manuals?.toBuilder();
      _manufacturer = $v.manufacturer;
      _model = $v.model;
      _model3dUrl = $v.model3dUrl;
      _name = $v.name;
      _parentAssetId = $v.parentAssetId;
      _photos = $v.photos?.toBuilder();
      _qrCodeId = $v.qrCodeId;
      _serialNumber = $v.serialNumber;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetDetail;
  }

  @override
  void update(void Function(AssetDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetDetail build() => _build();

  _$AssetDetail _build() {
    _$AssetDetail _$result;
    try {
      _$result = _$v ??
          new _$AssetDetail._(
              areaId: areaId,
              assetTag: BuiltValueNullFieldError.checkNotNull(
                  assetTag, r'AssetDetail', 'assetTag'),
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'AssetDetail', 'category'),
              categoryOther: categoryOther,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'AssetDetail', 'createdAt'),
              currentStatus: BuiltValueNullFieldError.checkNotNull(
                  currentStatus, r'AssetDetail', 'currentStatus'),
              description: description,
              documents: _documents?.build(),
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'AssetDetail', 'facilityId'),
              gpsLat: gpsLat,
              gpsLng: gpsLng,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'AssetDetail', 'id'),
              installationDate: installationDate,
              manuals: _manuals?.build(),
              manufacturer: manufacturer,
              model: model,
              model3dUrl: model3dUrl,
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'AssetDetail', 'name'),
              parentAssetId: parentAssetId,
              photos: _photos?.build(),
              qrCodeId: qrCodeId,
              serialNumber: serialNumber,
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'AssetDetail', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        _documents?.build();

        _$failedField = 'manuals';
        _manuals?.build();

        _$failedField = 'photos';
        _photos?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AssetDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
