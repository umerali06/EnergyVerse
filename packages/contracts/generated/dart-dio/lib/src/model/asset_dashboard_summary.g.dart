// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetDashboardSummary extends AssetDashboardSummary {
  @override
  final BuiltList<AssetCategoryCount> byCategory;
  @override
  final BuiltList<AssetFacilityCount> byFacility;
  @override
  final int critical;
  @override
  final int healthy;
  @override
  final int total;
  @override
  final int warning;

  factory _$AssetDashboardSummary(
          [void Function(AssetDashboardSummaryBuilder)? updates]) =>
      (new AssetDashboardSummaryBuilder()..update(updates))._build();

  _$AssetDashboardSummary._(
      {required this.byCategory,
      required this.byFacility,
      required this.critical,
      required this.healthy,
      required this.total,
      required this.warning})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        byCategory, r'AssetDashboardSummary', 'byCategory');
    BuiltValueNullFieldError.checkNotNull(
        byFacility, r'AssetDashboardSummary', 'byFacility');
    BuiltValueNullFieldError.checkNotNull(
        critical, r'AssetDashboardSummary', 'critical');
    BuiltValueNullFieldError.checkNotNull(
        healthy, r'AssetDashboardSummary', 'healthy');
    BuiltValueNullFieldError.checkNotNull(
        total, r'AssetDashboardSummary', 'total');
    BuiltValueNullFieldError.checkNotNull(
        warning, r'AssetDashboardSummary', 'warning');
  }

  @override
  AssetDashboardSummary rebuild(
          void Function(AssetDashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetDashboardSummaryBuilder toBuilder() =>
      new AssetDashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetDashboardSummary &&
        byCategory == other.byCategory &&
        byFacility == other.byFacility &&
        critical == other.critical &&
        healthy == other.healthy &&
        total == other.total &&
        warning == other.warning;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byCategory.hashCode);
    _$hash = $jc(_$hash, byFacility.hashCode);
    _$hash = $jc(_$hash, critical.hashCode);
    _$hash = $jc(_$hash, healthy.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, warning.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetDashboardSummary')
          ..add('byCategory', byCategory)
          ..add('byFacility', byFacility)
          ..add('critical', critical)
          ..add('healthy', healthy)
          ..add('total', total)
          ..add('warning', warning))
        .toString();
  }
}

class AssetDashboardSummaryBuilder
    implements Builder<AssetDashboardSummary, AssetDashboardSummaryBuilder> {
  _$AssetDashboardSummary? _$v;

  ListBuilder<AssetCategoryCount>? _byCategory;
  ListBuilder<AssetCategoryCount> get byCategory =>
      _$this._byCategory ??= new ListBuilder<AssetCategoryCount>();
  set byCategory(ListBuilder<AssetCategoryCount>? byCategory) =>
      _$this._byCategory = byCategory;

  ListBuilder<AssetFacilityCount>? _byFacility;
  ListBuilder<AssetFacilityCount> get byFacility =>
      _$this._byFacility ??= new ListBuilder<AssetFacilityCount>();
  set byFacility(ListBuilder<AssetFacilityCount>? byFacility) =>
      _$this._byFacility = byFacility;

  int? _critical;
  int? get critical => _$this._critical;
  set critical(int? critical) => _$this._critical = critical;

  int? _healthy;
  int? get healthy => _$this._healthy;
  set healthy(int? healthy) => _$this._healthy = healthy;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _warning;
  int? get warning => _$this._warning;
  set warning(int? warning) => _$this._warning = warning;

  AssetDashboardSummaryBuilder() {
    AssetDashboardSummary._defaults(this);
  }

  AssetDashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byCategory = $v.byCategory.toBuilder();
      _byFacility = $v.byFacility.toBuilder();
      _critical = $v.critical;
      _healthy = $v.healthy;
      _total = $v.total;
      _warning = $v.warning;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetDashboardSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetDashboardSummary;
  }

  @override
  void update(void Function(AssetDashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetDashboardSummary build() => _build();

  _$AssetDashboardSummary _build() {
    _$AssetDashboardSummary _$result;
    try {
      _$result = _$v ??
          new _$AssetDashboardSummary._(
              byCategory: byCategory.build(),
              byFacility: byFacility.build(),
              critical: BuiltValueNullFieldError.checkNotNull(
                  critical, r'AssetDashboardSummary', 'critical'),
              healthy: BuiltValueNullFieldError.checkNotNull(
                  healthy, r'AssetDashboardSummary', 'healthy'),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, r'AssetDashboardSummary', 'total'),
              warning: BuiltValueNullFieldError.checkNotNull(
                  warning, r'AssetDashboardSummary', 'warning'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byCategory';
        byCategory.build();
        _$failedField = 'byFacility';
        byFacility.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AssetDashboardSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
