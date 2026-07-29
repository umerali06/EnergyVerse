// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChecklistTemplateListPage extends ChecklistTemplateListPage {
  @override
  final BuiltList<ChecklistTemplateListItem> items;
  @override
  final String? nextCursor;

  factory _$ChecklistTemplateListPage(
          [void Function(ChecklistTemplateListPageBuilder)? updates]) =>
      (new ChecklistTemplateListPageBuilder()..update(updates))._build();

  _$ChecklistTemplateListPage._({required this.items, this.nextCursor})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'ChecklistTemplateListPage', 'items');
  }

  @override
  ChecklistTemplateListPage rebuild(
          void Function(ChecklistTemplateListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateListPageBuilder toBuilder() =>
      new ChecklistTemplateListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateListPage &&
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
    return (newBuiltValueToStringHelper(r'ChecklistTemplateListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class ChecklistTemplateListPageBuilder
    implements
        Builder<ChecklistTemplateListPage, ChecklistTemplateListPageBuilder> {
  _$ChecklistTemplateListPage? _$v;

  ListBuilder<ChecklistTemplateListItem>? _items;
  ListBuilder<ChecklistTemplateListItem> get items =>
      _$this._items ??= new ListBuilder<ChecklistTemplateListItem>();
  set items(ListBuilder<ChecklistTemplateListItem>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  ChecklistTemplateListPageBuilder() {
    ChecklistTemplateListPage._defaults(this);
  }

  ChecklistTemplateListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistTemplateListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateListPage;
  }

  @override
  void update(void Function(ChecklistTemplateListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateListPage build() => _build();

  _$ChecklistTemplateListPage _build() {
    _$ChecklistTemplateListPage _$result;
    try {
      _$result = _$v ??
          new _$ChecklistTemplateListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChecklistTemplateListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
