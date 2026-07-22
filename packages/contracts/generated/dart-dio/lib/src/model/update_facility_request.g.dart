// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_facility_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateFacilityRequestStatusEnum _$updateFacilityRequestStatusEnum_active =
    const UpdateFacilityRequestStatusEnum._('active');
const UpdateFacilityRequestStatusEnum
    _$updateFacilityRequestStatusEnum_inactive =
    const UpdateFacilityRequestStatusEnum._('inactive');

UpdateFacilityRequestStatusEnum _$updateFacilityRequestStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'active':
      return _$updateFacilityRequestStatusEnum_active;
    case 'inactive':
      return _$updateFacilityRequestStatusEnum_inactive;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateFacilityRequestStatusEnum>
    _$updateFacilityRequestStatusEnumValues = new BuiltSet<
        UpdateFacilityRequestStatusEnum>(const <UpdateFacilityRequestStatusEnum>[
  _$updateFacilityRequestStatusEnum_active,
  _$updateFacilityRequestStatusEnum_inactive,
]);

Serializer<UpdateFacilityRequestStatusEnum>
    _$updateFacilityRequestStatusEnumSerializer =
    new _$UpdateFacilityRequestStatusEnumSerializer();

class _$UpdateFacilityRequestStatusEnumSerializer
    implements PrimitiveSerializer<UpdateFacilityRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[UpdateFacilityRequestStatusEnum];
  @override
  final String wireName = 'UpdateFacilityRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateFacilityRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateFacilityRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateFacilityRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateFacilityRequest extends UpdateFacilityRequest {
  @override
  final String? address;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String? name;
  @override
  final String? sector;
  @override
  final UpdateFacilityRequestStatusEnum? status;
  @override
  final String? timezone;

  factory _$UpdateFacilityRequest(
          [void Function(UpdateFacilityRequestBuilder)? updates]) =>
      (new UpdateFacilityRequestBuilder()..update(updates))._build();

  _$UpdateFacilityRequest._(
      {this.address,
      this.gpsLat,
      this.gpsLng,
      this.name,
      this.sector,
      this.status,
      this.timezone})
      : super._();

  @override
  UpdateFacilityRequest rebuild(
          void Function(UpdateFacilityRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateFacilityRequestBuilder toBuilder() =>
      new UpdateFacilityRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateFacilityRequest &&
        address == other.address &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        name == other.name &&
        sector == other.sector &&
        status == other.status &&
        timezone == other.timezone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sector.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateFacilityRequest')
          ..add('address', address)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('name', name)
          ..add('sector', sector)
          ..add('status', status)
          ..add('timezone', timezone))
        .toString();
  }
}

class UpdateFacilityRequestBuilder
    implements Builder<UpdateFacilityRequest, UpdateFacilityRequestBuilder> {
  _$UpdateFacilityRequest? _$v;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sector;
  String? get sector => _$this._sector;
  set sector(String? sector) => _$this._sector = sector;

  UpdateFacilityRequestStatusEnum? _status;
  UpdateFacilityRequestStatusEnum? get status => _$this._status;
  set status(UpdateFacilityRequestStatusEnum? status) =>
      _$this._status = status;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  UpdateFacilityRequestBuilder() {
    UpdateFacilityRequest._defaults(this);
  }

  UpdateFacilityRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _address = $v.address;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _name = $v.name;
      _sector = $v.sector;
      _status = $v.status;
      _timezone = $v.timezone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateFacilityRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateFacilityRequest;
  }

  @override
  void update(void Function(UpdateFacilityRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateFacilityRequest build() => _build();

  _$UpdateFacilityRequest _build() {
    final _$result = _$v ??
        new _$UpdateFacilityRequest._(
            address: address,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            name: name,
            sector: sector,
            status: status,
            timezone: timezone);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
