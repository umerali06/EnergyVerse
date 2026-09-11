// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_report_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SafetyReportListPage extends SafetyReportListPage {
  @override
  final BuiltList<SafetyReportListItem> items;
  @override
  final String? nextCursor;

  factory _$SafetyReportListPage(
          [void Function(SafetyReportListPageBuilder)? updates]) =>
      (new SafetyReportListPageBuilder()..update(updates))._build();

  _$SafetyReportListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'SafetyReportListPage', 'items');
  }

  @override
  SafetyReportListPage rebuild(
          void Function(SafetyReportListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SafetyReportListPageBuilder toBuilder() =>
      new SafetyReportListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SafetyReportListPage &&
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
    return (newBuiltValueToStringHelper(r'SafetyReportListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class SafetyReportListPageBuilder
    implements Builder<SafetyReportListPage, SafetyReportListPageBuilder> {
  _$SafetyReportListPage? _$v;

  ListBuilder<SafetyReportListItem>? _items;
  ListBuilder<SafetyReportListItem> get items =>
      _$this._items ??= new ListBuilder<SafetyReportListItem>();
  set items(ListBuilder<SafetyReportListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  SafetyReportListPageBuilder() {
    SafetyReportListPage._defaults(this);
  }

  SafetyReportListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SafetyReportListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SafetyReportListPage;
  }

  @override
  void update(void Function(SafetyReportListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SafetyReportListPage build() => _build();

  _$SafetyReportListPage _build() {
    _$SafetyReportListPage _$result;
    try {
      _$result = _$v ??
          new _$SafetyReportListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SafetyReportListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
