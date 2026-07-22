# fev_api_client.api.PermissionsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listPermissionCatalog**](PermissionsApi.md#listpermissioncatalog) | **GET** /api/v1/permissions | List Permission Catalog


# **listPermissionCatalog**
> PermissionCatalog listPermissionCatalog()

List Permission Catalog

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermissionsApi();

try {
    final response = api.listPermissionCatalog();
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermissionsApi->listPermissionCatalog: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PermissionCatalog**](PermissionCatalog.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
