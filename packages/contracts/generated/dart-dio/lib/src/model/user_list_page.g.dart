// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserListPage extends UserListPage {
  @override
  final BuiltList<UserListItem> items;
  @override
  final String? nextCursor;

  factory _$UserListPage([void Function(UserListPageBuilder)? updates]) =>
      (new UserListPageBuilder()..update(updates))._build();

  _$UserListPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'UserListPage', 'items');
  }

  @override
  UserListPage rebuild(void Function(UserListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserListPageBuilder toBuilder() => new UserListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserListPage &&
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
    return (newBuiltValueToStringHelper(r'UserListPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class UserListPageBuilder
    implements Builder<UserListPage, UserListPageBuilder> {
  _$UserListPage? _$v;

  ListBuilder<UserListItem>? _items;
  ListBuilder<UserListItem> get items =>
      _$this._items ??= new ListBuilder<UserListItem>();
  set items(ListBuilder<UserListItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  UserListPageBuilder() {
    UserListPage._defaults(this);
  }

  UserListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserListPage;
  }

  @override
  void update(void Function(UserListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserListPage build() => _build();

  _$UserListPage _build() {
    _$UserListPage _$result;
    try {
      _$result = _$v ??
          new _$UserListPage._(items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
