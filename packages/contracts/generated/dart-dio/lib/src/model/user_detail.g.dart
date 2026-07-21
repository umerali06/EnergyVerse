// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserDetail extends UserDetail {
  @override
  final DateTime createdAt;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String id;
  @override
  final BuiltList<String> permissions;
  @override
  final String roleId;
  @override
  final String roleKey;
  @override
  final String roleName;
  @override
  final String status;
  @override
  final DateTime updatedAt;

  factory _$UserDetail([void Function(UserDetailBuilder)? updates]) =>
      (new UserDetailBuilder()..update(updates))._build();

  _$UserDetail._(
      {required this.createdAt,
      required this.displayName,
      required this.email,
      required this.id,
      required this.permissions,
      required this.roleId,
      required this.roleKey,
      required this.roleName,
      required this.status,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'UserDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'UserDetail', 'displayName');
    BuiltValueNullFieldError.checkNotNull(email, r'UserDetail', 'email');
    BuiltValueNullFieldError.checkNotNull(id, r'UserDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        permissions, r'UserDetail', 'permissions');
    BuiltValueNullFieldError.checkNotNull(roleId, r'UserDetail', 'roleId');
    BuiltValueNullFieldError.checkNotNull(roleKey, r'UserDetail', 'roleKey');
    BuiltValueNullFieldError.checkNotNull(roleName, r'UserDetail', 'roleName');
    BuiltValueNullFieldError.checkNotNull(status, r'UserDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'UserDetail', 'updatedAt');
  }

  @override
  UserDetail rebuild(void Function(UserDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDetailBuilder toBuilder() => new UserDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDetail &&
        createdAt == other.createdAt &&
        displayName == other.displayName &&
        email == other.email &&
        id == other.id &&
        permissions == other.permissions &&
        roleId == other.roleId &&
        roleKey == other.roleKey &&
        roleName == other.roleName &&
        status == other.status &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jc(_$hash, roleKey.hashCode);
    _$hash = $jc(_$hash, roleName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserDetail')
          ..add('createdAt', createdAt)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('id', id)
          ..add('permissions', permissions)
          ..add('roleId', roleId)
          ..add('roleKey', roleKey)
          ..add('roleName', roleName)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserDetailBuilder implements Builder<UserDetail, UserDetailBuilder> {
  _$UserDetail? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= new ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  String? _roleKey;
  String? get roleKey => _$this._roleKey;
  set roleKey(String? roleKey) => _$this._roleKey = roleKey;

  String? _roleName;
  String? get roleName => _$this._roleName;
  set roleName(String? roleName) => _$this._roleName = roleName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserDetailBuilder() {
    UserDetail._defaults(this);
  }

  UserDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _displayName = $v.displayName;
      _email = $v.email;
      _id = $v.id;
      _permissions = $v.permissions.toBuilder();
      _roleId = $v.roleId;
      _roleKey = $v.roleKey;
      _roleName = $v.roleName;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserDetail;
  }

  @override
  void update(void Function(UserDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserDetail build() => _build();

  _$UserDetail _build() {
    _$UserDetail _$result;
    try {
      _$result = _$v ??
          new _$UserDetail._(
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'UserDetail', 'createdAt'),
              displayName: BuiltValueNullFieldError.checkNotNull(
                  displayName, r'UserDetail', 'displayName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'UserDetail', 'email'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'UserDetail', 'id'),
              permissions: permissions.build(),
              roleId: BuiltValueNullFieldError.checkNotNull(
                  roleId, r'UserDetail', 'roleId'),
              roleKey: BuiltValueNullFieldError.checkNotNull(
                  roleKey, r'UserDetail', 'roleKey'),
              roleName: BuiltValueNullFieldError.checkNotNull(
                  roleName, r'UserDetail', 'roleName'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'UserDetail', 'status'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'UserDetail', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
