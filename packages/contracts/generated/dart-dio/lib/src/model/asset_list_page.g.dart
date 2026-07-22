// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetListPage extends AssetListPage {
  @override
  final BuiltList<AssetListItem> items;
  @override
  final String? nextCursor;

  factory _$AssetListPage([void Function(AssetListPageBuilder)? updates]) =>
      (new AssetListPageBuilder()..update(updates))._build();

  _$AssetListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'AssetListPage', 'items');
  }

  @override
  AssetListPage rebuild(void Function(AssetListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetListPageBuilder toBuilder() => new AssetListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetListPage &&
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
    return (newBuiltValueToStringHelper(r'AssetListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AssetListPageBuilder
    implements Builder<AssetListPage, AssetListPageBuilder> {
  _$AssetListPage? _$v;

  ListBuilder<AssetListItem>? _items;
  ListBuilder<AssetListItem> get items =>
      _$this._items ??= new ListBuilder<AssetListItem>();
  set items(ListBuilder<AssetListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AssetListPageBuilder() {
    AssetListPage._defaults(this);
  }

  AssetListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetListPage;
  }

  @override
  void update(void Function(AssetListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetListPage build() => _build();

  _$AssetListPage _build() {
    _$AssetListPage _$result;
    try {
      _$result = _$v ??
          new _$AssetListPage._(items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AssetListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
