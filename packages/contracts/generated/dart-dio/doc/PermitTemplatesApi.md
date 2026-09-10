# fev_api_client.api.PermitTemplatesApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createPermitTemplate**](PermitTemplatesApi.md#createpermittemplate) | **POST** /api/v1/permit-templates | Create Permit Template
[**deletePermitTemplate**](PermitTemplatesApi.md#deletepermittemplate) | **DELETE** /api/v1/permit-templates/{template_id} | Delete Permit Template
[**getPermitTemplate**](PermitTemplatesApi.md#getpermittemplate) | **GET** /api/v1/permit-templates/{template_id} | Get Permit Template
[**listPermitTemplates**](PermitTemplatesApi.md#listpermittemplates) | **GET** /api/v1/permit-templates | List Permit Templates
[**updatePermitTemplate**](PermitTemplatesApi.md#updatepermittemplate) | **PATCH** /api/v1/permit-templates/{template_id} | Update Permit Template


# **createPermitTemplate**
> PermitTemplateDetail createPermitTemplate(createPermitTemplateRequest)

Create Permit Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitTemplatesApi();
final CreatePermitTemplateRequest createPermitTemplateRequest = ; // CreatePermitTemplateRequest |

try {
    final response = api.createPermitTemplate(createPermitTemplateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitTemplatesApi->createPermitTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPermitTemplateRequest** | [**CreatePermitTemplateRequest**](CreatePermitTemplateRequest.md)|  |

### Return type

[**PermitTemplateDetail**](PermitTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePermitTemplate**
> PermitTemplateDeleted deletePermitTemplate(templateId)

Delete Permit Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitTemplatesApi();
final String templateId = templateId_example; // String |

try {
    final response = api.deletePermitTemplate(templateId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitTemplatesApi->deletePermitTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |

### Return type

[**PermitTemplateDeleted**](PermitTemplateDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPermitTemplate**
> PermitTemplateDetail getPermitTemplate(templateId)

Get Permit Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitTemplatesApi();
final String templateId = templateId_example; // String |

try {
    final response = api.getPermitTemplate(templateId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitTemplatesApi->getPermitTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |

### Return type

[**PermitTemplateDetail**](PermitTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPermitTemplates**
> PermitTemplateListPage listPermitTemplates(permitType, cursor, limit)

List Permit Templates

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitTemplatesApi();
final String permitType = permitType_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listPermitTemplates(permitType, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitTemplatesApi->listPermitTemplates: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitType** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**PermitTemplateListPage**](PermitTemplateListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePermitTemplate**
> PermitTemplateDetail updatePermitTemplate(templateId, updatePermitTemplateRequest)

Update Permit Template

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitTemplatesApi();
final String templateId = templateId_example; // String |
final UpdatePermitTemplateRequest updatePermitTemplateRequest = ; // UpdatePermitTemplateRequest |

try {
    final response = api.updatePermitTemplate(templateId, updatePermitTemplateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitTemplatesApi->updatePermitTemplate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  |
 **updatePermitTemplateRequest** | [**UpdatePermitTemplateRequest**](UpdatePermitTemplateRequest.md)|  |

### Return type

[**PermitTemplateDetail**](PermitTemplateDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
