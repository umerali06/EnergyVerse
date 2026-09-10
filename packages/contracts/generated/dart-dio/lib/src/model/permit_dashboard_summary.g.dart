// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitDashboardSummary extends PermitDashboardSummary {
  @override
  final int active;

  factory _$PermitDashboardSummary(
          [void Function(PermitDashboardSummaryBuilder)? updates]) =>
      (new PermitDashboardSummaryBuilder()..update(updates))._build();

  _$PermitDashboardSummary._({required this.active}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        active, r'PermitDashboardSummary', 'active');
  }

  @override
  PermitDashboardSummary rebuild(
          void Function(PermitDashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitDashboardSummaryBuilder toBuilder() =>
      new PermitDashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitDashboardSummary && active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitDashboardSummary')
          ..add('active', active))
        .toString();
  }
}

class PermitDashboardSummaryBuilder
    implements Builder<PermitDashboardSummary, PermitDashboardSummaryBuilder> {
  _$PermitDashboardSummary? _$v;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  PermitDashboardSummaryBuilder() {
    PermitDashboardSummary._defaults(this);
  }

  PermitDashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitDashboardSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitDashboardSummary;
  }

  @override
  void update(void Function(PermitDashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitDashboardSummary build() => _build();

  _$PermitDashboardSummary _build() {
    final _$result = _$v ??
        new _$PermitDashboardSummary._(
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'PermitDashboardSummary', 'active'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
