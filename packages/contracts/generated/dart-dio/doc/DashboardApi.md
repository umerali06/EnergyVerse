# fev_api_client.api.DashboardApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDashboardActivity**](DashboardApi.md#getdashboardactivity) | **GET** /api/v1/dashboard/activity | Dashboard Activity
[**getDashboardActivitySeries**](DashboardApi.md#getdashboardactivityseries) | **GET** /api/v1/dashboard/activity-series | Dashboard Activity Series
[**getDashboardAssetsSummary**](DashboardApi.md#getdashboardassetssummary) | **GET** /api/v1/dashboard/assets-summary | Dashboard Assets Summary
[**getDashboardPermitsSummary**](DashboardApi.md#getdashboardpermitssummary) | **GET** /api/v1/dashboard/permits-summary | Dashboard Permits Summary
[**getDashboardReportsSummary**](DashboardApi.md#getdashboardreportssummary) | **GET** /api/v1/dashboard/reports-summary | Dashboard Reports Summary
[**getDashboardSafetySummary**](DashboardApi.md#getdashboardsafetysummary) | **GET** /api/v1/dashboard/safety-summary | Dashboard Safety Summary
[**getDashboardSummary**](DashboardApi.md#getdashboardsummary) | **GET** /api/v1/dashboard/summary | Dashboard Summary


# **getDashboardActivity**
> DashboardActivityPage getDashboardActivity(limit, cursor, action)

Dashboard Activity

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();
final int limit = 56; // int |
final String cursor = cursor_example; // String |
final String action = action_example; // String |

try {
    final response = api.getDashboardActivity(limit, cursor, action);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardActivity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 20]
 **cursor** | **String**|  | [optional]
 **action** | **String**|  | [optional]

### Return type

[**DashboardActivityPage**](DashboardActivityPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardActivitySeries**
> DashboardActivitySeries getDashboardActivitySeries(window)

Dashboard Activity Series

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();
final int window = 56; // int |

try {
    final response = api.getDashboardActivitySeries(window);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardActivitySeries: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **window** | **int**|  | [optional] [default to 30]

### Return type

[**DashboardActivitySeries**](DashboardActivitySeries.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardAssetsSummary**
> AssetDashboardSummary getDashboardAssetsSummary()

Dashboard Assets Summary

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();

try {
    final response = api.getDashboardAssetsSummary();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardAssetsSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AssetDashboardSummary**](AssetDashboardSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardPermitsSummary**
> PermitDashboardSummary getDashboardPermitsSummary()

Dashboard Permits Summary

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();

try {
    final response = api.getDashboardPermitsSummary();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardPermitsSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PermitDashboardSummary**](PermitDashboardSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardReportsSummary**
> ReportDashboardSummary getDashboardReportsSummary()

Dashboard Reports Summary

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();

try {
    final response = api.getDashboardReportsSummary();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardReportsSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ReportDashboardSummary**](ReportDashboardSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardSafetySummary**
> SafetyDashboardSummary getDashboardSafetySummary()

Dashboard Safety Summary

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();

try {
    final response = api.getDashboardSafetySummary();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardSafetySummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SafetyDashboardSummary**](SafetyDashboardSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboardSummary**
> DashboardSummary getDashboardSummary(window)

Dashboard Summary

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDashboardApi();
final int window = 56; // int |

try {
    final response = api.getDashboardSummary(window);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DashboardApi->getDashboardSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **window** | **int**|  | [optional] [default to 30]

### Return type

[**DashboardSummary**](DashboardSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
