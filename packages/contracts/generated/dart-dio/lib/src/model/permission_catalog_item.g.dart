// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_catalog_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionCatalogItem extends PermissionCatalogItem {
  @override
  final String description;
  @override
  final String group;
  @override
  final String key;

  factory _$PermissionCatalogItem(
          [void Function(PermissionCatalogItemBuilder)? updates]) =>
      (new PermissionCatalogItemBuilder()..update(updates))._build();

  _$PermissionCatalogItem._(
      {required this.description, required this.group, required this.key})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'PermissionCatalogItem', 'description');
    BuiltValueNullFieldError.checkNotNull(
        group, r'PermissionCatalogItem', 'group');
    BuiltValueNullFieldError.checkNotNull(key, r'PermissionCatalogItem', 'key');
  }

  @override
  PermissionCatalogItem rebuild(
          void Function(PermissionCatalogItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionCatalogItemBuilder toBuilder() =>
      new PermissionCatalogItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionCatalogItem &&
        description == other.description &&
        group == other.group &&
        key == other.key;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionCatalogItem')
          ..add('description', description)
          ..add('group', group)
          ..add('key', key))
        .toString();
  }
}

class PermissionCatalogItemBuilder
    implements Builder<PermissionCatalogItem, PermissionCatalogItemBuilder> {
  _$PermissionCatalogItem? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  PermissionCatalogItemBuilder() {
    PermissionCatalogItem._defaults(this);
  }

  PermissionCatalogItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _group = $v.group;
      _key = $v.key;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionCatalogItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermissionCatalogItem;
  }

  @override
  void update(void Function(PermissionCatalogItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionCatalogItem build() => _build();

  _$PermissionCatalogItem _build() {
    final _$result = _$v ??
        new _$PermissionCatalogItem._(
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'PermissionCatalogItem', 'description'),
            group: BuiltValueNullFieldError.checkNotNull(
                group, r'PermissionCatalogItem', 'group'),
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'PermissionCatalogItem', 'key'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
