// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InspectionListPage extends InspectionListPage {
  @override
  final BuiltList<InspectionListItem> items;
  @override
  final String? nextCursor;

  factory _$InspectionListPage(
          [void Function(InspectionListPageBuilder)? updates]) =>
      (new InspectionListPageBuilder()..update(updates))._build();

  _$InspectionListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'InspectionListPage', 'items');
  }

  @override
  InspectionListPage rebuild(
          void Function(InspectionListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InspectionListPageBuilder toBuilder() =>
      new InspectionListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InspectionListPage &&
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
    return (newBuiltValueToStringHelper(r'InspectionListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class InspectionListPageBuilder
    implements Builder<InspectionListPage, InspectionListPageBuilder> {
  _$InspectionListPage? _$v;

  ListBuilder<InspectionListItem>? _items;
  ListBuilder<InspectionListItem> get items =>
      _$this._items ??= new ListBuilder<InspectionListItem>();
  set items(ListBuilder<InspectionListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  InspectionListPageBuilder() {
    InspectionListPage._defaults(this);
  }

  InspectionListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InspectionListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InspectionListPage;
  }

  @override
  void update(void Function(InspectionListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InspectionListPage build() => _build();

  _$InspectionListPage _build() {
    _$InspectionListPage _$result;
    try {
      _$result = _$v ??
          new _$InspectionListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'InspectionListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
