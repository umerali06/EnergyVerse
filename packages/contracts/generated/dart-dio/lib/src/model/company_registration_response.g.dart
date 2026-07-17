// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_registration_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyRegistrationResponse extends CompanyRegistrationResponse {
  @override
  final String companyId;
  @override
  final String email;
  @override
  final bool emailVerified;
  @override
  final String roleKey;
  @override
  final String uid;

  factory _$CompanyRegistrationResponse(
          [void Function(CompanyRegistrationResponseBuilder)? updates]) =>
      (new CompanyRegistrationResponseBuilder()..update(updates))._build();

  _$CompanyRegistrationResponse._(
      {required this.companyId,
      required this.email,
      required this.emailVerified,
      required this.roleKey,
      required this.uid})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyId, r'CompanyRegistrationResponse', 'companyId');
    BuiltValueNullFieldError.checkNotNull(
        email, r'CompanyRegistrationResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        emailVerified, r'CompanyRegistrationResponse', 'emailVerified');
    BuiltValueNullFieldError.checkNotNull(
        roleKey, r'CompanyRegistrationResponse', 'roleKey');
    BuiltValueNullFieldError.checkNotNull(
        uid, r'CompanyRegistrationResponse', 'uid');
  }

  @override
  CompanyRegistrationResponse rebuild(
          void Function(CompanyRegistrationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyRegistrationResponseBuilder toBuilder() =>
      new CompanyRegistrationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyRegistrationResponse &&
        companyId == other.companyId &&
        email == other.email &&
        emailVerified == other.emailVerified &&
        roleKey == other.roleKey &&
        uid == other.uid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, roleKey.hashCode);
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyRegistrationResponse')
          ..add('companyId', companyId)
          ..add('email', email)
          ..add('emailVerified', emailVerified)
          ..add('roleKey', roleKey)
          ..add('uid', uid))
        .toString();
  }
}

class CompanyRegistrationResponseBuilder
    implements
        Builder<CompanyRegistrationResponse,
            CompanyRegistrationResponseBuilder> {
  _$CompanyRegistrationResponse? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  String? _roleKey;
  String? get roleKey => _$this._roleKey;
  set roleKey(String? roleKey) => _$this._roleKey = roleKey;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  CompanyRegistrationResponseBuilder() {
    CompanyRegistrationResponse._defaults(this);
  }

  CompanyRegistrationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _email = $v.email;
      _emailVerified = $v.emailVerified;
      _roleKey = $v.roleKey;
      _uid = $v.uid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyRegistrationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyRegistrationResponse;
  }

  @override
  void update(void Function(CompanyRegistrationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyRegistrationResponse build() => _build();

  _$CompanyRegistrationResponse _build() {
    final _$result = _$v ??
        new _$CompanyRegistrationResponse._(
            companyId: BuiltValueNullFieldError.checkNotNull(
                companyId, r'CompanyRegistrationResponse', 'companyId'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'CompanyRegistrationResponse', 'email'),
            emailVerified: BuiltValueNullFieldError.checkNotNull(
                emailVerified, r'CompanyRegistrationResponse', 'emailVerified'),
            roleKey: BuiltValueNullFieldError.checkNotNull(
                roleKey, r'CompanyRegistrationResponse', 'roleKey'),
            uid: BuiltValueNullFieldError.checkNotNull(
                uid, r'CompanyRegistrationResponse', 'uid'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
