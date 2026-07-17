# fev_api_client.api.AuthApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCurrentUser**](AuthApi.md#getcurrentuser) | **GET** /api/v1/auth/me | Me
[**registerCompanyAdmin**](AuthApi.md#registercompanyadmin) | **POST** /api/v1/auth/register | Register Company Admin


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

# **registerCompanyAdmin**
> CompanyRegistrationResponse registerCompanyAdmin(companyRegistrationRequest)

Register Company Admin

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuthApi();
final CompanyRegistrationRequest companyRegistrationRequest = ; // CompanyRegistrationRequest |

try {
    final response = api.registerCompanyAdmin(companyRegistrationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->registerCompanyAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyRegistrationRequest** | [**CompanyRegistrationRequest**](CompanyRegistrationRequest.md)|  |

### Return type

[**CompanyRegistrationResponse**](CompanyRegistrationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
