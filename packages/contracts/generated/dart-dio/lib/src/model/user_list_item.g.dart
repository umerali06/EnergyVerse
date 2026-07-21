// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserListItem extends UserListItem {
  @override
  final DateTime createdAt;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String id;
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

  factory _$UserListItem([void Function(UserListItemBuilder)? updates]) =>
      (new UserListItemBuilder()..update(updates))._build();

  _$UserListItem._(
      {required this.createdAt,
      required this.displayName,
      required this.email,
      required this.id,
      required this.roleId,
      required this.roleKey,
      required this.roleName,
      required this.status,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'UserListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'UserListItem', 'displayName');
    BuiltValueNullFieldError.checkNotNull(email, r'UserListItem', 'email');
    BuiltValueNullFieldError.checkNotNull(id, r'UserListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(roleId, r'UserListItem', 'roleId');
    BuiltValueNullFieldError.checkNotNull(roleKey, r'UserListItem', 'roleKey');
    BuiltValueNullFieldError.checkNotNull(
        roleName, r'UserListItem', 'roleName');
    BuiltValueNullFieldError.checkNotNull(status, r'UserListItem', 'status');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'UserListItem', 'updatedAt');
  }

  @override
  UserListItem rebuild(void Function(UserListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserListItemBuilder toBuilder() => new UserListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserListItem &&
        createdAt == other.createdAt &&
        displayName == other.displayName &&
        email == other.email &&
        id == other.id &&
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
    return (newBuiltValueToStringHelper(r'UserListItem')
          ..add('createdAt', createdAt)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('id', id)
          ..add('roleId', roleId)
          ..add('roleKey', roleKey)
          ..add('roleName', roleName)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserListItemBuilder
    implements Builder<UserListItem, UserListItemBuilder> {
  _$UserListItem? _$v;

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

  UserListItemBuilder() {
    UserListItem._defaults(this);
  }

  UserListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _displayName = $v.displayName;
      _email = $v.email;
      _id = $v.id;
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
  void replace(UserListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserListItem;
  }

  @override
  void update(void Function(UserListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserListItem build() => _build();

  _$UserListItem _build() {
    final _$result = _$v ??
        new _$UserListItem._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UserListItem', 'createdAt'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'UserListItem', 'displayName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'UserListItem', 'email'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserListItem', 'id'),
            roleId: BuiltValueNullFieldError.checkNotNull(
                roleId, r'UserListItem', 'roleId'),
            roleKey: BuiltValueNullFieldError.checkNotNull(
                roleKey, r'UserListItem', 'roleKey'),
            roleName: BuiltValueNullFieldError.checkNotNull(
                roleName, r'UserListItem', 'roleName'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UserListItem', 'status'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'UserListItem', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
