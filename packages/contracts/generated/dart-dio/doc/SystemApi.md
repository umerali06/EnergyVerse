# fev_api_client.api.SystemApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getHealth**](SystemApi.md#gethealth) | **GET** /health | Health
[**getRoot**](SystemApi.md#getroot) | **GET** / | Root


# **getHealth**
> HealthResponse getHealth()

Health

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSystemApi();

try {
    final response = api.getHealth();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SystemApi->getHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthResponse**](HealthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRoot**
> ServiceResponse getRoot()

Root

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSystemApi();

try {
    final response = api.getRoot();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SystemApi->getRoot: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ServiceResponse**](ServiceResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
