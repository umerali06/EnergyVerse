// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_registration_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyRegistrationRequest extends CompanyRegistrationRequest {
  @override
  final String companyName;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String password;

  factory _$CompanyRegistrationRequest(
          [void Function(CompanyRegistrationRequestBuilder)? updates]) =>
      (new CompanyRegistrationRequestBuilder()..update(updates))._build();

  _$CompanyRegistrationRequest._(
      {required this.companyName,
      required this.displayName,
      required this.email,
      required this.password})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'CompanyRegistrationRequest', 'companyName');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'CompanyRegistrationRequest', 'displayName');
    BuiltValueNullFieldError.checkNotNull(
        email, r'CompanyRegistrationRequest', 'email');
    BuiltValueNullFieldError.checkNotNull(
        password, r'CompanyRegistrationRequest', 'password');
  }

  @override
  CompanyRegistrationRequest rebuild(
          void Function(CompanyRegistrationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyRegistrationRequestBuilder toBuilder() =>
      new CompanyRegistrationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyRegistrationRequest &&
        companyName == other.companyName &&
        displayName == other.displayName &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyRegistrationRequest')
          ..add('companyName', companyName)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class CompanyRegistrationRequestBuilder
    implements
        Builder<CompanyRegistrationRequest, CompanyRegistrationRequestBuilder> {
  _$CompanyRegistrationRequest? _$v;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  CompanyRegistrationRequestBuilder() {
    CompanyRegistrationRequest._defaults(this);
  }

  CompanyRegistrationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyName = $v.companyName;
      _displayName = $v.displayName;
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyRegistrationRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyRegistrationRequest;
  }

  @override
  void update(void Function(CompanyRegistrationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyRegistrationRequest build() => _build();

  _$CompanyRegistrationRequest _build() {
    final _$result = _$v ??
        new _$CompanyRegistrationRequest._(
            companyName: BuiltValueNullFieldError.checkNotNull(
                companyName, r'CompanyRegistrationRequest', 'companyName'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'CompanyRegistrationRequest', 'displayName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'CompanyRegistrationRequest', 'email'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'CompanyRegistrationRequest', 'password'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
