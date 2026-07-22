// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FacilityListPage extends FacilityListPage {
  @override
  final BuiltList<FacilityDetail> items;
  @override
  final String? nextCursor;

  factory _$FacilityListPage(
          [void Function(FacilityListPageBuilder)? updates]) =>
      (new FacilityListPageBuilder()..update(updates))._build();

  _$FacilityListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'FacilityListPage', 'items');
  }

  @override
  FacilityListPage rebuild(void Function(FacilityListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityListPageBuilder toBuilder() =>
      new FacilityListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FacilityListPage &&
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
    return (newBuiltValueToStringHelper(r'FacilityListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class FacilityListPageBuilder
    implements Builder<FacilityListPage, FacilityListPageBuilder> {
  _$FacilityListPage? _$v;

  ListBuilder<FacilityDetail>? _items;
  ListBuilder<FacilityDetail> get items =>
      _$this._items ??= new ListBuilder<FacilityDetail>();
  set items(ListBuilder<FacilityDetail>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  FacilityListPageBuilder() {
    FacilityListPage._defaults(this);
  }

  FacilityListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FacilityListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FacilityListPage;
  }

  @override
  void update(void Function(FacilityListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FacilityListPage build() => _build();

  _$FacilityListPage _build() {
    _$FacilityListPage _$result;
    try {
      _$result = _$v ??
          new _$FacilityListPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'FacilityListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
