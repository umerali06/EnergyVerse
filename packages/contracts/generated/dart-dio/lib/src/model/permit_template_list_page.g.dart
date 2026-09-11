// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_template_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitTemplateListPage extends PermitTemplateListPage {
  @override
  final BuiltList<PermitTemplateListItem> items;
  @override
  final String? nextCursor;

  factory _$PermitTemplateListPage(
          [void Function(PermitTemplateListPageBuilder)? updates]) =>
      (new PermitTemplateListPageBuilder()..update(updates))._build();

  _$PermitTemplateListPage._({required this.items, this.nextCursor})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'PermitTemplateListPage', 'items');
  }

  @override
  PermitTemplateListPage rebuild(
          void Function(PermitTemplateListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitTemplateListPageBuilder toBuilder() =>
      new PermitTemplateListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitTemplateListPage &&
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
    return (newBuiltValueToStringHelper(r'PermitTemplateListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PermitTemplateListPageBuilder
    implements Builder<PermitTemplateListPage, PermitTemplateListPageBuilder> {
  _$PermitTemplateListPage? _$v;

  ListBuilder<PermitTemplateListItem>? _items;
  ListBuilder<PermitTemplateListItem> get items =>
      _$this._items ??= new ListBuilder<PermitTemplateListItem>();
  set items(ListBuilder<PermitTemplateListItem>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PermitTemplateListPageBuilder() {
    PermitTemplateListPage._defaults(this);
  }

  PermitTemplateListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitTemplateListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitTemplateListPage;
  }

  @override
  void update(void Function(PermitTemplateListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitTemplateListPage build() => _build();

  _$PermitTemplateListPage _build() {
    _$PermitTemplateListPage _$result;
    try {
      _$result = _$v ??
          new _$PermitTemplateListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermitTemplateListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
