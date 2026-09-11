# fev_api_client.api.DocumentsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createDocument**](DocumentsApi.md#createdocument) | **POST** /api/v1/documents | Create Document
[**deleteDocument**](DocumentsApi.md#deletedocument) | **DELETE** /api/v1/documents/{document_id} | Delete Document
[**getDocument**](DocumentsApi.md#getdocument) | **GET** /api/v1/documents/{document_id} | Get Document
[**listDocuments**](DocumentsApi.md#listdocuments) | **GET** /api/v1/documents | List Documents
[**updateDocument**](DocumentsApi.md#updatedocument) | **PATCH** /api/v1/documents/{document_id} | Update Document


# **createDocument**
> DocumentDetail createDocument(createDocumentRequest)

Create Document

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDocumentsApi();
final CreateDocumentRequest createDocumentRequest = ; // CreateDocumentRequest |

try {
    final response = api.createDocument(createDocumentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->createDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createDocumentRequest** | [**CreateDocumentRequest**](CreateDocumentRequest.md)|  |

### Return type

[**DocumentDetail**](DocumentDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteDocument**
> DocumentDeleted deleteDocument(documentId)

Delete Document

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDocumentsApi();
final String documentId = documentId_example; // String |

try {
    final response = api.deleteDocument(documentId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->deleteDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  |

### Return type

[**DocumentDeleted**](DocumentDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDocument**
> DocumentDetail getDocument(documentId)

Get Document

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDocumentsApi();
final String documentId = documentId_example; // String |

try {
    final response = api.getDocument(documentId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->getDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  |

### Return type

[**DocumentDetail**](DocumentDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDocuments**
> DocumentListPage listDocuments(category, facilityId, status, search, cursor, limit)

List Documents

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDocumentsApi();
final String category = category_example; // String |
final String facilityId = facilityId_example; // String |
final String status = status_example; // String |
final String search = search_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listDocuments(category, facilityId, status, search, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->listDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional]
 **facilityId** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **search** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**DocumentListPage**](DocumentListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDocument**
> DocumentDetail updateDocument(documentId, updateDocumentRequest)

Update Document

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getDocumentsApi();
final String documentId = documentId_example; // String |
final UpdateDocumentRequest updateDocumentRequest = ; // UpdateDocumentRequest |

try {
    final response = api.updateDocument(documentId, updateDocumentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->updateDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  |
 **updateDocumentRequest** | [**UpdateDocumentRequest**](UpdateDocumentRequest.md)|  |

### Return type

[**DocumentDetail**](DocumentDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
