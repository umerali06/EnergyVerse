// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitListPage extends PermitListPage {
  @override
  final BuiltList<PermitListItem> items;
  @override
  final String? nextCursor;

  factory _$PermitListPage([void Function(PermitListPageBuilder)? updates]) =>
      (new PermitListPageBuilder()..update(updates))._build();

  _$PermitListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'PermitListPage', 'items');
  }

  @override
  PermitListPage rebuild(void Function(PermitListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitListPageBuilder toBuilder() =>
      new PermitListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitListPage &&
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
    return (newBuiltValueToStringHelper(r'PermitListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PermitListPageBuilder
    implements Builder<PermitListPage, PermitListPageBuilder> {
  _$PermitListPage? _$v;

  ListBuilder<PermitListItem>? _items;
  ListBuilder<PermitListItem> get items =>
      _$this._items ??= new ListBuilder<PermitListItem>();
  set items(ListBuilder<PermitListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PermitListPageBuilder() {
    PermitListPage._defaults(this);
  }

  PermitListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitListPage;
  }

  @override
  void update(void Function(PermitListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitListPage build() => _build();

  _$PermitListPage _build() {
    _$PermitListPage _$result;
    try {
      _$result = _$v ??
          new _$PermitListPage._(items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermitListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
