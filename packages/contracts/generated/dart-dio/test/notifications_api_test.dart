import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for NotificationsApi
void main() {
  final instance = FevApiClient().getNotificationsApi();

  group(NotificationsApi, () {
    // List Notifications
    //
    // The caller's own notifications, newest first, with an unread count.  The count is always over everything unread, not just the returned page, so the bell badge stays correct under `unread_only`.
    //
    //Future<NotificationListPage> listNotifications({ bool unreadOnly }) async
    test('test listNotifications', () async {
      // TODO
    });

    // Mark All Notifications Read
    //
    //Future<NotificationsAllRead> markAllNotificationsRead() async
    test('test markAllNotificationsRead', () async {
      // TODO
    });

    // Mark Notification Read
    //
    // Idempotent -- re-reading keeps the original timestamp.
    //
    //Future<NotificationRead> markNotificationRead(String notificationId) async
    test('test markNotificationRead', () async {
      // TODO
    });

    // Register Notification Device
    //
    // Register this device's FCM token for push.  Re-registering an existing token reassigns it to the caller: a shared site tablet passed between people must not keep pushing the previous user's alerts to whoever is holding it now.
    //
    //Future<DeviceRegistered> registerNotificationDevice(RegisterDeviceRequest registerDeviceRequest) async
    test('test registerNotificationDevice', () async {
      // TODO
    });

    // Unregister Notification Device
    //
    // Called on sign-out so a shared device stops receiving the caller's push.
    //
    //Future<DeviceUnregistered> unregisterNotificationDevice(String token) async
    test('test unregisterNotificationDevice', () async {
      // TODO
    });
  });
}
