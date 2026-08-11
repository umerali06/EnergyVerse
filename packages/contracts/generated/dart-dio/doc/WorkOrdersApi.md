# fev_api_client.api.WorkOrdersApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptWorkOrder**](WorkOrdersApi.md#acceptworkorder) | **POST** /api/v1/work-orders/{work_order_id}/accept | Accept Work Order
[**assignWorkOrder**](WorkOrdersApi.md#assignworkorder) | **PATCH** /api/v1/work-orders/{work_order_id}/assign | Assign Work Order
[**cancelWorkOrder**](WorkOrdersApi.md#cancelworkorder) | **POST** /api/v1/work-orders/{work_order_id}/cancel | Cancel Work Order
[**closeWorkOrder**](WorkOrdersApi.md#closeworkorder) | **POST** /api/v1/work-orders/{work_order_id}/close | Close Work Order
[**createWorkOrder**](WorkOrdersApi.md#createworkorder) | **POST** /api/v1/work-orders | Create Work Order
[**deleteWorkOrder**](WorkOrdersApi.md#deleteworkorder) | **DELETE** /api/v1/work-orders/{work_order_id} | Delete Work Order
[**getWorkOrder**](WorkOrdersApi.md#getworkorder) | **GET** /api/v1/work-orders/{work_order_id} | Get Work Order
[**listWorkOrders**](WorkOrdersApi.md#listworkorders) | **GET** /api/v1/work-orders | List Work Orders
[**submitWorkOrderForReview**](WorkOrdersApi.md#submitworkorderforreview) | **PATCH** /api/v1/work-orders/{work_order_id}/submit-for-review | Submit Work Order For Review


# **acceptWorkOrder**
> WorkOrderDetail acceptWorkOrder(workOrderId)

Accept Work Order

Only the assigned technician can accept -- a 403 `not_assigned_technician` otherwise, even for a caller who holds `work_orders.write` for other reasons (D-066).

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |

try {
    final response = api.acceptWorkOrder(workOrderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->acceptWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **assignWorkOrder**
> WorkOrderDetail assignWorkOrder(workOrderId, assignWorkOrderRequest)

Assign Work Order

Reachable from `open` (first assignment) or `assigned` (reassign to a different technician) -- never from `in_progress` onward, since the original technician has already started real repair work by then.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |
final AssignWorkOrderRequest assignWorkOrderRequest = ; // AssignWorkOrderRequest |

try {
    final response = api.assignWorkOrder(workOrderId, assignWorkOrderRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->assignWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |
 **assignWorkOrderRequest** | [**AssignWorkOrderRequest**](AssignWorkOrderRequest.md)|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelWorkOrder**
> WorkOrderDetail cancelWorkOrder(workOrderId)

Cancel Work Order

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |

try {
    final response = api.cancelWorkOrder(workOrderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->cancelWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **closeWorkOrder**
> WorkOrderDetail closeWorkOrder(workOrderId)

Close Work Order

Gated by `work_orders.close`, deliberately distinct from `work_orders.write` (D-066) -- the assigned technician (who only holds `.write`) cannot reach this route at all, enforcing the spec's \"Supervisor Review\" step rather than leaving it advisory.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |

try {
    final response = api.closeWorkOrder(workOrderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->closeWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createWorkOrder**
> WorkOrderDetail createWorkOrder(createWorkOrderRequest)

Create Work Order

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final CreateWorkOrderRequest createWorkOrderRequest = ; // CreateWorkOrderRequest |

try {
    final response = api.createWorkOrder(createWorkOrderRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->createWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createWorkOrderRequest** | [**CreateWorkOrderRequest**](CreateWorkOrderRequest.md)|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteWorkOrder**
> WorkOrderDeleted deleteWorkOrder(workOrderId)

Delete Work Order

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |

try {
    final response = api.deleteWorkOrder(workOrderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->deleteWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |

### Return type

[**WorkOrderDeleted**](WorkOrderDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkOrder**
> WorkOrderDetail getWorkOrder(workOrderId)

Get Work Order

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |

try {
    final response = api.getWorkOrder(workOrderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->getWorkOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWorkOrders**
> WorkOrderListPage listWorkOrders(assetId, facilityId, status, technicianId, cursor, limit)

List Work Orders

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String assetId = assetId_example; // String |
final String facilityId = facilityId_example; // String |
final String status = status_example; // String |
final String technicianId = technicianId_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listWorkOrders(assetId, facilityId, status, technicianId, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->listWorkOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  | [optional]
 **facilityId** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **technicianId** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**WorkOrderListPage**](WorkOrderListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitWorkOrderForReview**
> WorkOrderDetail submitWorkOrderForReview(workOrderId, submitWorkOrderForReviewRequest)

Submit Work Order For Review

Only the assigned technician can submit -- same 403 posture as `accept_work_order` (D-066).

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getWorkOrdersApi();
final String workOrderId = workOrderId_example; // String |
final SubmitWorkOrderForReviewRequest submitWorkOrderForReviewRequest = ; // SubmitWorkOrderForReviewRequest |

try {
    final response = api.submitWorkOrderForReview(workOrderId, submitWorkOrderForReviewRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WorkOrdersApi->submitWorkOrderForReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workOrderId** | **String**|  |
 **submitWorkOrderForReviewRequest** | [**SubmitWorkOrderForReviewRequest**](SubmitWorkOrderForReviewRequest.md)|  |

### Return type

[**WorkOrderDetail**](WorkOrderDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
