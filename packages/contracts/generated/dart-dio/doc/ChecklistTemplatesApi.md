# fev_api_client.api.ChecklistTemplatesApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createChecklistTemplate**](ChecklistTemplatesApi.md#createchecklisttemplate) | **POST** /api/v1/checklist-templates | Create Checklist Template
[**deleteChecklistTemplate**](ChecklistTemplatesApi.md#deletechecklisttemplate) | **DELETE** /api/v1/checklist-templates/{template_id} | Delete Checklist Template
[**getChecklistTemplate**](ChecklistTemplatesApi.md#getchecklisttemplate) | **GET** /api/v1/checklist-templates/{template_id} | Get Checklist Template
[**listChecklistTemplates**](ChecklistTemplatesApi.md#listchecklisttemplates) | **GET** /api/v1/checklist-templates | List Checklist Templates
[**updateChecklistTemplate**](ChecklistTemplatesApi.md#updatechecklisttemplate) | **PATCH** /api/v1/checklist-templates/{template_id} | Update Checklist Template


# **createChecklistTemplate**
> ChecklistTemplateDetail createChecklistTemplate(createChecklistTemplateRequest)

Create Checklist Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getChecklistTemplatesApi();
final CreateChecklistTemplateRequest createChecklistTemplateRequest = ; // CreateChecklistTemplateRequest |

try {
    final response = api.createChecklistTemplate(createChecklistTemplateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChecklistTemplatesApi->createChecklistTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createChecklistTemplateRequest** | [**CreateChecklistTemplateRequest**](CreateChecklistTemplateRequest.md)|  |

### Return type

[**ChecklistTemplateDetail**](ChecklistTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteChecklistTemplate**
> ChecklistTemplateDeleted deleteChecklistTemplate(templateId)

Delete Checklist Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getChecklistTemplatesApi();
final String templateId = templateId_example; // String |

try {
    final response = api.deleteChecklistTemplate(templateId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChecklistTemplatesApi->deleteChecklistTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |

### Return type

[**ChecklistTemplateDeleted**](ChecklistTemplateDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChecklistTemplate**
> ChecklistTemplateDetail getChecklistTemplate(templateId)

Get Checklist Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getChecklistTemplatesApi();
final String templateId = templateId_example; // String |

try {
    final response = api.getChecklistTemplate(templateId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChecklistTemplatesApi->getChecklistTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |

### Return type

[**ChecklistTemplateDetail**](ChecklistTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChecklistTemplates**
> ChecklistTemplateListPage listChecklistTemplates(category, cursor, limit)

List Checklist Templates

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getChecklistTemplatesApi();
final String category = category_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listChecklistTemplates(category, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChecklistTemplatesApi->listChecklistTemplates: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**ChecklistTemplateListPage**](ChecklistTemplateListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateChecklistTemplate**
> ChecklistTemplateDetail updateChecklistTemplate(templateId, updateChecklistTemplateRequest)

Update Checklist Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getChecklistTemplatesApi();
final String templateId = templateId_example; // String |
final UpdateChecklistTemplateRequest updateChecklistTemplateRequest = ; // UpdateChecklistTemplateRequest |

try {
    final response = api.updateChecklistTemplate(templateId, updateChecklistTemplateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChecklistTemplatesApi->updateChecklistTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |
 **updateChecklistTemplateRequest** | [**UpdateChecklistTemplateRequest**](UpdateChecklistTemplateRequest.md)|  |

### Return type

[**ChecklistTemplateDetail**](ChecklistTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
