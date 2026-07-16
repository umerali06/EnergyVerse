# fev_api_client.api.AuthApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCurrentUser**](AuthApi.md#getcurrentuser) | **GET** /api/v1/auth/me | Me


# **getCurrentUser**
> CurrentUser getCurrentUser()

Me

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuthApi();

try {
    final response = api.getCurrentUser();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->getCurrentUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CurrentUser**](CurrentUser.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
