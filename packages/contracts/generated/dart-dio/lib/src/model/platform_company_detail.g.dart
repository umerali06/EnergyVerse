// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_company_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformCompanyDetail extends PlatformCompanyDetail {
  @override
  final String? contactEmail;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String? industry;
  @override
  final String name;
  @override
  final int rolesTotal;
  @override
  final String status;
  @override
  final String subscriptionTier;
  @override
  final int usersTotal;

  factory _$PlatformCompanyDetail(
          [void Function(PlatformCompanyDetailBuilder)? updates]) =>
      (new PlatformCompanyDetailBuilder()..update(updates))._build();

  _$PlatformCompanyDetail._(
      {this.contactEmail,
      required this.createdAt,
      required this.id,
      this.industry,
      required this.name,
      required this.rolesTotal,
      required this.status,
      required this.subscriptionTier,
      required this.usersTotal})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PlatformCompanyDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'PlatformCompanyDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'PlatformCompanyDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        rolesTotal, r'PlatformCompanyDetail', 'rolesTotal');
    BuiltValueNullFieldError.checkNotNull(
        status, r'PlatformCompanyDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(
        subscriptionTier, r'PlatformCompanyDetail', 'subscriptionTier');
    BuiltValueNullFieldError.checkNotNull(
        usersTotal, r'PlatformCompanyDetail', 'usersTotal');
  }

  @override
  PlatformCompanyDetail rebuild(
          void Function(PlatformCompanyDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformCompanyDetailBuilder toBuilder() =>
      new PlatformCompanyDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformCompanyDetail &&
        contactEmail == other.contactEmail &&
        createdAt == other.createdAt &&
        id == other.id &&
        industry == other.industry &&
        name == other.name &&
        rolesTotal == other.rolesTotal &&
        status == other.status &&
        subscriptionTier == other.subscriptionTier &&
        usersTotal == other.usersTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, industry.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, rolesTotal.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, usersTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformCompanyDetail')
          ..add('contactEmail', contactEmail)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('industry', industry)
          ..add('name', name)
          ..add('rolesTotal', rolesTotal)
          ..add('status', status)
          ..add('subscriptionTier', subscriptionTier)
          ..add('usersTotal', usersTotal))
        .toString();
  }
}

class PlatformCompanyDetailBuilder
    implements Builder<PlatformCompanyDetail, PlatformCompanyDetailBuilder> {
  _$PlatformCompanyDetail? _$v;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _industry;
  String? get industry => _$this._industry;
  set industry(String? industry) => _$this._industry = industry;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _rolesTotal;
  int? get rolesTotal => _$this._rolesTotal;
  set rolesTotal(int? rolesTotal) => _$this._rolesTotal = rolesTotal;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _subscriptionTier;
  String? get subscriptionTier => _$this._subscriptionTier;
  set subscriptionTier(String? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  int? _usersTotal;
  int? get usersTotal => _$this._usersTotal;
  set usersTotal(int? usersTotal) => _$this._usersTotal = usersTotal;

  PlatformCompanyDetailBuilder() {
    PlatformCompanyDetail._defaults(this);
  }

  PlatformCompanyDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEmail = $v.contactEmail;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _industry = $v.industry;
      _name = $v.name;
      _rolesTotal = $v.rolesTotal;
      _status = $v.status;
      _subscriptionTier = $v.subscriptionTier;
      _usersTotal = $v.usersTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformCompanyDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PlatformCompanyDetail;
  }

  @override
  void update(void Function(PlatformCompanyDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformCompanyDetail build() => _build();

  _$PlatformCompanyDetail _build() {
    final _$result = _$v ??
        new _$PlatformCompanyDetail._(
            contactEmail: contactEmail,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PlatformCompanyDetail', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PlatformCompanyDetail', 'id'),
            industry: industry,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PlatformCompanyDetail', 'name'),
            rolesTotal: BuiltValueNullFieldError.checkNotNull(
                rolesTotal, r'PlatformCompanyDetail', 'rolesTotal'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PlatformCompanyDetail', 'status'),
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier, r'PlatformCompanyDetail', 'subscriptionTier'),
            usersTotal: BuiltValueNullFieldError.checkNotNull(
                usersTotal, r'PlatformCompanyDetail', 'usersTotal'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
