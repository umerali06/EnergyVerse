# fev_api_client.api.AuditApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**exportAuditLogs**](AuditApi.md#exportauditlogs) | **GET** /api/v1/audit-logs/export | Export Audit Logs
[**getAuditLogFacets**](AuditApi.md#getauditlogfacets) | **GET** /api/v1/audit-logs/actions | Get Audit Log Facets
[**listAuditLogs**](AuditApi.md#listauditlogs) | **GET** /api/v1/audit-logs | List Audit Logs


# **exportAuditLogs**
> JsonObject exportAuditLogs(fromDate, toDate, actorUid, action, targetType, q)

Export Audit Logs

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuditApi();
final Date fromDate = 2013-10-20; // Date |
final Date toDate = 2013-10-20; // Date |
final String actorUid = actorUid_example; // String |
final String action = action_example; // String |
final String targetType = targetType_example; // String |
final String q = q_example; // String |

try {
    final response = api.exportAuditLogs(fromDate, toDate, actorUid, action, targetType, q);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuditApi->exportAuditLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromDate** | **Date**|  | [optional]
 **toDate** | **Date**|  | [optional]
 **actorUid** | **String**|  | [optional]
 **action** | **String**|  | [optional]
 **targetType** | **String**|  | [optional]
 **q** | **String**|  | [optional]

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAuditLogFacets**
> AuditLogFacets getAuditLogFacets(fromDate, toDate)

Get Audit Log Facets

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuditApi();
final Date fromDate = 2013-10-20; // Date |
final Date toDate = 2013-10-20; // Date |

try {
    final response = api.getAuditLogFacets(fromDate, toDate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuditApi->getAuditLogFacets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromDate** | **Date**|  | [optional]
 **toDate** | **Date**|  | [optional]

### Return type

[**AuditLogFacets**](AuditLogFacets.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAuditLogs**
> AuditLogPage listAuditLogs(fromDate, toDate, actorUid, action, targetType, q, cursor, limit)

List Audit Logs

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuditApi();
final Date fromDate = 2013-10-20; // Date |
final Date toDate = 2013-10-20; // Date |
final String actorUid = actorUid_example; // String |
final String action = action_example; // String |
final String targetType = targetType_example; // String |
final String q = q_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listAuditLogs(fromDate, toDate, actorUid, action, targetType, q, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuditApi->listAuditLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromDate** | **Date**|  | [optional]
 **toDate** | **Date**|  | [optional]
 **actorUid** | **String**|  | [optional]
 **action** | **String**|  | [optional]
 **targetType** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AuditLogPage**](AuditLogPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
