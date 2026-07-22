# fev_api_client.api.PlatformApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPlatformCompany**](PlatformApi.md#getplatformcompany) | **GET** /api/v1/platform/companies/{company_id} | Get Platform Company
[**getPlatformStats**](PlatformApi.md#getplatformstats) | **GET** /api/v1/platform/stats | Get Platform Stats
[**listPlatformCompanies**](PlatformApi.md#listplatformcompanies) | **GET** /api/v1/platform/companies | List Platform Companies
[**updatePlatformCompany**](PlatformApi.md#updateplatformcompany) | **PATCH** /api/v1/platform/companies/{company_id} | Update Platform Company
[**updatePlatformCompanyStatus**](PlatformApi.md#updateplatformcompanystatus) | **PATCH** /api/v1/platform/companies/{company_id}/status | Update Platform Company Status


# **getPlatformCompany**
> PlatformCompanyDetail getPlatformCompany(companyId)

Get Platform Company

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPlatformApi();
final String companyId = companyId_example; // String |

try {
    final response = api.getPlatformCompany(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PlatformApi->getPlatformCompany: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  |

### Return type

[**PlatformCompanyDetail**](PlatformCompanyDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlatformStats**
> PlatformStats getPlatformStats()

Get Platform Stats

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPlatformApi();

try {
    final response = api.getPlatformStats();
    print(response);
} catch on DioException (e) {
    print('Exception when calling PlatformApi->getPlatformStats: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PlatformStats**](PlatformStats.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPlatformCompanies**
> PlatformCompanyPage listPlatformCompanies(cursor, limit)

List Platform Companies

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPlatformApi();
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listPlatformCompanies(cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PlatformApi->listPlatformCompanies: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**PlatformCompanyPage**](PlatformCompanyPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePlatformCompany**
> PlatformCompanyDetail updatePlatformCompany(companyId, updatePlatformCompanyRequest)

Update Platform Company

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPlatformApi();
final String companyId = companyId_example; // String |
final UpdatePlatformCompanyRequest updatePlatformCompanyRequest = ; // UpdatePlatformCompanyRequest |

try {
    final response = api.updatePlatformCompany(companyId, updatePlatformCompanyRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PlatformApi->updatePlatformCompany: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  |
 **updatePlatformCompanyRequest** | [**UpdatePlatformCompanyRequest**](UpdatePlatformCompanyRequest.md)|  |

### Return type

[**PlatformCompanyDetail**](PlatformCompanyDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePlatformCompanyStatus**
> PlatformCompanyDetail updatePlatformCompanyStatus(companyId, updateCompanyStatusRequest)

Update Platform Company Status

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPlatformApi();
final String companyId = companyId_example; // String |
final UpdateCompanyStatusRequest updateCompanyStatusRequest = ; // UpdateCompanyStatusRequest |

try {
    final response = api.updatePlatformCompanyStatus(companyId, updateCompanyStatusRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PlatformApi->updatePlatformCompanyStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  |
 **updateCompanyStatusRequest** | [**UpdateCompanyStatusRequest**](UpdateCompanyStatusRequest.md)|  |

### Return type

[**PlatformCompanyDetail**](PlatformCompanyDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
