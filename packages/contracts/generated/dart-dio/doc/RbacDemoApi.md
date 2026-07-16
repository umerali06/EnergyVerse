# fev_api_client.api.RbacDemoApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**rbacDemoAllPermissions**](RbacDemoApi.md#rbacdemoallpermissions) | **GET** /api/v1/_rbac-demo/all | All Permissions
[**rbacDemoAnyPermission**](RbacDemoApi.md#rbacdemoanypermission) | **GET** /api/v1/_rbac-demo/any | Any Permission
[**rbacDemoSinglePermission**](RbacDemoApi.md#rbacdemosinglepermission) | **GET** /api/v1/_rbac-demo/single | Single Permission


# **rbacDemoAllPermissions**
> DemoGateResponse rbacDemoAllPermissions()

All Permissions

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRbacDemoApi();

try {
    final response = api.rbacDemoAllPermissions();
    print(response);
} catch on DioException (e) {
    print('Exception when calling RbacDemoApi->rbacDemoAllPermissions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DemoGateResponse**](DemoGateResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rbacDemoAnyPermission**
> DemoGateResponse rbacDemoAnyPermission()

Any Permission

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRbacDemoApi();

try {
    final response = api.rbacDemoAnyPermission();
    print(response);
} catch on DioException (e) {
    print('Exception when calling RbacDemoApi->rbacDemoAnyPermission: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DemoGateResponse**](DemoGateResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rbacDemoSinglePermission**
> DemoGateResponse rbacDemoSinglePermission()

Single Permission

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getRbacDemoApi();

try {
    final response = api.rbacDemoSinglePermission();
    print(response);
} catch on DioException (e) {
    print('Exception when calling RbacDemoApi->rbacDemoSinglePermission: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DemoGateResponse**](DemoGateResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
