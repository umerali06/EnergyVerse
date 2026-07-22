# fev_api_client.api.AreasApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createArea**](AreasApi.md#createarea) | **POST** /api/v1/areas | Create Area
[**deleteArea**](AreasApi.md#deletearea) | **DELETE** /api/v1/areas/{area_id} | Delete Area
[**getArea**](AreasApi.md#getarea) | **GET** /api/v1/areas/{area_id} | Get Area
[**listAreas**](AreasApi.md#listareas) | **GET** /api/v1/areas | List Areas
[**updateArea**](AreasApi.md#updatearea) | **PATCH** /api/v1/areas/{area_id} | Update Area


# **createArea**
> AreaDetail createArea(createAreaRequest)

Create Area

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAreasApi();
final CreateAreaRequest createAreaRequest = ; // CreateAreaRequest |

try {
    final response = api.createArea(createAreaRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AreasApi->createArea: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAreaRequest** | [**CreateAreaRequest**](CreateAreaRequest.md)|  |

### Return type

[**AreaDetail**](AreaDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteArea**
> AreaDeleted deleteArea(areaId)

Delete Area

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAreasApi();
final String areaId = areaId_example; // String |

try {
    final response = api.deleteArea(areaId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AreasApi->deleteArea: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  |

### Return type

[**AreaDeleted**](AreaDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getArea**
> AreaDetail getArea(areaId)

Get Area

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAreasApi();
final String areaId = areaId_example; // String |

try {
    final response = api.getArea(areaId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AreasApi->getArea: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  |

### Return type

[**AreaDetail**](AreaDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAreas**
> AreaListPage listAreas(facilityId, search, sort, cursor, limit)

List Areas

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAreasApi();
final String facilityId = facilityId_example; // String |
final String search = search_example; // String |
final String sort = sort_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listAreas(facilityId, search, sort, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AreasApi->listAreas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  | [optional]
 **search** | **String**|  | [optional]
 **sort** | **String**|  | [optional] [default to 'name']
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**AreaListPage**](AreaListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateArea**
> AreaDetail updateArea(areaId, updateAreaRequest)

Update Area

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAreasApi();
final String areaId = areaId_example; // String |
final UpdateAreaRequest updateAreaRequest = ; // UpdateAreaRequest |

try {
    final response = api.updateArea(areaId, updateAreaRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AreasApi->updateArea: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  |
 **updateAreaRequest** | [**UpdateAreaRequest**](UpdateAreaRequest.md)|  |

### Return type

[**AreaDetail**](AreaDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
