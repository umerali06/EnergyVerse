// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FacilityDetailStatusEnum _$facilityDetailStatusEnum_active =
    const FacilityDetailStatusEnum._('active');
const FacilityDetailStatusEnum _$facilityDetailStatusEnum_inactive =
    const FacilityDetailStatusEnum._('inactive');

FacilityDetailStatusEnum _$facilityDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$facilityDetailStatusEnum_active;
    case 'inactive':
      return _$facilityDetailStatusEnum_inactive;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<FacilityDetailStatusEnum> _$facilityDetailStatusEnumValues =
    new BuiltSet<FacilityDetailStatusEnum>(const <FacilityDetailStatusEnum>[
  _$facilityDetailStatusEnum_active,
  _$facilityDetailStatusEnum_inactive,
]);

Serializer<FacilityDetailStatusEnum> _$facilityDetailStatusEnumSerializer =
    new _$FacilityDetailStatusEnumSerializer();

class _$FacilityDetailStatusEnumSerializer
    implements PrimitiveSerializer<FacilityDetailStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[FacilityDetailStatusEnum];
  @override
  final String wireName = 'FacilityDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, FacilityDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FacilityDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FacilityDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FacilityDetail extends FacilityDetail {
  @override
  final String? address;
  @override
  final DateTime createdAt;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
  @override
  final String name;
  @override
  final String? sector;
  @override
  final FacilityDetailStatusEnum status;
  @override
  final String timezone;
  @override
  final DateTime updatedAt;

  factory _$FacilityDetail([void Function(FacilityDetailBuilder)? updates]) =>
      (new FacilityDetailBuilder()..update(updates))._build();

  _$FacilityDetail._(
      {this.address,
      required this.createdAt,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      required this.name,
      this.sector,
      required this.status,
      required this.timezone,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'FacilityDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'FacilityDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'FacilityDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(status, r'FacilityDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        timezone, r'FacilityDetail', 'timezone');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'FacilityDetail', 'updatedAt');
  }

  @override
  FacilityDetail rebuild(void Function(FacilityDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityDetailBuilder toBuilder() =>
      new FacilityDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FacilityDetail &&
        address == other.address &&
        createdAt == other.createdAt &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        name == other.name &&
        sector == other.sector &&
        status == other.status &&
        timezone == other.timezone &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sector.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FacilityDetail')
          ..add('address', address)
          ..add('createdAt', createdAt)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('name', name)
          ..add('sector', sector)
          ..add('status', status)
          ..add('timezone', timezone)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class FacilityDetailBuilder
    implements Builder<FacilityDetail, FacilityDetailBuilder> {
  _$FacilityDetail? _$v;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sector;
  String? get sector => _$this._sector;
  set sector(String? sector) => _$this._sector = sector;

  FacilityDetailStatusEnum? _status;
  FacilityDetailStatusEnum? get status => _$this._status;
  set status(FacilityDetailStatusEnum? status) => _$this._status = status;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  FacilityDetailBuilder() {
    FacilityDetail._defaults(this);
  }

  FacilityDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _address = $v.address;
      _createdAt = $v.createdAt;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _name = $v.name;
      _sector = $v.sector;
      _status = $v.status;
      _timezone = $v.timezone;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FacilityDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FacilityDetail;
  }

  @override
  void update(void Function(FacilityDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FacilityDetail build() => _build();

  _$FacilityDetail _build() {
    final _$result = _$v ??
        new _$FacilityDetail._(
            address: address,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'FacilityDetail', 'createdAt'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FacilityDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'FacilityDetail', 'name'),
            sector: sector,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'FacilityDetail', 'status'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'FacilityDetail', 'timezone'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'FacilityDetail', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
