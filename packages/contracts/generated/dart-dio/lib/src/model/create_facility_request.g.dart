// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_facility_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateFacilityRequestStatusEnum _$createFacilityRequestStatusEnum_active =
    const CreateFacilityRequestStatusEnum._('active');
const CreateFacilityRequestStatusEnum
    _$createFacilityRequestStatusEnum_inactive =
    const CreateFacilityRequestStatusEnum._('inactive');

CreateFacilityRequestStatusEnum _$createFacilityRequestStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'active':
      return _$createFacilityRequestStatusEnum_active;
    case 'inactive':
      return _$createFacilityRequestStatusEnum_inactive;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateFacilityRequestStatusEnum>
    _$createFacilityRequestStatusEnumValues = new BuiltSet<
        CreateFacilityRequestStatusEnum>(const <CreateFacilityRequestStatusEnum>[
  _$createFacilityRequestStatusEnum_active,
  _$createFacilityRequestStatusEnum_inactive,
]);

Serializer<CreateFacilityRequestStatusEnum>
    _$createFacilityRequestStatusEnumSerializer =
    new _$CreateFacilityRequestStatusEnumSerializer();

class _$CreateFacilityRequestStatusEnumSerializer
    implements PrimitiveSerializer<CreateFacilityRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateFacilityRequestStatusEnum];
  @override
  final String wireName = 'CreateFacilityRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CreateFacilityRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateFacilityRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateFacilityRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateFacilityRequest extends CreateFacilityRequest {
  @override
  final String? address;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String name;
  @override
  final String? sector;
  @override
  final CreateFacilityRequestStatusEnum? status;
  @override
  final String? timezone;

  factory _$CreateFacilityRequest(
          [void Function(CreateFacilityRequestBuilder)? updates]) =>
      (new CreateFacilityRequestBuilder()..update(updates))._build();

  _$CreateFacilityRequest._(
      {this.address,
      this.gpsLat,
      this.gpsLng,
      required this.name,
      this.sector,
      this.status,
      this.timezone})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        name, r'CreateFacilityRequest', 'name');
  }

  @override
  CreateFacilityRequest rebuild(
          void Function(CreateFacilityRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateFacilityRequestBuilder toBuilder() =>
      new CreateFacilityRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateFacilityRequest &&
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
    return (newBuiltValueToStringHelper(r'CreateFacilityRequest')
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

class CreateFacilityRequestBuilder
    implements Builder<CreateFacilityRequest, CreateFacilityRequestBuilder> {
  _$CreateFacilityRequest? _$v;

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

  CreateFacilityRequestStatusEnum? _status;
  CreateFacilityRequestStatusEnum? get status => _$this._status;
  set status(CreateFacilityRequestStatusEnum? status) =>
      _$this._status = status;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  CreateFacilityRequestBuilder() {
    CreateFacilityRequest._defaults(this);
  }

  CreateFacilityRequestBuilder get _$this {
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
  void replace(CreateFacilityRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateFacilityRequest;
  }

  @override
  void update(void Function(CreateFacilityRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateFacilityRequest build() => _build();

  _$CreateFacilityRequest _build() {
    final _$result = _$v ??
        new _$CreateFacilityRequest._(
            address: address,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateFacilityRequest', 'name'),
            sector: sector,
            status: status,
            timezone: timezone);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
