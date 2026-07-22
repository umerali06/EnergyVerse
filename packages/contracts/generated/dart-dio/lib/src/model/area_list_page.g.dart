// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AreaListPage extends AreaListPage {
  @override
  final BuiltList<AreaDetail> items;
  @override
  final String? nextCursor;

  factory _$AreaListPage([void Function(AreaListPageBuilder)? updates]) =>
      (new AreaListPageBuilder()..update(updates))._build();

  _$AreaListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'AreaListPage', 'items');
  }

  @override
  AreaListPage rebuild(void Function(AreaListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AreaListPageBuilder toBuilder() => new AreaListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AreaListPage &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AreaListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AreaListPageBuilder
    implements Builder<AreaListPage, AreaListPageBuilder> {
  _$AreaListPage? _$v;

  ListBuilder<AreaDetail>? _items;
  ListBuilder<AreaDetail> get items =>
      _$this._items ??= new ListBuilder<AreaDetail>();
  set items(ListBuilder<AreaDetail>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AreaListPageBuilder() {
    AreaListPage._defaults(this);
  }

  AreaListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AreaListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AreaListPage;
  }

  @override
  void update(void Function(AreaListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AreaListPage build() => _build();

  _$AreaListPage _build() {
    _$AreaListPage _$result;
    try {
      _$result = _$v ??
          new _$AreaListPage._(items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AreaListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
