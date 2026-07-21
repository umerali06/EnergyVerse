// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleList extends RoleList {
  @override
  final BuiltList<RoleSummary> items;

  factory _$RoleList([void Function(RoleListBuilder)? updates]) =>
      (new RoleListBuilder()..update(updates))._build();

  _$RoleList._({required this.items}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'RoleList', 'items');
  }

  @override
  RoleList rebuild(void Function(RoleListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleListBuilder toBuilder() => new RoleListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleList && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleList')..add('items', items))
        .toString();
  }
}

class RoleListBuilder implements Builder<RoleList, RoleListBuilder> {
  _$RoleList? _$v;

  ListBuilder<RoleSummary>? _items;
  ListBuilder<RoleSummary> get items =>
      _$this._items ??= new ListBuilder<RoleSummary>();
  set items(ListBuilder<RoleSummary>? items) => _$this._items = items;

  RoleListBuilder() {
    RoleList._defaults(this);
  }

  RoleListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoleList;
  }

  @override
  void update(void Function(RoleListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleList build() => _build();

  _$RoleList _build() {
    _$RoleList _$result;
    try {
      _$result = _$v ?? new _$RoleList._(items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RoleList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
