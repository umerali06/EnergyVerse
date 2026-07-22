# fev_api_client.api.FacilitiesApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createFacility**](FacilitiesApi.md#createfacility) | **POST** /api/v1/facilities | Create Facility
[**deleteFacility**](FacilitiesApi.md#deletefacility) | **DELETE** /api/v1/facilities/{facility_id} | Delete Facility
[**getFacility**](FacilitiesApi.md#getfacility) | **GET** /api/v1/facilities/{facility_id} | Get Facility
[**listFacilities**](FacilitiesApi.md#listfacilities) | **GET** /api/v1/facilities | List Facilities
[**updateFacility**](FacilitiesApi.md#updatefacility) | **PATCH** /api/v1/facilities/{facility_id} | Update Facility


# **createFacility**
> FacilityDetail createFacility(createFacilityRequest)

Create Facility

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getFacilitiesApi();
final CreateFacilityRequest createFacilityRequest = ; // CreateFacilityRequest |

try {
    final response = api.createFacility(createFacilityRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacilitiesApi->createFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createFacilityRequest** | [**CreateFacilityRequest**](CreateFacilityRequest.md)|  |

### Return type

[**FacilityDetail**](FacilityDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteFacility**
> FacilityDeleted deleteFacility(facilityId)

Delete Facility

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getFacilitiesApi();
final String facilityId = facilityId_example; // String |

try {
    final response = api.deleteFacility(facilityId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacilitiesApi->deleteFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  |

### Return type

[**FacilityDeleted**](FacilityDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFacility**
> FacilityDetail getFacility(facilityId)

Get Facility

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getFacilitiesApi();
final String facilityId = facilityId_example; // String |

try {
    final response = api.getFacility(facilityId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacilitiesApi->getFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  |

### Return type

[**FacilityDetail**](FacilityDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFacilities**
> FacilityListPage listFacilities(search, status, sort, cursor, limit)

List Facilities

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getFacilitiesApi();
final String search = search_example; // String |
final String status = status_example; // String |
final String sort = sort_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listFacilities(search, status, sort, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacilitiesApi->listFacilities: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **sort** | **String**|  | [optional] [default to 'name']
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**FacilityListPage**](FacilityListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateFacility**
> FacilityDetail updateFacility(facilityId, updateFacilityRequest)

Update Facility

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getFacilitiesApi();
final String facilityId = facilityId_example; // String |
final UpdateFacilityRequest updateFacilityRequest = ; // UpdateFacilityRequest |

try {
    final response = api.updateFacility(facilityId, updateFacilityRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacilitiesApi->updateFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  |
 **updateFacilityRequest** | [**UpdateFacilityRequest**](UpdateFacilityRequest.md)|  |

### Return type

[**FacilityDetail**](FacilityDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
