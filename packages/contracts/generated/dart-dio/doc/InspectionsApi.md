# fev_api_client.api.InspectionsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignInspectionChecklistTemplate**](InspectionsApi.md#assigninspectionchecklisttemplate) | **POST** /api/v1/inspections/{inspection_id}/checklist-template | Assign Checklist Template
[**cancelInspection**](InspectionsApi.md#cancelinspection) | **POST** /api/v1/inspections/{inspection_id}/cancel | Cancel Inspection
[**completeInspection**](InspectionsApi.md#completeinspection) | **POST** /api/v1/inspections/{inspection_id}/complete | Complete Inspection
[**createInspection**](InspectionsApi.md#createinspection) | **POST** /api/v1/inspections | Create Inspection
[**deleteInspection**](InspectionsApi.md#deleteinspection) | **DELETE** /api/v1/inspections/{inspection_id} | Delete Inspection
[**getInspection**](InspectionsApi.md#getinspection) | **GET** /api/v1/inspections/{inspection_id} | Get Inspection
[**listInspections**](InspectionsApi.md#listinspections) | **GET** /api/v1/inspections | List Inspections
[**startInspection**](InspectionsApi.md#startinspection) | **POST** /api/v1/inspections/{inspection_id}/start | Start Inspection
[**updateInspection**](InspectionsApi.md#updateinspection) | **PATCH** /api/v1/inspections/{inspection_id} | Update Inspection


# **assignInspectionChecklistTemplate**
> InspectionDetail assignInspectionChecklistTemplate(inspectionId, assignChecklistTemplateRequest)

Assign Checklist Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final AssignChecklistTemplateRequest assignChecklistTemplateRequest = ; // AssignChecklistTemplateRequest |

try {
    final response = api.assignInspectionChecklistTemplate(inspectionId, assignChecklistTemplateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->assignInspectionChecklistTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **assignChecklistTemplateRequest** | [**AssignChecklistTemplateRequest**](AssignChecklistTemplateRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelInspection**
> InspectionDetail cancelInspection(inspectionId)

Cancel Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |

try {
    final response = api.cancelInspection(inspectionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->cancelInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeInspection**
> InspectionDetail completeInspection(inspectionId)

Complete Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |

try {
    final response = api.completeInspection(inspectionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->completeInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createInspection**
> InspectionDetail createInspection(createInspectionRequest)

Create Inspection

Idempotent upsert keyed by the client-generated `id` (sync contract, D-0xx): a byte-identical resubmit returns the same resource -- hence a fixed 200, never 201, since this route can't statically know whether a given call created or replayed a record.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final CreateInspectionRequest createInspectionRequest = ; // CreateInspectionRequest |

try {
    final response = api.createInspection(createInspectionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->createInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createInspectionRequest** | [**CreateInspectionRequest**](CreateInspectionRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteInspection**
> InspectionDeleted deleteInspection(inspectionId)

Delete Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |

try {
    final response = api.deleteInspection(inspectionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->deleteInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |

### Return type

[**InspectionDeleted**](InspectionDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInspection**
> InspectionDetail getInspection(inspectionId)

Get Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |

try {
    final response = api.getInspection(inspectionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->getInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listInspections**
> InspectionListPage listInspections(assetId, facilityId, status, inspectorId, fromDate, toDate, cursor, limit)

List Inspections

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String assetId = assetId_example; // String |
final String facilityId = facilityId_example; // String |
final String status = status_example; // String |
final String inspectorId = inspectorId_example; // String |
final DateTime fromDate = 2013-10-20T19:20:30+01:00; // DateTime |
final DateTime toDate = 2013-10-20T19:20:30+01:00; // DateTime |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listInspections(assetId, facilityId, status, inspectorId, fromDate, toDate, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->listInspections: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  | [optional]
 **facilityId** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **inspectorId** | **String**|  | [optional]
 **fromDate** | **DateTime**|  | [optional]
 **toDate** | **DateTime**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**InspectionListPage**](InspectionListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startInspection**
> InspectionDetail startInspection(inspectionId)

Start Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |

try {
    final response = api.startInspection(inspectionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->startInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateInspection**
> InspectionDetail updateInspection(inspectionId, updateInspectionRequest)

Update Inspection

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final UpdateInspectionRequest updateInspectionRequest = ; // UpdateInspectionRequest |

try {
    final response = api.updateInspection(inspectionId, updateInspectionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->updateInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **updateInspectionRequest** | [**UpdateInspectionRequest**](UpdateInspectionRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
