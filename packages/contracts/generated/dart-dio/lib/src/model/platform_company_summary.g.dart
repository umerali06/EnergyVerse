// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_company_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformCompanySummary extends PlatformCompanySummary {
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String name;
  @override
  final String status;
  @override
  final String subscriptionTier;
  @override
  final int usersTotal;

  factory _$PlatformCompanySummary(
          [void Function(PlatformCompanySummaryBuilder)? updates]) =>
      (new PlatformCompanySummaryBuilder()..update(updates))._build();

  _$PlatformCompanySummary._(
      {required this.createdAt,
      required this.id,
      required this.name,
      required this.status,
      required this.subscriptionTier,
      required this.usersTotal})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PlatformCompanySummary', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'PlatformCompanySummary', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'PlatformCompanySummary', 'name');
    BuiltValueNullFieldError.checkNotNull(
        status, r'PlatformCompanySummary', 'status');
    BuiltValueNullFieldError.checkNotNull(
        subscriptionTier, r'PlatformCompanySummary', 'subscriptionTier');
    BuiltValueNullFieldError.checkNotNull(
        usersTotal, r'PlatformCompanySummary', 'usersTotal');
  }

  @override
  PlatformCompanySummary rebuild(
          void Function(PlatformCompanySummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformCompanySummaryBuilder toBuilder() =>
      new PlatformCompanySummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformCompanySummary &&
        createdAt == other.createdAt &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        subscriptionTier == other.subscriptionTier &&
        usersTotal == other.usersTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, usersTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformCompanySummary')
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('subscriptionTier', subscriptionTier)
          ..add('usersTotal', usersTotal))
        .toString();
  }
}

class PlatformCompanySummaryBuilder
    implements Builder<PlatformCompanySummary, PlatformCompanySummaryBuilder> {
  _$PlatformCompanySummary? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  PlatformCompanySummaryBuilder() {
    PlatformCompanySummary._defaults(this);
  }

  PlatformCompanySummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _subscriptionTier = $v.subscriptionTier;
      _usersTotal = $v.usersTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformCompanySummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PlatformCompanySummary;
  }

  @override
  void update(void Function(PlatformCompanySummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformCompanySummary build() => _build();

  _$PlatformCompanySummary _build() {
    final _$result = _$v ??
        new _$PlatformCompanySummary._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PlatformCompanySummary', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PlatformCompanySummary', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PlatformCompanySummary', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PlatformCompanySummary', 'status'),
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier,
                r'PlatformCompanySummary',
                'subscriptionTier'),
            usersTotal: BuiltValueNullFieldError.checkNotNull(
                usersTotal, r'PlatformCompanySummary', 'usersTotal'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
