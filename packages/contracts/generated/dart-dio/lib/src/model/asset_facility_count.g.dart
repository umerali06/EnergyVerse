// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_facility_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetFacilityCount extends AssetFacilityCount {
  @override
  final int count;
  @override
  final String facilityId;
  @override
  final String facilityName;

  factory _$AssetFacilityCount(
          [void Function(AssetFacilityCountBuilder)? updates]) =>
      (new AssetFacilityCountBuilder()..update(updates))._build();

  _$AssetFacilityCount._(
      {required this.count,
      required this.facilityId,
      required this.facilityName})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        count, r'AssetFacilityCount', 'count');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'AssetFacilityCount', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(
        facilityName, r'AssetFacilityCount', 'facilityName');
  }

  @override
  AssetFacilityCount rebuild(
          void Function(AssetFacilityCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetFacilityCountBuilder toBuilder() =>
      new AssetFacilityCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetFacilityCount &&
        count == other.count &&
        facilityId == other.facilityId &&
        facilityName == other.facilityName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, facilityName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetFacilityCount')
          ..add('count', count)
          ..add('facilityId', facilityId)
          ..add('facilityName', facilityName))
        .toString();
  }
}

class AssetFacilityCountBuilder
    implements Builder<AssetFacilityCount, AssetFacilityCountBuilder> {
  _$AssetFacilityCount? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _facilityName;
  String? get facilityName => _$this._facilityName;
  set facilityName(String? facilityName) => _$this._facilityName = facilityName;

  AssetFacilityCountBuilder() {
    AssetFacilityCount._defaults(this);
  }

  AssetFacilityCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _facilityId = $v.facilityId;
      _facilityName = $v.facilityName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetFacilityCount other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetFacilityCount;
  }

  @override
  void update(void Function(AssetFacilityCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetFacilityCount build() => _build();

  _$AssetFacilityCount _build() {
    final _$result = _$v ??
        new _$AssetFacilityCount._(
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'AssetFacilityCount', 'count'),
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'AssetFacilityCount', 'facilityId'),
            facilityName: BuiltValueNullFieldError.checkNotNull(
                facilityName, r'AssetFacilityCount', 'facilityName'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
