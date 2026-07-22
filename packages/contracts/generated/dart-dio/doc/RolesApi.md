# fev_api_client.api.RolesApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createRole**](RolesApi.md#createrole) | **POST** /api/v1/roles | Create Role
[**deleteRole**](RolesApi.md#deleterole) | **DELETE** /api/v1/roles/{role_id} | Delete Role
[**getRole**](RolesApi.md#getrole) | **GET** /api/v1/roles/{role_id} | Get Role
[**listRoles**](RolesApi.md#listroles) | **GET** /api/v1/roles | List Roles
[**updateRole**](RolesApi.md#updaterole) | **PATCH** /api/v1/roles/{role_id} | Update Role


# **createRole**
> RoleDetail createRole(createRoleRequest)

Create Role

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRolesApi();
final CreateRoleRequest createRoleRequest = ; // CreateRoleRequest |

try {
    final response = api.createRole(createRoleRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->createRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createRoleRequest** | [**CreateRoleRequest**](CreateRoleRequest.md)|  |

### Return type

[**RoleDetail**](RoleDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteRole**
> RoleDeleted deleteRole(roleId)

Delete Role

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRolesApi();
final String roleId = roleId_example; // String |

try {
    final response = api.deleteRole(roleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->deleteRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  |

### Return type

[**RoleDeleted**](RoleDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRole**
> RoleDetail getRole(roleId)

Get Role

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRolesApi();
final String roleId = roleId_example; // String |

try {
    final response = api.getRole(roleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->getRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  |

### Return type

[**RoleDetail**](RoleDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRoles**
> RoleList listRoles()

List Roles

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRolesApi();

try {
    final response = api.listRoles();
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->listRoles: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RoleList**](RoleList.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateRole**
> RoleDetail updateRole(roleId, updateRoleRequest)

Update Role

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRolesApi();
final String roleId = roleId_example; // String |
final UpdateRoleRequest updateRoleRequest = ; // UpdateRoleRequest |

try {
    final response = api.updateRole(roleId, updateRoleRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->updateRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  |
 **updateRoleRequest** | [**UpdateRoleRequest**](UpdateRoleRequest.md)|  |

### Return type

[**RoleDetail**](RoleDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
