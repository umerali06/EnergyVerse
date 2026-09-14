// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_registration_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompanyRegistrationRequestAcceptanceSourceEnum
    _$companyRegistrationRequestAcceptanceSourceEnum_web =
    const CompanyRegistrationRequestAcceptanceSourceEnum._('web');
const CompanyRegistrationRequestAcceptanceSourceEnum
    _$companyRegistrationRequestAcceptanceSourceEnum_mobile =
    const CompanyRegistrationRequestAcceptanceSourceEnum._('mobile');
const CompanyRegistrationRequestAcceptanceSourceEnum
    _$companyRegistrationRequestAcceptanceSourceEnum_sso =
    const CompanyRegistrationRequestAcceptanceSourceEnum._('sso');
const CompanyRegistrationRequestAcceptanceSourceEnum
    _$companyRegistrationRequestAcceptanceSourceEnum_contract =
    const CompanyRegistrationRequestAcceptanceSourceEnum._('contract');

CompanyRegistrationRequestAcceptanceSourceEnum
    _$companyRegistrationRequestAcceptanceSourceEnumValueOf(String name) {
  switch (name) {
    case 'web':
      return _$companyRegistrationRequestAcceptanceSourceEnum_web;
    case 'mobile':
      return _$companyRegistrationRequestAcceptanceSourceEnum_mobile;
    case 'sso':
      return _$companyRegistrationRequestAcceptanceSourceEnum_sso;
    case 'contract':
      return _$companyRegistrationRequestAcceptanceSourceEnum_contract;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CompanyRegistrationRequestAcceptanceSourceEnum>
    _$companyRegistrationRequestAcceptanceSourceEnumValues = new BuiltSet<
        CompanyRegistrationRequestAcceptanceSourceEnum>(const <CompanyRegistrationRequestAcceptanceSourceEnum>[
  _$companyRegistrationRequestAcceptanceSourceEnum_web,
  _$companyRegistrationRequestAcceptanceSourceEnum_mobile,
  _$companyRegistrationRequestAcceptanceSourceEnum_sso,
  _$companyRegistrationRequestAcceptanceSourceEnum_contract,
]);

Serializer<CompanyRegistrationRequestAcceptanceSourceEnum>
    _$companyRegistrationRequestAcceptanceSourceEnumSerializer =
    new _$CompanyRegistrationRequestAcceptanceSourceEnumSerializer();

class _$CompanyRegistrationRequestAcceptanceSourceEnumSerializer
    implements
        PrimitiveSerializer<CompanyRegistrationRequestAcceptanceSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'web': 'web',
    'mobile': 'mobile',
    'sso': 'sso',
    'contract': 'contract',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'web': 'web',
    'mobile': 'mobile',
    'sso': 'sso',
    'contract': 'contract',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CompanyRegistrationRequestAcceptanceSourceEnum
  ];
  @override
  final String wireName = 'CompanyRegistrationRequestAcceptanceSourceEnum';

  @override
  Object serialize(Serializers serializers,
          CompanyRegistrationRequestAcceptanceSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompanyRegistrationRequestAcceptanceSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompanyRegistrationRequestAcceptanceSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CompanyRegistrationRequest extends CompanyRegistrationRequest {
  @override
  final CompanyRegistrationRequestAcceptanceSourceEnum? acceptanceSource;
  @override
  final String companyName;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String legalVersion;
  @override
  final String password;
  @override
  final bool privacyAccepted;
  @override
  final bool safetyDisclaimerAccepted;
  @override
  final bool termsAccepted;

  factory _$CompanyRegistrationRequest(
          [void Function(CompanyRegistrationRequestBuilder)? updates]) =>
      (new CompanyRegistrationRequestBuilder()..update(updates))._build();

  _$CompanyRegistrationRequest._(
      {this.acceptanceSource,
      required this.companyName,
      required this.displayName,
      required this.email,
      required this.legalVersion,
      required this.password,
      required this.privacyAccepted,
      required this.safetyDisclaimerAccepted,
      required this.termsAccepted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'CompanyRegistrationRequest', 'companyName');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'CompanyRegistrationRequest', 'displayName');
    BuiltValueNullFieldError.checkNotNull(
        email, r'CompanyRegistrationRequest', 'email');
    BuiltValueNullFieldError.checkNotNull(
        legalVersion, r'CompanyRegistrationRequest', 'legalVersion');
    BuiltValueNullFieldError.checkNotNull(
        password, r'CompanyRegistrationRequest', 'password');
    BuiltValueNullFieldError.checkNotNull(
        privacyAccepted, r'CompanyRegistrationRequest', 'privacyAccepted');
    BuiltValueNullFieldError.checkNotNull(safetyDisclaimerAccepted,
        r'CompanyRegistrationRequest', 'safetyDisclaimerAccepted');
    BuiltValueNullFieldError.checkNotNull(
        termsAccepted, r'CompanyRegistrationRequest', 'termsAccepted');
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
        acceptanceSource == other.acceptanceSource &&
        companyName == other.companyName &&
        displayName == other.displayName &&
        email == other.email &&
        legalVersion == other.legalVersion &&
        password == other.password &&
        privacyAccepted == other.privacyAccepted &&
        safetyDisclaimerAccepted == other.safetyDisclaimerAccepted &&
        termsAccepted == other.termsAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptanceSource.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, legalVersion.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jc(_$hash, safetyDisclaimerAccepted.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyRegistrationRequest')
          ..add('acceptanceSource', acceptanceSource)
          ..add('companyName', companyName)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('legalVersion', legalVersion)
          ..add('password', password)
          ..add('privacyAccepted', privacyAccepted)
          ..add('safetyDisclaimerAccepted', safetyDisclaimerAccepted)
          ..add('termsAccepted', termsAccepted))
        .toString();
  }
}

class CompanyRegistrationRequestBuilder
    implements
        Builder<CompanyRegistrationRequest, CompanyRegistrationRequestBuilder> {
  _$CompanyRegistrationRequest? _$v;

  CompanyRegistrationRequestAcceptanceSourceEnum? _acceptanceSource;
  CompanyRegistrationRequestAcceptanceSourceEnum? get acceptanceSource =>
      _$this._acceptanceSource;
  set acceptanceSource(
          CompanyRegistrationRequestAcceptanceSourceEnum? acceptanceSource) =>
      _$this._acceptanceSource = acceptanceSource;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _legalVersion;
  String? get legalVersion => _$this._legalVersion;
  set legalVersion(String? legalVersion) => _$this._legalVersion = legalVersion;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  bool? _privacyAccepted;
  bool? get privacyAccepted => _$this._privacyAccepted;
  set privacyAccepted(bool? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  bool? _safetyDisclaimerAccepted;
  bool? get safetyDisclaimerAccepted => _$this._safetyDisclaimerAccepted;
  set safetyDisclaimerAccepted(bool? safetyDisclaimerAccepted) =>
      _$this._safetyDisclaimerAccepted = safetyDisclaimerAccepted;

  bool? _termsAccepted;
  bool? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  CompanyRegistrationRequestBuilder() {
    CompanyRegistrationRequest._defaults(this);
  }

  CompanyRegistrationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptanceSource = $v.acceptanceSource;
      _companyName = $v.companyName;
      _displayName = $v.displayName;
      _email = $v.email;
      _legalVersion = $v.legalVersion;
      _password = $v.password;
      _privacyAccepted = $v.privacyAccepted;
      _safetyDisclaimerAccepted = $v.safetyDisclaimerAccepted;
      _termsAccepted = $v.termsAccepted;
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
            acceptanceSource: acceptanceSource,
            companyName: BuiltValueNullFieldError.checkNotNull(
                companyName, r'CompanyRegistrationRequest', 'companyName'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'CompanyRegistrationRequest', 'displayName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'CompanyRegistrationRequest', 'email'),
            legalVersion: BuiltValueNullFieldError.checkNotNull(
                legalVersion, r'CompanyRegistrationRequest', 'legalVersion'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'CompanyRegistrationRequest', 'password'),
            privacyAccepted: BuiltValueNullFieldError.checkNotNull(
                privacyAccepted, r'CompanyRegistrationRequest', 'privacyAccepted'),
            safetyDisclaimerAccepted: BuiltValueNullFieldError.checkNotNull(
                safetyDisclaimerAccepted, r'CompanyRegistrationRequest', 'safetyDisclaimerAccepted'),
            termsAccepted: BuiltValueNullFieldError.checkNotNull(
                termsAccepted, r'CompanyRegistrationRequest', 'termsAccepted'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
