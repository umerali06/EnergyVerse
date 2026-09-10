// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SafetyDashboardSummary extends SafetyDashboardSummary {
  @override
  final BuiltList<SafetyCategoryCount> byCategory;
  @override
  final int total;

  factory _$SafetyDashboardSummary(
          [void Function(SafetyDashboardSummaryBuilder)? updates]) =>
      (new SafetyDashboardSummaryBuilder()..update(updates))._build();

  _$SafetyDashboardSummary._({required this.byCategory, required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        byCategory, r'SafetyDashboardSummary', 'byCategory');
    BuiltValueNullFieldError.checkNotNull(
        total, r'SafetyDashboardSummary', 'total');
  }

  @override
  SafetyDashboardSummary rebuild(
          void Function(SafetyDashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SafetyDashboardSummaryBuilder toBuilder() =>
      new SafetyDashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SafetyDashboardSummary &&
        byCategory == other.byCategory &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byCategory.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SafetyDashboardSummary')
          ..add('byCategory', byCategory)
          ..add('total', total))
        .toString();
  }
}

class SafetyDashboardSummaryBuilder
    implements Builder<SafetyDashboardSummary, SafetyDashboardSummaryBuilder> {
  _$SafetyDashboardSummary? _$v;

  ListBuilder<SafetyCategoryCount>? _byCategory;
  ListBuilder<SafetyCategoryCount> get byCategory =>
      _$this._byCategory ??= new ListBuilder<SafetyCategoryCount>();
  set byCategory(ListBuilder<SafetyCategoryCount>? byCategory) =>
      _$this._byCategory = byCategory;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  SafetyDashboardSummaryBuilder() {
    SafetyDashboardSummary._defaults(this);
  }

  SafetyDashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byCategory = $v.byCategory.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SafetyDashboardSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SafetyDashboardSummary;
  }

  @override
  void update(void Function(SafetyDashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SafetyDashboardSummary build() => _build();

  _$SafetyDashboardSummary _build() {
    _$SafetyDashboardSummary _$result;
    try {
      _$result = _$v ??
          new _$SafetyDashboardSummary._(
              byCategory: byCategory.build(),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, r'SafetyDashboardSummary', 'total'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byCategory';
        byCategory.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SafetyDashboardSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
