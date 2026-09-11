# fev_api_client.api.GeneratedReportsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteGeneratedReport**](GeneratedReportsApi.md#deletegeneratedreport) | **DELETE** /api/v1/reports/{report_id} | Delete Generated Report
[**exportGeneratedReport**](GeneratedReportsApi.md#exportgeneratedreport) | **POST** /api/v1/reports/{report_id}/export | Export Generated Report
[**finalizeGeneratedReport**](GeneratedReportsApi.md#finalizegeneratedreport) | **POST** /api/v1/reports/{report_id}/finalize | Finalize Generated Report
[**generateReport**](GeneratedReportsApi.md#generatereport) | **POST** /api/v1/reports/generate | Generate Report
[**getGeneratedReport**](GeneratedReportsApi.md#getgeneratedreport) | **GET** /api/v1/reports/{report_id} | Get Generated Report
[**listGeneratedReports**](GeneratedReportsApi.md#listgeneratedreports) | **GET** /api/v1/reports | List Generated Reports
[**regenerateGeneratedReport**](GeneratedReportsApi.md#regenerategeneratedreport) | **POST** /api/v1/reports/{report_id}/regenerate | Regenerate Generated Report
[**updateGeneratedReport**](GeneratedReportsApi.md#updategeneratedreport) | **PATCH** /api/v1/reports/{report_id} | Update Generated Report


# **deleteGeneratedReport**
> GeneratedReportDeleted deleteGeneratedReport(reportId)

Delete Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |

try {
    final response = api.deleteGeneratedReport(reportId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->deleteGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |

### Return type

[**GeneratedReportDeleted**](GeneratedReportDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportGeneratedReport**
> GeneratedReportExportResponse exportGeneratedReport(reportId, format)

Export Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |
final String format = format_example; // String |

try {
    final response = api.exportGeneratedReport(reportId, format);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->exportGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **format** | **String**|  |

### Return type

[**GeneratedReportExportResponse**](GeneratedReportExportResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **finalizeGeneratedReport**
> GeneratedReportDetail finalizeGeneratedReport(reportId, finalizeGeneratedReportRequest)

Finalize Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |
final FinalizeGeneratedReportRequest finalizeGeneratedReportRequest = ; // FinalizeGeneratedReportRequest |

try {
    final response = api.finalizeGeneratedReport(reportId, finalizeGeneratedReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->finalizeGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **finalizeGeneratedReportRequest** | [**FinalizeGeneratedReportRequest**](FinalizeGeneratedReportRequest.md)|  |

### Return type

[**GeneratedReportDetail**](GeneratedReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateReport**
> GeneratedReportDetail generateReport(createGeneratedReportRequest)

Generate Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final CreateGeneratedReportRequest createGeneratedReportRequest = ; // CreateGeneratedReportRequest |

try {
    final response = api.generateReport(createGeneratedReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->generateReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createGeneratedReportRequest** | [**CreateGeneratedReportRequest**](CreateGeneratedReportRequest.md)|  |

### Return type

[**GeneratedReportDetail**](GeneratedReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGeneratedReport**
> GeneratedReportDetail getGeneratedReport(reportId)

Get Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |

try {
    final response = api.getGeneratedReport(reportId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->getGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |

### Return type

[**GeneratedReportDetail**](GeneratedReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGeneratedReports**
> GeneratedReportListPage listGeneratedReports(reportType, status, cursor, limit)

List Generated Reports

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportType = reportType_example; // String |
final String status = status_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listGeneratedReports(reportType, status, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->listGeneratedReports: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportType** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**GeneratedReportListPage**](GeneratedReportListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **regenerateGeneratedReport**
> GeneratedReportDetail regenerateGeneratedReport(reportId, regenerateGeneratedReportRequest)

Regenerate Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |
final RegenerateGeneratedReportRequest regenerateGeneratedReportRequest = ; // RegenerateGeneratedReportRequest |

try {
    final response = api.regenerateGeneratedReport(reportId, regenerateGeneratedReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->regenerateGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **regenerateGeneratedReportRequest** | [**RegenerateGeneratedReportRequest**](RegenerateGeneratedReportRequest.md)|  |

### Return type

[**GeneratedReportDetail**](GeneratedReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGeneratedReport**
> GeneratedReportDetail updateGeneratedReport(reportId, updateGeneratedReportRequest)

Update Generated Report

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getGeneratedReportsApi();
final String reportId = reportId_example; // String |
final UpdateGeneratedReportRequest updateGeneratedReportRequest = ; // UpdateGeneratedReportRequest |

try {
    final response = api.updateGeneratedReport(reportId, updateGeneratedReportRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeneratedReportsApi->updateGeneratedReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportId** | **String**|  |
 **updateGeneratedReportRequest** | [**UpdateGeneratedReportRequest**](UpdateGeneratedReportRequest.md)|  |

### Return type

[**GeneratedReportDetail**](GeneratedReportDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
