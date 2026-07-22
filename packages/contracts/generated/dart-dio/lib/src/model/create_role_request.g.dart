// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_role_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateRoleRequest extends CreateRoleRequest {
  @override
  final String? cloneFromRoleId;
  @override
  final String? description;
  @override
  final String name;
  @override
  final BuiltList<String>? permissionKeys;

  factory _$CreateRoleRequest(
          [void Function(CreateRoleRequestBuilder)? updates]) =>
      (new CreateRoleRequestBuilder()..update(updates))._build();

  _$CreateRoleRequest._(
      {this.cloneFromRoleId,
      this.description,
      required this.name,
      this.permissionKeys})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'CreateRoleRequest', 'name');
  }

  @override
  CreateRoleRequest rebuild(void Function(CreateRoleRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateRoleRequestBuilder toBuilder() =>
      new CreateRoleRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateRoleRequest &&
        cloneFromRoleId == other.cloneFromRoleId &&
        description == other.description &&
        name == other.name &&
        permissionKeys == other.permissionKeys;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cloneFromRoleId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permissionKeys.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateRoleRequest')
          ..add('cloneFromRoleId', cloneFromRoleId)
          ..add('description', description)
          ..add('name', name)
          ..add('permissionKeys', permissionKeys))
        .toString();
  }
}

class CreateRoleRequestBuilder
    implements Builder<CreateRoleRequest, CreateRoleRequestBuilder> {
  _$CreateRoleRequest? _$v;

  String? _cloneFromRoleId;
  String? get cloneFromRoleId => _$this._cloneFromRoleId;
  set cloneFromRoleId(String? cloneFromRoleId) =>
      _$this._cloneFromRoleId = cloneFromRoleId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _permissionKeys;
  ListBuilder<String> get permissionKeys =>
      _$this._permissionKeys ??= new ListBuilder<String>();
  set permissionKeys(ListBuilder<String>? permissionKeys) =>
      _$this._permissionKeys = permissionKeys;

  CreateRoleRequestBuilder() {
    CreateRoleRequest._defaults(this);
  }

  CreateRoleRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cloneFromRoleId = $v.cloneFromRoleId;
      _description = $v.description;
      _name = $v.name;
      _permissionKeys = $v.permissionKeys?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateRoleRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateRoleRequest;
  }

  @override
  void update(void Function(CreateRoleRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateRoleRequest build() => _build();

  _$CreateRoleRequest _build() {
    _$CreateRoleRequest _$result;
    try {
      _$result = _$v ??
          new _$CreateRoleRequest._(
              cloneFromRoleId: cloneFromRoleId,
              description: description,
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'CreateRoleRequest', 'name'),
              permissionKeys: _permissionKeys?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissionKeys';
        _permissionKeys?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateRoleRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
