# fev_api_client.api.RolesApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listRoles**](RolesApi.md#listroles) | **GET** /api/v1/roles | List Roles


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
