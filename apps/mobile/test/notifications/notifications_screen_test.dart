import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationsApi implements NotificationsApiContract {
  FakeNotificationsApi({this.notifications = const [], this.failLoad = false});

  List<NotificationResponse> notifications;
  bool failLoad;
  final List<String> readCalls = <String>[];
  int markAllCalls = 0;

  @override
  Future<NotificationListPage> getNotifications({bool unreadOnly = false}) async {
    if (failLoad) {
      throw const ApiException(code: 'boom', message: 'upstream unavailable');
    }
    final visible = unreadOnly
        ? notifications.where((n) => n.readAt == null).toList()
        : notifications;
    return NotificationListPage((b) => b
      ..items.addAll(visible)
      ..unreadCount = notifications.where((n) => n.readAt == null).length);
  }

  @override
  Future<NotificationRead> markNotificationRead(String notificationId) async {
    readCalls.add(notificationId);
    return NotificationRead((b) => b
      ..id = notificationId
      ..readAt = DateTime.now().toUtc());
  }

  @override
  Future<NotificationsAllRead> markAllNotificationsRead() async {
    markAllCalls += 1;
    notifications = [
      for (final n in notifications)
        n.readAt == null ? n.rebuild((b) => b..readAt = DateTime.now().toUtc()) : n,
    ];
    return NotificationsAllRead((b) => b..marked = 1);
  }

  @override
  Future<DeviceRegistered> registerNotificationDevice(
    RegisterDeviceRequest request,
  ) async =>
      DeviceRegistered((b) => b..registered = true);

  @override
  Future<DeviceUnregistered> unregisterNotificationDevice(String token) async =>
      DeviceUnregistered((b) => b..unregistered = true);
}

NotificationResponse _notification({
  String id = 'notification-1',
  String title = 'New work order assigned',
  DateTime? readAt,
}) {
  return NotificationResponse((b) => b
    ..id = id
    ..event = 'work_order.assigned'
    ..title = title
    ..body = 'Replace pump seal was assigned to you.'
    ..targetType = 'work_order'
    ..targetId = 'wo-1'
    ..readAt = readAt
    ..createdAt = DateTime.utc(2026, 9, 1, 10));
}

Widget _wrap(NotificationsApiContract api) {
  return MaterialApp(
    theme: AppThemes.light,
    home: Scaffold(body: NotificationsScreen(api: api)),
    // Opening a notification routes to the record it points at. The real route
    // table lives in app_routes.dart; this stub just has to accept the push.
    onGenerateRoute: (settings) => MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(body: Text('route:${settings.name}')),
    ),
  );
}

void main() {
  testWidgets('renders the unread count and the notification list', (tester) async {
    await tester.pumpWidget(_wrap(
      FakeNotificationsApi(notifications: [_notification()]),
    ));
    await tester.pumpAndSettle();

    expect(find.text('1 unread'), findsOneWidget);
    expect(find.text('New work order assigned'), findsOneWidget);
  });

  testWidgets('shows a failure state, not an empty inbox, when loading fails',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeNotificationsApi(failLoad: true)));
    await tester.pumpAndSettle();

    // A failed request must never be presented as "no notifications".
    expect(find.text('Notifications could not be loaded.'), findsOneWidget);
    expect(find.text('You have no notifications yet.'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('recovers the list when the retry succeeds', (tester) async {
    final api = FakeNotificationsApi(
      notifications: [_notification()],
      failLoad: true,
    );
    await tester.pumpWidget(_wrap(api));
    await tester.pumpAndSettle();

    api.failLoad = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('New work order assigned'), findsOneWidget);
  });

  testWidgets('shows an honest empty state when there is nothing to show',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeNotificationsApi()));
    await tester.pumpAndSettle();

    expect(find.text('You have no notifications yet.'), findsOneWidget);
  });

  testWidgets('tapping a notification marks it read', (tester) async {
    final api = FakeNotificationsApi(notifications: [_notification()]);
    await tester.pumpWidget(_wrap(api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New work order assigned'));
    await tester.pumpAndSettle();

    expect(api.readCalls, ['notification-1']);
  });

  testWidgets('mark all read clears the unread count', (tester) async {
    final api = FakeNotificationsApi(
      notifications: [_notification(), _notification(id: 'notification-2')],
    );
    await tester.pumpWidget(_wrap(api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();

    expect(api.markAllCalls, 1);
    expect(find.text('All caught up'), findsOneWidget);
  });

  testWidgets('an already-read notification is not marked read again',
      (tester) async {
    final api = FakeNotificationsApi(
      notifications: [_notification(readAt: DateTime.utc(2026, 9, 2))],
    );
    await tester.pumpWidget(_wrap(api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New work order assigned'));
    await tester.pumpAndSettle();

    expect(api.readCalls, isEmpty);
  });
}
