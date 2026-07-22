// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformStats extends PlatformStats {
  @override
  final int activeTenants;
  @override
  final int recentSignups;
  @override
  final int totalCompanies;
  @override
  final int totalUsers;
  @override
  final int windowDays;

  factory _$PlatformStats([void Function(PlatformStatsBuilder)? updates]) =>
      (new PlatformStatsBuilder()..update(updates))._build();

  _$PlatformStats._(
      {required this.activeTenants,
      required this.recentSignups,
      required this.totalCompanies,
      required this.totalUsers,
      required this.windowDays})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        activeTenants, r'PlatformStats', 'activeTenants');
    BuiltValueNullFieldError.checkNotNull(
        recentSignups, r'PlatformStats', 'recentSignups');
    BuiltValueNullFieldError.checkNotNull(
        totalCompanies, r'PlatformStats', 'totalCompanies');
    BuiltValueNullFieldError.checkNotNull(
        totalUsers, r'PlatformStats', 'totalUsers');
    BuiltValueNullFieldError.checkNotNull(
        windowDays, r'PlatformStats', 'windowDays');
  }

  @override
  PlatformStats rebuild(void Function(PlatformStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformStatsBuilder toBuilder() => new PlatformStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformStats &&
        activeTenants == other.activeTenants &&
        recentSignups == other.recentSignups &&
        totalCompanies == other.totalCompanies &&
        totalUsers == other.totalUsers &&
        windowDays == other.windowDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activeTenants.hashCode);
    _$hash = $jc(_$hash, recentSignups.hashCode);
    _$hash = $jc(_$hash, totalCompanies.hashCode);
    _$hash = $jc(_$hash, totalUsers.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformStats')
          ..add('activeTenants', activeTenants)
          ..add('recentSignups', recentSignups)
          ..add('totalCompanies', totalCompanies)
          ..add('totalUsers', totalUsers)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class PlatformStatsBuilder
    implements Builder<PlatformStats, PlatformStatsBuilder> {
  _$PlatformStats? _$v;

  int? _activeTenants;
  int? get activeTenants => _$this._activeTenants;
  set activeTenants(int? activeTenants) =>
      _$this._activeTenants = activeTenants;

  int? _recentSignups;
  int? get recentSignups => _$this._recentSignups;
  set recentSignups(int? recentSignups) =>
      _$this._recentSignups = recentSignups;

  int? _totalCompanies;
  int? get totalCompanies => _$this._totalCompanies;
  set totalCompanies(int? totalCompanies) =>
      _$this._totalCompanies = totalCompanies;

  int? _totalUsers;
  int? get totalUsers => _$this._totalUsers;
  set totalUsers(int? totalUsers) => _$this._totalUsers = totalUsers;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  PlatformStatsBuilder() {
    PlatformStats._defaults(this);
  }

  PlatformStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activeTenants = $v.activeTenants;
      _recentSignups = $v.recentSignups;
      _totalCompanies = $v.totalCompanies;
      _totalUsers = $v.totalUsers;
      _windowDays = $v.windowDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformStats other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PlatformStats;
  }

  @override
  void update(void Function(PlatformStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformStats build() => _build();

  _$PlatformStats _build() {
    final _$result = _$v ??
        new _$PlatformStats._(
            activeTenants: BuiltValueNullFieldError.checkNotNull(
                activeTenants, r'PlatformStats', 'activeTenants'),
            recentSignups: BuiltValueNullFieldError.checkNotNull(
                recentSignups, r'PlatformStats', 'recentSignups'),
            totalCompanies: BuiltValueNullFieldError.checkNotNull(
                totalCompanies, r'PlatformStats', 'totalCompanies'),
            totalUsers: BuiltValueNullFieldError.checkNotNull(
                totalUsers, r'PlatformStats', 'totalUsers'),
            windowDays: BuiltValueNullFieldError.checkNotNull(
                windowDays, r'PlatformStats', 'windowDays'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
