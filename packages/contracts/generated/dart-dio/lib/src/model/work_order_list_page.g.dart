// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkOrderListPage extends WorkOrderListPage {
  @override
  final BuiltList<WorkOrderListItem> items;
  @override
  final String? nextCursor;

  factory _$WorkOrderListPage(
          [void Function(WorkOrderListPageBuilder)? updates]) =>
      (new WorkOrderListPageBuilder()..update(updates))._build();

  _$WorkOrderListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'WorkOrderListPage', 'items');
  }

  @override
  WorkOrderListPage rebuild(void Function(WorkOrderListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkOrderListPageBuilder toBuilder() =>
      new WorkOrderListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkOrderListPage &&
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
    return (newBuiltValueToStringHelper(r'WorkOrderListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class WorkOrderListPageBuilder
    implements Builder<WorkOrderListPage, WorkOrderListPageBuilder> {
  _$WorkOrderListPage? _$v;

  ListBuilder<WorkOrderListItem>? _items;
  ListBuilder<WorkOrderListItem> get items =>
      _$this._items ??= new ListBuilder<WorkOrderListItem>();
  set items(ListBuilder<WorkOrderListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  WorkOrderListPageBuilder() {
    WorkOrderListPage._defaults(this);
  }

  WorkOrderListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkOrderListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkOrderListPage;
  }

  @override
  void update(void Function(WorkOrderListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkOrderListPage build() => _build();

  _$WorkOrderListPage _build() {
    _$WorkOrderListPage _$result;
    try {
      _$result = _$v ??
          new _$WorkOrderListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkOrderListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
