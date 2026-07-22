// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CurrentUser extends CurrentUser {
  @override
  final String companyId;
  @override
  final String? companyLocale;
  @override
  final String companyName;
  @override
  final String? companyTimezone;
  @override
  final String email;
  @override
  final bool emailVerified;
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
      this.companyLocale,
      required this.companyName,
      this.companyTimezone,
      required this.email,
      required this.emailVerified,
      required this.permissions,
      required this.roleKey,
      required this.uid})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyId, r'CurrentUser', 'companyId');
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'CurrentUser', 'companyName');
    BuiltValueNullFieldError.checkNotNull(email, r'CurrentUser', 'email');
    BuiltValueNullFieldError.checkNotNull(
        emailVerified, r'CurrentUser', 'emailVerified');
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
        companyLocale == other.companyLocale &&
        companyName == other.companyName &&
        companyTimezone == other.companyTimezone &&
        email == other.email &&
        emailVerified == other.emailVerified &&
        permissions == other.permissions &&
        roleKey == other.roleKey &&
        uid == other.uid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyLocale.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companyTimezone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
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
          ..add('companyLocale', companyLocale)
          ..add('companyName', companyName)
          ..add('companyTimezone', companyTimezone)
          ..add('email', email)
          ..add('emailVerified', emailVerified)
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

  String? _companyLocale;
  String? get companyLocale => _$this._companyLocale;
  set companyLocale(String? companyLocale) =>
      _$this._companyLocale = companyLocale;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _companyTimezone;
  String? get companyTimezone => _$this._companyTimezone;
  set companyTimezone(String? companyTimezone) =>
      _$this._companyTimezone = companyTimezone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

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
      _companyLocale = $v.companyLocale;
      _companyName = $v.companyName;
      _companyTimezone = $v.companyTimezone;
      _email = $v.email;
      _emailVerified = $v.emailVerified;
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
              companyLocale: companyLocale,
              companyName: BuiltValueNullFieldError.checkNotNull(
                  companyName, r'CurrentUser', 'companyName'),
              companyTimezone: companyTimezone,
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'CurrentUser', 'email'),
              emailVerified: BuiltValueNullFieldError.checkNotNull(
                  emailVerified, r'CurrentUser', 'emailVerified'),
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
