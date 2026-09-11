// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_report_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeneratedReportListPage extends GeneratedReportListPage {
  @override
  final BuiltList<GeneratedReportListItem> items;
  @override
  final String? nextCursor;

  factory _$GeneratedReportListPage(
          [void Function(GeneratedReportListPageBuilder)? updates]) =>
      (new GeneratedReportListPageBuilder()..update(updates))._build();

  _$GeneratedReportListPage._({required this.items, this.nextCursor})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'GeneratedReportListPage', 'items');
  }

  @override
  GeneratedReportListPage rebuild(
          void Function(GeneratedReportListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeneratedReportListPageBuilder toBuilder() =>
      new GeneratedReportListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeneratedReportListPage &&
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
    return (newBuiltValueToStringHelper(r'GeneratedReportListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GeneratedReportListPageBuilder
    implements
        Builder<GeneratedReportListPage, GeneratedReportListPageBuilder> {
  _$GeneratedReportListPage? _$v;

  ListBuilder<GeneratedReportListItem>? _items;
  ListBuilder<GeneratedReportListItem> get items =>
      _$this._items ??= new ListBuilder<GeneratedReportListItem>();
  set items(ListBuilder<GeneratedReportListItem>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GeneratedReportListPageBuilder() {
    GeneratedReportListPage._defaults(this);
  }

  GeneratedReportListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeneratedReportListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GeneratedReportListPage;
  }

  @override
  void update(void Function(GeneratedReportListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeneratedReportListPage build() => _build();

  _$GeneratedReportListPage _build() {
    _$GeneratedReportListPage _$result;
    try {
      _$result = _$v ??
          new _$GeneratedReportListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GeneratedReportListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
