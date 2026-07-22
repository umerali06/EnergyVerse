// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_catalog_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionCatalogGroup extends PermissionCatalogGroup {
  @override
  final String group;
  @override
  final BuiltList<PermissionCatalogItem> items;

  factory _$PermissionCatalogGroup(
          [void Function(PermissionCatalogGroupBuilder)? updates]) =>
      (new PermissionCatalogGroupBuilder()..update(updates))._build();

  _$PermissionCatalogGroup._({required this.group, required this.items})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        group, r'PermissionCatalogGroup', 'group');
    BuiltValueNullFieldError.checkNotNull(
        items, r'PermissionCatalogGroup', 'items');
  }

  @override
  PermissionCatalogGroup rebuild(
          void Function(PermissionCatalogGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionCatalogGroupBuilder toBuilder() =>
      new PermissionCatalogGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionCatalogGroup &&
        group == other.group &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionCatalogGroup')
          ..add('group', group)
          ..add('items', items))
        .toString();
  }
}

class PermissionCatalogGroupBuilder
    implements Builder<PermissionCatalogGroup, PermissionCatalogGroupBuilder> {
  _$PermissionCatalogGroup? _$v;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  ListBuilder<PermissionCatalogItem>? _items;
  ListBuilder<PermissionCatalogItem> get items =>
      _$this._items ??= new ListBuilder<PermissionCatalogItem>();
  set items(ListBuilder<PermissionCatalogItem>? items) => _$this._items = items;

  PermissionCatalogGroupBuilder() {
    PermissionCatalogGroup._defaults(this);
  }

  PermissionCatalogGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _group = $v.group;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionCatalogGroup other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermissionCatalogGroup;
  }

  @override
  void update(void Function(PermissionCatalogGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionCatalogGroup build() => _build();

  _$PermissionCatalogGroup _build() {
    _$PermissionCatalogGroup _$result;
    try {
      _$result = _$v ??
          new _$PermissionCatalogGroup._(
              group: BuiltValueNullFieldError.checkNotNull(
                  group, r'PermissionCatalogGroup', 'group'),
              items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermissionCatalogGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
