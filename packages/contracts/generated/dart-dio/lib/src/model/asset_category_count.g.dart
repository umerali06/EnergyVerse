// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_category_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetCategoryCount extends AssetCategoryCount {
  @override
  final String category;
  @override
  final int count;

  factory _$AssetCategoryCount(
          [void Function(AssetCategoryCountBuilder)? updates]) =>
      (new AssetCategoryCountBuilder()..update(updates))._build();

  _$AssetCategoryCount._({required this.category, required this.count})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'AssetCategoryCount', 'category');
    BuiltValueNullFieldError.checkNotNull(
        count, r'AssetCategoryCount', 'count');
  }

  @override
  AssetCategoryCount rebuild(
          void Function(AssetCategoryCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetCategoryCountBuilder toBuilder() =>
      new AssetCategoryCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetCategoryCount &&
        category == other.category &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetCategoryCount')
          ..add('category', category)
          ..add('count', count))
        .toString();
  }
}

class AssetCategoryCountBuilder
    implements Builder<AssetCategoryCount, AssetCategoryCountBuilder> {
  _$AssetCategoryCount? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  AssetCategoryCountBuilder() {
    AssetCategoryCount._defaults(this);
  }

  AssetCategoryCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetCategoryCount other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetCategoryCount;
  }

  @override
  void update(void Function(AssetCategoryCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetCategoryCount build() => _build();

  _$AssetCategoryCount _build() {
    final _$result = _$v ??
        new _$AssetCategoryCount._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'AssetCategoryCount', 'category'),
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'AssetCategoryCount', 'count'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
