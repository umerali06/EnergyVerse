// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportDashboardSummary extends ReportDashboardSummary {
  @override
  final int drafts;
  @override
  final int finalized;
  @override
  final int total;

  factory _$ReportDashboardSummary(
          [void Function(ReportDashboardSummaryBuilder)? updates]) =>
      (new ReportDashboardSummaryBuilder()..update(updates))._build();

  _$ReportDashboardSummary._(
      {required this.drafts, required this.finalized, required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        drafts, r'ReportDashboardSummary', 'drafts');
    BuiltValueNullFieldError.checkNotNull(
        finalized, r'ReportDashboardSummary', 'finalized');
    BuiltValueNullFieldError.checkNotNull(
        total, r'ReportDashboardSummary', 'total');
  }

  @override
  ReportDashboardSummary rebuild(
          void Function(ReportDashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportDashboardSummaryBuilder toBuilder() =>
      new ReportDashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportDashboardSummary &&
        drafts == other.drafts &&
        finalized == other.finalized &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, drafts.hashCode);
    _$hash = $jc(_$hash, finalized.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportDashboardSummary')
          ..add('drafts', drafts)
          ..add('finalized', finalized)
          ..add('total', total))
        .toString();
  }
}

class ReportDashboardSummaryBuilder
    implements Builder<ReportDashboardSummary, ReportDashboardSummaryBuilder> {
  _$ReportDashboardSummary? _$v;

  int? _drafts;
  int? get drafts => _$this._drafts;
  set drafts(int? drafts) => _$this._drafts = drafts;

  int? _finalized;
  int? get finalized => _$this._finalized;
  set finalized(int? finalized) => _$this._finalized = finalized;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ReportDashboardSummaryBuilder() {
    ReportDashboardSummary._defaults(this);
  }

  ReportDashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _drafts = $v.drafts;
      _finalized = $v.finalized;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportDashboardSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ReportDashboardSummary;
  }

  @override
  void update(void Function(ReportDashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportDashboardSummary build() => _build();

  _$ReportDashboardSummary _build() {
    final _$result = _$v ??
        new _$ReportDashboardSummary._(
            drafts: BuiltValueNullFieldError.checkNotNull(
                drafts, r'ReportDashboardSummary', 'drafts'),
            finalized: BuiltValueNullFieldError.checkNotNull(
                finalized, r'ReportDashboardSummary', 'finalized'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ReportDashboardSummary', 'total'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
