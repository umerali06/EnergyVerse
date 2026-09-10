import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;

/// Drives the notifications screen and the unread badge.
///
/// Notifications are personal: the backend filters on the signed-in user, so
/// there is no permission gate here and nothing to scope client-side.
class NotificationsController extends ChangeNotifier {
  NotificationsController({required NotificationsApiContract api}) : _api = api;

  final NotificationsApiContract _api;

  LoadStatus _status = LoadStatus.loading;
  LoadStatus get status => _status;

  List<NotificationResponse> _items = const [];
  List<NotificationResponse> get items => _items;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _unreadOnly = false;
  bool get unreadOnly => _unreadOnly;

  void start() {
    load();
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      final page = await _api.getNotifications(unreadOnly: _unreadOnly);
      // Both fields carry schema defaults, so the generated model types them
      // as nullable even though the server always sends them.
      _items = page.items?.toList() ?? const [];
      // Always the full unread total, not the filtered page, so the badge
      // stays correct while the "unread only" filter is on.
      _unreadCount = page.unreadCount ?? 0;
      _status = LoadStatus.ready;
    } catch (error) {
      debugPrint('[NotificationsController] load error: $error');
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> setUnreadOnly(bool value) async {
    if (_unreadOnly == value) return;
    _unreadOnly = value;
    await load();
  }

  /// Optimistic: the badge drops immediately so opening a record feels
  /// instant. A failed call is corrected by the next [load].
  Future<void> markRead(String notificationId) async {
    final index = _items.indexWhere((item) => item.id == notificationId);
    if (index == -1 || _items[index].readAt != null) return;

    final previous = _items;
    final previousUnread = _unreadCount;
    _items = [
      for (final item in _items)
        if (item.id == notificationId)
          item.rebuild((b) => b..readAt = DateTime.now().toUtc())
        else
          item,
    ];
    _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
    notifyListeners();

    try {
      await _api.markNotificationRead(notificationId);
    } catch (error) {
      debugPrint('[NotificationsController] markRead error: $error');
      _items = previous;
      _unreadCount = previousUnread;
      notifyListeners();
    }
  }

  Future<void> markAllRead() async {
    if (_unreadCount == 0) return;
    try {
      await _api.markAllNotificationsRead();
    } catch (error) {
      debugPrint('[NotificationsController] markAllRead error: $error');
    }
    await load();
  }
}
