// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_company_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCompanyRequest extends UpdateCompanyRequest {
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final String? industry;
  @override
  final String? locale;
  @override
  final String? name;
  @override
  final String? timezone;

  factory _$UpdateCompanyRequest(
          [void Function(UpdateCompanyRequestBuilder)? updates]) =>
      (new UpdateCompanyRequestBuilder()..update(updates))._build();

  _$UpdateCompanyRequest._(
      {this.contactEmail,
      this.contactPhone,
      this.industry,
      this.locale,
      this.name,
      this.timezone})
      : super._();

  @override
  UpdateCompanyRequest rebuild(
          void Function(UpdateCompanyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCompanyRequestBuilder toBuilder() =>
      new UpdateCompanyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCompanyRequest &&
        contactEmail == other.contactEmail &&
        contactPhone == other.contactPhone &&
        industry == other.industry &&
        locale == other.locale &&
        name == other.name &&
        timezone == other.timezone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, contactPhone.hashCode);
    _$hash = $jc(_$hash, industry.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCompanyRequest')
          ..add('contactEmail', contactEmail)
          ..add('contactPhone', contactPhone)
          ..add('industry', industry)
          ..add('locale', locale)
          ..add('name', name)
          ..add('timezone', timezone))
        .toString();
  }
}

class UpdateCompanyRequestBuilder
    implements Builder<UpdateCompanyRequest, UpdateCompanyRequestBuilder> {
  _$UpdateCompanyRequest? _$v;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  String? _contactPhone;
  String? get contactPhone => _$this._contactPhone;
  set contactPhone(String? contactPhone) => _$this._contactPhone = contactPhone;

  String? _industry;
  String? get industry => _$this._industry;
  set industry(String? industry) => _$this._industry = industry;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  UpdateCompanyRequestBuilder() {
    UpdateCompanyRequest._defaults(this);
  }

  UpdateCompanyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEmail = $v.contactEmail;
      _contactPhone = $v.contactPhone;
      _industry = $v.industry;
      _locale = $v.locale;
      _name = $v.name;
      _timezone = $v.timezone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCompanyRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateCompanyRequest;
  }

  @override
  void update(void Function(UpdateCompanyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCompanyRequest build() => _build();

  _$UpdateCompanyRequest _build() {
    final _$result = _$v ??
        new _$UpdateCompanyRequest._(
            contactEmail: contactEmail,
            contactPhone: contactPhone,
            industry: industry,
            locale: locale,
            name: name,
            timezone: timezone);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
