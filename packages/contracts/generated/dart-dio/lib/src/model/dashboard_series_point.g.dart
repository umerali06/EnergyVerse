// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_series_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardSeriesPoint extends DashboardSeriesPoint {
  @override
  final int count;
  @override
  final Date date;

  factory _$DashboardSeriesPoint(
          [void Function(DashboardSeriesPointBuilder)? updates]) =>
      (new DashboardSeriesPointBuilder()..update(updates))._build();

  _$DashboardSeriesPoint._({required this.count, required this.date})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        count, r'DashboardSeriesPoint', 'count');
    BuiltValueNullFieldError.checkNotNull(
        date, r'DashboardSeriesPoint', 'date');
  }

  @override
  DashboardSeriesPoint rebuild(
          void Function(DashboardSeriesPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardSeriesPointBuilder toBuilder() =>
      new DashboardSeriesPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardSeriesPoint &&
        count == other.count &&
        date == other.date;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardSeriesPoint')
          ..add('count', count)
          ..add('date', date))
        .toString();
  }
}

class DashboardSeriesPointBuilder
    implements Builder<DashboardSeriesPoint, DashboardSeriesPointBuilder> {
  _$DashboardSeriesPoint? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  DashboardSeriesPointBuilder() {
    DashboardSeriesPoint._defaults(this);
  }

  DashboardSeriesPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _date = $v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardSeriesPoint other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardSeriesPoint;
  }

  @override
  void update(void Function(DashboardSeriesPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardSeriesPoint build() => _build();

  _$DashboardSeriesPoint _build() {
    final _$result = _$v ??
        new _$DashboardSeriesPoint._(
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'DashboardSeriesPoint', 'count'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DashboardSeriesPoint', 'date'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
