# fev_api_client.api.NotificationsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /api/v1/notifications | List Notifications
[**markAllNotificationsRead**](NotificationsApi.md#markallnotificationsread) | **POST** /api/v1/notifications/read-all | Mark All Notifications Read
[**markNotificationRead**](NotificationsApi.md#marknotificationread) | **POST** /api/v1/notifications/{notification_id}/read | Mark Notification Read
[**registerNotificationDevice**](NotificationsApi.md#registernotificationdevice) | **POST** /api/v1/notifications/devices | Register Notification Device
[**unregisterNotificationDevice**](NotificationsApi.md#unregisternotificationdevice) | **DELETE** /api/v1/notifications/devices/{token} | Unregister Notification Device


# **listNotifications**
> NotificationListPage listNotifications(unreadOnly)

List Notifications

The caller's own notifications, newest first, with an unread count.  The count is always over everything unread, not just the returned page, so the bell badge stays correct under `unread_only`.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getNotificationsApi();
final bool unreadOnly = true; // bool |

try {
    final response = api.listNotifications(unreadOnly);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->listNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **unreadOnly** | **bool**|  | [optional] [default to false]

### Return type

[**NotificationListPage**](NotificationListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markAllNotificationsRead**
> NotificationsAllRead markAllNotificationsRead()

Mark All Notifications Read

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getNotificationsApi();

try {
    final response = api.markAllNotificationsRead();
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->markAllNotificationsRead: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**NotificationsAllRead**](NotificationsAllRead.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markNotificationRead**
> NotificationRead markNotificationRead(notificationId)

Mark Notification Read

Idempotent -- re-reading keeps the original timestamp.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getNotificationsApi();
final String notificationId = notificationId_example; // String |

try {
    final response = api.markNotificationRead(notificationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->markNotificationRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **String**|  |

### Return type

[**NotificationRead**](NotificationRead.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerNotificationDevice**
> DeviceRegistered registerNotificationDevice(registerDeviceRequest)

Register Notification Device

Register this device's FCM token for push.  Re-registering an existing token reassigns it to the caller: a shared site tablet passed between people must not keep pushing the previous user's alerts to whoever is holding it now.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getNotificationsApi();
final RegisterDeviceRequest registerDeviceRequest = ; // RegisterDeviceRequest |

try {
    final response = api.registerNotificationDevice(registerDeviceRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->registerNotificationDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDeviceRequest** | [**RegisterDeviceRequest**](RegisterDeviceRequest.md)|  |

### Return type

[**DeviceRegistered**](DeviceRegistered.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unregisterNotificationDevice**
> DeviceUnregistered unregisterNotificationDevice(token)

Unregister Notification Device

Called on sign-out so a shared device stops receiving the caller's push.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getNotificationsApi();
final String token = token_example; // String |

try {
    final response = api.unregisterNotificationDevice(token);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->unregisterNotificationDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  |

### Return type

[**DeviceUnregistered**](DeviceUnregistered.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
