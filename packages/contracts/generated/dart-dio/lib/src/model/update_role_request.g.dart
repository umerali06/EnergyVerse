// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_role_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateRoleRequest extends UpdateRoleRequest {
  @override
  final String? description;
  @override
  final String? name;
  @override
  final BuiltList<String>? permissionKeys;

  factory _$UpdateRoleRequest(
          [void Function(UpdateRoleRequestBuilder)? updates]) =>
      (new UpdateRoleRequestBuilder()..update(updates))._build();

  _$UpdateRoleRequest._({this.description, this.name, this.permissionKeys})
      : super._();

  @override
  UpdateRoleRequest rebuild(void Function(UpdateRoleRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateRoleRequestBuilder toBuilder() =>
      new UpdateRoleRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateRoleRequest &&
        description == other.description &&
        name == other.name &&
        permissionKeys == other.permissionKeys;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permissionKeys.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateRoleRequest')
          ..add('description', description)
          ..add('name', name)
          ..add('permissionKeys', permissionKeys))
        .toString();
  }
}

class UpdateRoleRequestBuilder
    implements Builder<UpdateRoleRequest, UpdateRoleRequestBuilder> {
  _$UpdateRoleRequest? _$v;

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

  UpdateRoleRequestBuilder() {
    UpdateRoleRequest._defaults(this);
  }

  UpdateRoleRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _name = $v.name;
      _permissionKeys = $v.permissionKeys?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateRoleRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateRoleRequest;
  }

  @override
  void update(void Function(UpdateRoleRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateRoleRequest build() => _build();

  _$UpdateRoleRequest _build() {
    _$UpdateRoleRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateRoleRequest._(
              description: description,
              name: name,
              permissionKeys: _permissionKeys?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissionKeys';
        _permissionKeys?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateRoleRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
