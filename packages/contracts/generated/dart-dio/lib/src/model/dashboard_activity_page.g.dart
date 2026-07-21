// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_activity_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardActivityPage extends DashboardActivityPage {
  @override
  final BuiltList<DashboardActivityItem> items;
  @override
  final String? nextCursor;

  factory _$DashboardActivityPage(
          [void Function(DashboardActivityPageBuilder)? updates]) =>
      (new DashboardActivityPageBuilder()..update(updates))._build();

  _$DashboardActivityPage._({required this.items, this.nextCursor})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'DashboardActivityPage', 'items');
  }

  @override
  DashboardActivityPage rebuild(
          void Function(DashboardActivityPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardActivityPageBuilder toBuilder() =>
      new DashboardActivityPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardActivityPage &&
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
    return (newBuiltValueToStringHelper(r'DashboardActivityPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class DashboardActivityPageBuilder
    implements Builder<DashboardActivityPage, DashboardActivityPageBuilder> {
  _$DashboardActivityPage? _$v;

  ListBuilder<DashboardActivityItem>? _items;
  ListBuilder<DashboardActivityItem> get items =>
      _$this._items ??= new ListBuilder<DashboardActivityItem>();
  set items(ListBuilder<DashboardActivityItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  DashboardActivityPageBuilder() {
    DashboardActivityPage._defaults(this);
  }

  DashboardActivityPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardActivityPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardActivityPage;
  }

  @override
  void update(void Function(DashboardActivityPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardActivityPage build() => _build();

  _$DashboardActivityPage _build() {
    _$DashboardActivityPage _$result;
    try {
      _$result = _$v ??
          new _$DashboardActivityPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DashboardActivityPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
