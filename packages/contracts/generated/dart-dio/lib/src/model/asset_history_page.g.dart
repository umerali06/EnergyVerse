// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetHistoryPage extends AssetHistoryPage {
  @override
  final BuiltList<AssetHistoryEvent>? items;
  @override
  final String? nextCursor;

  factory _$AssetHistoryPage(
          [void Function(AssetHistoryPageBuilder)? updates]) =>
      (new AssetHistoryPageBuilder()..update(updates))._build();

  _$AssetHistoryPage._({this.items, this.nextCursor}) : super._();

  @override
  AssetHistoryPage rebuild(void Function(AssetHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetHistoryPageBuilder toBuilder() =>
      new AssetHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'AssetHistoryPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AssetHistoryPageBuilder
    implements Builder<AssetHistoryPage, AssetHistoryPageBuilder> {
  _$AssetHistoryPage? _$v;

  ListBuilder<AssetHistoryEvent>? _items;
  ListBuilder<AssetHistoryEvent> get items =>
      _$this._items ??= new ListBuilder<AssetHistoryEvent>();
  set items(ListBuilder<AssetHistoryEvent>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AssetHistoryPageBuilder() {
    AssetHistoryPage._defaults(this);
  }

  AssetHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items?.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetHistoryPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetHistoryPage;
  }

  @override
  void update(void Function(AssetHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetHistoryPage build() => _build();

  _$AssetHistoryPage _build() {
    _$AssetHistoryPage _$result;
    try {
      _$result = _$v ??
          new _$AssetHistoryPage._(
              items: _items?.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AssetHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
