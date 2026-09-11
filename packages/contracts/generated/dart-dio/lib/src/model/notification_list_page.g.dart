// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationListPage extends NotificationListPage {
  @override
  final BuiltList<NotificationResponse>? items;
  @override
  final int? unreadCount;

  factory _$NotificationListPage(
          [void Function(NotificationListPageBuilder)? updates]) =>
      (new NotificationListPageBuilder()..update(updates))._build();

  _$NotificationListPage._({this.items, this.unreadCount}) : super._();

  @override
  NotificationListPage rebuild(
          void Function(NotificationListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationListPageBuilder toBuilder() =>
      new NotificationListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationListPage &&
        items == other.items &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationListPage')
          ..add('items', items)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class NotificationListPageBuilder
    implements Builder<NotificationListPage, NotificationListPageBuilder> {
  _$NotificationListPage? _$v;

  ListBuilder<NotificationResponse>? _items;
  ListBuilder<NotificationResponse> get items =>
      _$this._items ??= new ListBuilder<NotificationResponse>();
  set items(ListBuilder<NotificationResponse>? items) => _$this._items = items;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  NotificationListPageBuilder() {
    NotificationListPage._defaults(this);
  }

  NotificationListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items?.toBuilder();
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationListPage;
  }

  @override
  void update(void Function(NotificationListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationListPage build() => _build();

  _$NotificationListPage _build() {
    _$NotificationListPage _$result;
    try {
      _$result = _$v ??
          new _$NotificationListPage._(
              items: _items?.build(), unreadCount: unreadCount);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
