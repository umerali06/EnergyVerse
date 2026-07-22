# fev_api_client.api.CompanyApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCompany**](CompanyApi.md#getcompany) | **GET** /api/v1/company | Get Company
[**removeCompanyLogo**](CompanyApi.md#removecompanylogo) | **DELETE** /api/v1/company/logo | Remove Company Logo
[**updateCompany**](CompanyApi.md#updatecompany) | **PATCH** /api/v1/company | Update Company
[**uploadCompanyLogo**](CompanyApi.md#uploadcompanylogo) | **POST** /api/v1/company/logo | Upload Company Logo


# **getCompany**
> CompanyProfile getCompany()

Get Company

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getCompanyApi();

try {
    final response = api.getCompany();
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompanyApi->getCompany: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompanyProfile**](CompanyProfile.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeCompanyLogo**
> CompanyProfile removeCompanyLogo()

Remove Company Logo

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getCompanyApi();

try {
    final response = api.removeCompanyLogo();
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompanyApi->removeCompanyLogo: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompanyProfile**](CompanyProfile.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCompany**
> CompanyProfile updateCompany(updateCompanyRequest)

Update Company

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getCompanyApi();
final UpdateCompanyRequest updateCompanyRequest = ; // UpdateCompanyRequest |

try {
    final response = api.updateCompany(updateCompanyRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompanyApi->updateCompany: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateCompanyRequest** | [**UpdateCompanyRequest**](UpdateCompanyRequest.md)|  |

### Return type

[**CompanyProfile**](CompanyProfile.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadCompanyLogo**
> CompanyProfile uploadCompanyLogo(file)

Upload Company Logo

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getCompanyApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadCompanyLogo(file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompanyApi->uploadCompanyLogo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**|  |

### Return type

[**CompanyProfile**](CompanyProfile.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
