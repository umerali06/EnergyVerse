// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyProfile extends CompanyProfile {
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String? industry;
  @override
  final String locale;
  @override
  final String? logoUrl;
  @override
  final String name;
  @override
  final int rolesTotal;
  @override
  final String subscriptionTier;
  @override
  final String timezone;
  @override
  final int usersTotal;

  factory _$CompanyProfile([void Function(CompanyProfileBuilder)? updates]) =>
      (new CompanyProfileBuilder()..update(updates))._build();

  _$CompanyProfile._(
      {this.contactEmail,
      this.contactPhone,
      required this.createdAt,
      required this.id,
      this.industry,
      required this.locale,
      this.logoUrl,
      required this.name,
      required this.rolesTotal,
      required this.subscriptionTier,
      required this.timezone,
      required this.usersTotal})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'CompanyProfile', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'CompanyProfile', 'id');
    BuiltValueNullFieldError.checkNotNull(locale, r'CompanyProfile', 'locale');
    BuiltValueNullFieldError.checkNotNull(name, r'CompanyProfile', 'name');
    BuiltValueNullFieldError.checkNotNull(
        rolesTotal, r'CompanyProfile', 'rolesTotal');
    BuiltValueNullFieldError.checkNotNull(
        subscriptionTier, r'CompanyProfile', 'subscriptionTier');
    BuiltValueNullFieldError.checkNotNull(
        timezone, r'CompanyProfile', 'timezone');
    BuiltValueNullFieldError.checkNotNull(
        usersTotal, r'CompanyProfile', 'usersTotal');
  }

  @override
  CompanyProfile rebuild(void Function(CompanyProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyProfileBuilder toBuilder() =>
      new CompanyProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyProfile &&
        contactEmail == other.contactEmail &&
        contactPhone == other.contactPhone &&
        createdAt == other.createdAt &&
        id == other.id &&
        industry == other.industry &&
        locale == other.locale &&
        logoUrl == other.logoUrl &&
        name == other.name &&
        rolesTotal == other.rolesTotal &&
        subscriptionTier == other.subscriptionTier &&
        timezone == other.timezone &&
        usersTotal == other.usersTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, contactPhone.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, industry.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, rolesTotal.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, usersTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyProfile')
          ..add('contactEmail', contactEmail)
          ..add('contactPhone', contactPhone)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('industry', industry)
          ..add('locale', locale)
          ..add('logoUrl', logoUrl)
          ..add('name', name)
          ..add('rolesTotal', rolesTotal)
          ..add('subscriptionTier', subscriptionTier)
          ..add('timezone', timezone)
          ..add('usersTotal', usersTotal))
        .toString();
  }
}

class CompanyProfileBuilder
    implements Builder<CompanyProfile, CompanyProfileBuilder> {
  _$CompanyProfile? _$v;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  String? _contactPhone;
  String? get contactPhone => _$this._contactPhone;
  set contactPhone(String? contactPhone) => _$this._contactPhone = contactPhone;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _industry;
  String? get industry => _$this._industry;
  set industry(String? industry) => _$this._industry = industry;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _rolesTotal;
  int? get rolesTotal => _$this._rolesTotal;
  set rolesTotal(int? rolesTotal) => _$this._rolesTotal = rolesTotal;

  String? _subscriptionTier;
  String? get subscriptionTier => _$this._subscriptionTier;
  set subscriptionTier(String? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  int? _usersTotal;
  int? get usersTotal => _$this._usersTotal;
  set usersTotal(int? usersTotal) => _$this._usersTotal = usersTotal;

  CompanyProfileBuilder() {
    CompanyProfile._defaults(this);
  }

  CompanyProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEmail = $v.contactEmail;
      _contactPhone = $v.contactPhone;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _industry = $v.industry;
      _locale = $v.locale;
      _logoUrl = $v.logoUrl;
      _name = $v.name;
      _rolesTotal = $v.rolesTotal;
      _subscriptionTier = $v.subscriptionTier;
      _timezone = $v.timezone;
      _usersTotal = $v.usersTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyProfile other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyProfile;
  }

  @override
  void update(void Function(CompanyProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyProfile build() => _build();

  _$CompanyProfile _build() {
    final _$result = _$v ??
        new _$CompanyProfile._(
            contactEmail: contactEmail,
            contactPhone: contactPhone,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CompanyProfile', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CompanyProfile', 'id'),
            industry: industry,
            locale: BuiltValueNullFieldError.checkNotNull(
                locale, r'CompanyProfile', 'locale'),
            logoUrl: logoUrl,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CompanyProfile', 'name'),
            rolesTotal: BuiltValueNullFieldError.checkNotNull(
                rolesTotal, r'CompanyProfile', 'rolesTotal'),
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier, r'CompanyProfile', 'subscriptionTier'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'CompanyProfile', 'timezone'),
            usersTotal: BuiltValueNullFieldError.checkNotNull(
                usersTotal, r'CompanyProfile', 'usersTotal'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
