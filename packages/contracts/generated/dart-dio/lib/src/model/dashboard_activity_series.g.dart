// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_activity_series.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardActivitySeries extends DashboardActivitySeries {
  @override
  final BuiltList<DashboardSeriesPoint> points;
  @override
  final int windowDays;

  factory _$DashboardActivitySeries(
          [void Function(DashboardActivitySeriesBuilder)? updates]) =>
      (new DashboardActivitySeriesBuilder()..update(updates))._build();

  _$DashboardActivitySeries._({required this.points, required this.windowDays})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        points, r'DashboardActivitySeries', 'points');
    BuiltValueNullFieldError.checkNotNull(
        windowDays, r'DashboardActivitySeries', 'windowDays');
  }

  @override
  DashboardActivitySeries rebuild(
          void Function(DashboardActivitySeriesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardActivitySeriesBuilder toBuilder() =>
      new DashboardActivitySeriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardActivitySeries &&
        points == other.points &&
        windowDays == other.windowDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardActivitySeries')
          ..add('points', points)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class DashboardActivitySeriesBuilder
    implements
        Builder<DashboardActivitySeries, DashboardActivitySeriesBuilder> {
  _$DashboardActivitySeries? _$v;

  ListBuilder<DashboardSeriesPoint>? _points;
  ListBuilder<DashboardSeriesPoint> get points =>
      _$this._points ??= new ListBuilder<DashboardSeriesPoint>();
  set points(ListBuilder<DashboardSeriesPoint>? points) =>
      _$this._points = points;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  DashboardActivitySeriesBuilder() {
    DashboardActivitySeries._defaults(this);
  }

  DashboardActivitySeriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _points = $v.points.toBuilder();
      _windowDays = $v.windowDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardActivitySeries other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardActivitySeries;
  }

  @override
  void update(void Function(DashboardActivitySeriesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardActivitySeries build() => _build();

  _$DashboardActivitySeries _build() {
    _$DashboardActivitySeries _$result;
    try {
      _$result = _$v ??
          new _$DashboardActivitySeries._(
              points: points.build(),
              windowDays: BuiltValueNullFieldError.checkNotNull(
                  windowDays, r'DashboardActivitySeries', 'windowDays'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DashboardActivitySeries', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
