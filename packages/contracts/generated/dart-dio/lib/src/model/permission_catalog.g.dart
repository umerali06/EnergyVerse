// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_catalog.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionCatalog extends PermissionCatalog {
  @override
  final BuiltList<PermissionCatalogGroup> groups;

  factory _$PermissionCatalog(
          [void Function(PermissionCatalogBuilder)? updates]) =>
      (new PermissionCatalogBuilder()..update(updates))._build();

  _$PermissionCatalog._({required this.groups}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        groups, r'PermissionCatalog', 'groups');
  }

  @override
  PermissionCatalog rebuild(void Function(PermissionCatalogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionCatalogBuilder toBuilder() =>
      new PermissionCatalogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionCatalog && groups == other.groups;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionCatalog')
          ..add('groups', groups))
        .toString();
  }
}

class PermissionCatalogBuilder
    implements Builder<PermissionCatalog, PermissionCatalogBuilder> {
  _$PermissionCatalog? _$v;

  ListBuilder<PermissionCatalogGroup>? _groups;
  ListBuilder<PermissionCatalogGroup> get groups =>
      _$this._groups ??= new ListBuilder<PermissionCatalogGroup>();
  set groups(ListBuilder<PermissionCatalogGroup>? groups) =>
      _$this._groups = groups;

  PermissionCatalogBuilder() {
    PermissionCatalog._defaults(this);
  }

  PermissionCatalogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groups = $v.groups.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionCatalog other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermissionCatalog;
  }

  @override
  void update(void Function(PermissionCatalogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionCatalog build() => _build();

  _$PermissionCatalog _build() {
    _$PermissionCatalog _$result;
    try {
      _$result = _$v ?? new _$PermissionCatalog._(groups: groups.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groups';
        groups.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermissionCatalog', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
