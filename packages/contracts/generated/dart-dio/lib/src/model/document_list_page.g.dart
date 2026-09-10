// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentListPage extends DocumentListPage {
  @override
  final BuiltList<DocumentListItem> items;
  @override
  final String? nextCursor;

  factory _$DocumentListPage(
          [void Function(DocumentListPageBuilder)? updates]) =>
      (new DocumentListPageBuilder()..update(updates))._build();

  _$DocumentListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'DocumentListPage', 'items');
  }

  @override
  DocumentListPage rebuild(void Function(DocumentListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentListPageBuilder toBuilder() =>
      new DocumentListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentListPage &&
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
    return (newBuiltValueToStringHelper(r'DocumentListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class DocumentListPageBuilder
    implements Builder<DocumentListPage, DocumentListPageBuilder> {
  _$DocumentListPage? _$v;

  ListBuilder<DocumentListItem>? _items;
  ListBuilder<DocumentListItem> get items =>
      _$this._items ??= new ListBuilder<DocumentListItem>();
  set items(ListBuilder<DocumentListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  DocumentListPageBuilder() {
    DocumentListPage._defaults(this);
  }

  DocumentListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentListPage;
  }

  @override
  void update(void Function(DocumentListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentListPage build() => _build();

  _$DocumentListPage _build() {
    _$DocumentListPage _$result;
    try {
      _$result = _$v ??
          new _$DocumentListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DocumentListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
