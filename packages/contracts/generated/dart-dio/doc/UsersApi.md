# fev_api_client.api.UsersApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getUser**](UsersApi.md#getuser) | **GET** /api/v1/users/{user_id} | Get User
[**inviteUser**](UsersApi.md#inviteuser) | **POST** /api/v1/users/invite | Invite User
[**listUsers**](UsersApi.md#listusers) | **GET** /api/v1/users | List Users
[**setUserStatus**](UsersApi.md#setuserstatus) | **PATCH** /api/v1/users/{user_id}/status | Set User Status
[**updateUser**](UsersApi.md#updateuser) | **PATCH** /api/v1/users/{user_id} | Update User


# **getUser**
> UserDetail getUser(userId)

Get User

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getUsersApi();
final String userId = userId_example; // String |

try {
    final response = api.getUser(userId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->getUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  |

### Return type

[**UserDetail**](UserDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteUser**
> UserDetail inviteUser(inviteUserRequest)

Invite User

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getUsersApi();
final InviteUserRequest inviteUserRequest = ; // InviteUserRequest |

try {
    final response = api.inviteUser(inviteUserRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->inviteUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inviteUserRequest** | [**InviteUserRequest**](InviteUserRequest.md)|  |

### Return type

[**UserDetail**](UserDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listUsers**
> UserListPage listUsers(search, roleId, status, sort, cursor, limit)

List Users

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getUsersApi();
final String search = search_example; // String |
final String roleId = roleId_example; // String |
final String status = status_example; // String |
final String sort = sort_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listUsers(search, roleId, status, sort, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->listUsers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **roleId** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **sort** | **String**|  | [optional] [default to 'name']
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**UserListPage**](UserListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setUserStatus**
> UserDetail setUserStatus(userId, updateUserStatusRequest)

Set User Status

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getUsersApi();
final String userId = userId_example; // String |
final UpdateUserStatusRequest updateUserStatusRequest = ; // UpdateUserStatusRequest |

try {
    final response = api.setUserStatus(userId, updateUserStatusRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->setUserStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  |
 **updateUserStatusRequest** | [**UpdateUserStatusRequest**](UpdateUserStatusRequest.md)|  |

### Return type

[**UserDetail**](UserDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUser**
> UserDetail updateUser(userId, updateUserRequest)

Update User

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getUsersApi();
final String userId = userId_example; // String |
final UpdateUserRequest updateUserRequest = ; // UpdateUserRequest |

try {
    final response = api.updateUser(userId, updateUserRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->updateUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  |
 **updateUserRequest** | [**UpdateUserRequest**](UpdateUserRequest.md)|  |

### Return type

[**UserDetail**](UserDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
