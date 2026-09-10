# fev_api_client.api.SafetyReportsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignSafetyReport**](SafetyReportsApi.md#assignsafetyreport) | **PATCH** /api/v1/safety-reports/{report_id}/assign | Assign Safety Report
[**cancelCorrectiveAction**](SafetyReportsApi.md#cancelcorrectiveaction) | **POST** /api/v1/safety-reports/{report_id}/corrective-actions/{action_id}/cancel | Cancel Corrective Action
[**closeSafetyReport**](SafetyReportsApi.md#closesafetyreport) | **POST** /api/v1/safety-reports/{report_id}/close | Close Safety Report
[**createCorrectiveAction**](SafetyReportsApi.md#createcorrectiveaction) | **POST** /api/v1/safety-reports/{report_id}/corrective-actions | Create Corrective Action
[**createSafetyReport**](SafetyReportsApi.md#createsafetyreport) | **POST** /api/v1/safety-reports | Create Safety Report
[**deleteSafetyEvidence**](SafetyReportsApi.md#deletesafetyevidence) | **DELETE** /api/v1/safety-reports/{report_id}/evidence/{evidence_id} | Delete Safety Evidence
[**deleteSafetyReport**](SafetyReportsApi.md#deletesafetyreport) | **DELETE** /api/v1/safety-reports/{report_id} | Delete Safety Report
[**getSafetyReport**](SafetyReportsApi.md#getsafetyreport) | **GET** /api/v1/safety-reports/{report_id} | Get Safety Report
[**listSafetyReports**](SafetyReportsApi.md#listsafetyreports) | **GET** /api/v1/safety-reports | List Safety Reports
[**transitionSafetyReport**](SafetyReportsApi.md#transitionsafetyreport) | **PATCH** /api/v1/safety-reports/{report_id}/transition | Transition Safety Report
[**updateCorrectiveAction**](SafetyReportsApi.md#updatecorrectiveaction) | **PATCH** /api/v1/safety-reports/{report_id}/corrective-actions/{action_id} | Update Corrective Action
[**uploadSafetyEvidence**](SafetyReportsApi.md#uploadsafetyevidence) | **POST** /api/v1/safety-reports/{report_id}/evidence | Upload Safety Evidence


# **assignSafetyReport**
> SafetyReportDetail assignSafetyReport(reportId, assignSafetyReportRequest)

Assign Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final AssignSafetyReportRequest assignSafetyReportRequest = ; // AssignSafetyReportRequest |

try {
    final response = api.assignSafetyReport(reportId, assignSafetyReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->assignSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **assignSafetyReportRequest** | [**AssignSafetyReportRequest**](AssignSafetyReportRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelCorrectiveAction**
> SafetyReportDetail cancelCorrectiveAction(reportId, actionId, cancelCorrectiveActionRequest)

Cancel Corrective Action

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final String actionId = actionId_example; // String |
final CancelCorrectiveActionRequest cancelCorrectiveActionRequest = ; // CancelCorrectiveActionRequest |

try {
    final response = api.cancelCorrectiveAction(reportId, actionId, cancelCorrectiveActionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->cancelCorrectiveAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **actionId** | **String**|  |
 **cancelCorrectiveActionRequest** | [**CancelCorrectiveActionRequest**](CancelCorrectiveActionRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **closeSafetyReport**
> SafetyReportDetail closeSafetyReport(reportId)

Close Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |

try {
    final response = api.closeSafetyReport(reportId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->closeSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createCorrectiveAction**
> SafetyReportDetail createCorrectiveAction(reportId, createCorrectiveActionRequest)

Create Corrective Action

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final CreateCorrectiveActionRequest createCorrectiveActionRequest = ; // CreateCorrectiveActionRequest |

try {
    final response = api.createCorrectiveAction(reportId, createCorrectiveActionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->createCorrectiveAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **createCorrectiveActionRequest** | [**CreateCorrectiveActionRequest**](CreateCorrectiveActionRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSafetyReport**
> SafetyReportDetail createSafetyReport(createSafetyReportRequest)

Create Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final CreateSafetyReportRequest createSafetyReportRequest = ; // CreateSafetyReportRequest |

try {
    final response = api.createSafetyReport(createSafetyReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->createSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSafetyReportRequest** | [**CreateSafetyReportRequest**](CreateSafetyReportRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSafetyEvidence**
> SafetyReportDetail deleteSafetyEvidence(reportId, evidenceId)

Delete Safety Evidence

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final String evidenceId = evidenceId_example; // String |

try {
    final response = api.deleteSafetyEvidence(reportId, evidenceId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->deleteSafetyEvidence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **evidenceId** | **String**|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSafetyReport**
> SafetyReportDeleted deleteSafetyReport(reportId)

Delete Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |

try {
    final response = api.deleteSafetyReport(reportId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->deleteSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |

### Return type

[**SafetyReportDeleted**](SafetyReportDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSafetyReport**
> SafetyReportDetail getSafetyReport(reportId)

Get Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |

try {
    final response = api.getSafetyReport(reportId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->getSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSafetyReports**
> SafetyReportListPage listSafetyReports(status, category, severity, reporterId, cursor, limit)

List Safety Reports

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String status = status_example; // String |
final String category = category_example; // String |
final String severity = severity_example; // String |
final String reporterId = reporterId_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listSafetyReports(status, category, severity, reporterId, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->listSafetyReports: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional]
 **category** | **String**|  | [optional]
 **severity** | **String**|  | [optional]
 **reporterId** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**SafetyReportListPage**](SafetyReportListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transitionSafetyReport**
> SafetyReportDetail transitionSafetyReport(reportId, transitionSafetyReportRequest)

Transition Safety Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final TransitionSafetyReportRequest transitionSafetyReportRequest = ; // TransitionSafetyReportRequest |

try {
    final response = api.transitionSafetyReport(reportId, transitionSafetyReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->transitionSafetyReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **transitionSafetyReportRequest** | [**TransitionSafetyReportRequest**](TransitionSafetyReportRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCorrectiveAction**
> SafetyReportDetail updateCorrectiveAction(reportId, actionId, updateCorrectiveActionRequest)

Update Corrective Action

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final String actionId = actionId_example; // String |
final UpdateCorrectiveActionRequest updateCorrectiveActionRequest = ; // UpdateCorrectiveActionRequest |

try {
    final response = api.updateCorrectiveAction(reportId, actionId, updateCorrectiveActionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->updateCorrectiveAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **actionId** | **String**|  |
 **updateCorrectiveActionRequest** | [**UpdateCorrectiveActionRequest**](UpdateCorrectiveActionRequest.md)|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadSafetyEvidence**
> SafetyReportDetail uploadSafetyEvidence(reportId, kind, file)

Upload Safety Evidence

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getSafetyReportsApi();
final String reportId = reportId_example; // String |
final String kind = kind_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadSafetyEvidence(reportId, kind, file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SafetyReportsApi->uploadSafetyEvidence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **kind** | **String**|  |
 **file** | **MultipartFile**|  |

### Return type

[**SafetyReportDetail**](SafetyReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
