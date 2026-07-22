// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_area_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateAreaRequest extends CreateAreaRequest {
  @override
  final String? code;
  @override
  final String? description;
  @override
  final String facilityId;
  @override
  final String name;

  factory _$CreateAreaRequest(
          [void Function(CreateAreaRequestBuilder)? updates]) =>
      (new CreateAreaRequestBuilder()..update(updates))._build();

  _$CreateAreaRequest._(
      {this.code,
      this.description,
      required this.facilityId,
      required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'CreateAreaRequest', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(name, r'CreateAreaRequest', 'name');
  }

  @override
  CreateAreaRequest rebuild(void Function(CreateAreaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAreaRequestBuilder toBuilder() =>
      new CreateAreaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAreaRequest &&
        code == other.code &&
        description == other.description &&
        facilityId == other.facilityId &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAreaRequest')
          ..add('code', code)
          ..add('description', description)
          ..add('facilityId', facilityId)
          ..add('name', name))
        .toString();
  }
}

class CreateAreaRequestBuilder
    implements Builder<CreateAreaRequest, CreateAreaRequestBuilder> {
  _$CreateAreaRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CreateAreaRequestBuilder() {
    CreateAreaRequest._defaults(this);
  }

  CreateAreaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _description = $v.description;
      _facilityId = $v.facilityId;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAreaRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAreaRequest;
  }

  @override
  void update(void Function(CreateAreaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAreaRequest build() => _build();

  _$CreateAreaRequest _build() {
    final _$result = _$v ??
        new _$CreateAreaRequest._(
            code: code,
            description: description,
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'CreateAreaRequest', 'facilityId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateAreaRequest', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
