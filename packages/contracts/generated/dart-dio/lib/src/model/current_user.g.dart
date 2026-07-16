// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CurrentUser extends CurrentUser {
  @override
  final String companyId;
  @override
  final String email;
  @override
  final BuiltSet<String> permissions;
  @override
  final String roleKey;
  @override
  final String uid;

  factory _$CurrentUser([void Function(CurrentUserBuilder)? updates]) =>
      (new CurrentUserBuilder()..update(updates))._build();

  _$CurrentUser._(
      {required this.companyId,
      required this.email,
      required this.permissions,
      required this.roleKey,
      required this.uid})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyId, r'CurrentUser', 'companyId');
    BuiltValueNullFieldError.checkNotNull(email, r'CurrentUser', 'email');
    BuiltValueNullFieldError.checkNotNull(
        permissions, r'CurrentUser', 'permissions');
    BuiltValueNullFieldError.checkNotNull(roleKey, r'CurrentUser', 'roleKey');
    BuiltValueNullFieldError.checkNotNull(uid, r'CurrentUser', 'uid');
  }

  @override
  CurrentUser rebuild(void Function(CurrentUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurrentUserBuilder toBuilder() => new CurrentUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurrentUser &&
        companyId == other.companyId &&
        email == other.email &&
        permissions == other.permissions &&
        roleKey == other.roleKey &&
        uid == other.uid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, roleKey.hashCode);
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CurrentUser')
          ..add('companyId', companyId)
          ..add('email', email)
          ..add('permissions', permissions)
          ..add('roleKey', roleKey)
          ..add('uid', uid))
        .toString();
  }
}

class CurrentUserBuilder implements Builder<CurrentUser, CurrentUserBuilder> {
  _$CurrentUser? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  SetBuilder<String>? _permissions;
  SetBuilder<String> get permissions =>
      _$this._permissions ??= new SetBuilder<String>();
  set permissions(SetBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  String? _roleKey;
  String? get roleKey => _$this._roleKey;
  set roleKey(String? roleKey) => _$this._roleKey = roleKey;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  CurrentUserBuilder() {
    CurrentUser._defaults(this);
  }

  CurrentUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _email = $v.email;
      _permissions = $v.permissions.toBuilder();
      _roleKey = $v.roleKey;
      _uid = $v.uid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CurrentUser other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CurrentUser;
  }

  @override
  void update(void Function(CurrentUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CurrentUser build() => _build();

  _$CurrentUser _build() {
    _$CurrentUser _$result;
    try {
      _$result = _$v ??
          new _$CurrentUser._(
              companyId: BuiltValueNullFieldError.checkNotNull(
                  companyId, r'CurrentUser', 'companyId'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'CurrentUser', 'email'),
              permissions: permissions.build(),
              roleKey: BuiltValueNullFieldError.checkNotNull(
                  roleKey, r'CurrentUser', 'roleKey'),
              uid: BuiltValueNullFieldError.checkNotNull(
                  uid, r'CurrentUser', 'uid'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CurrentUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
