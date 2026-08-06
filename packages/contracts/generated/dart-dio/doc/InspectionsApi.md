# fev_api_client.api.InspectionsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignInspectionChecklistTemplate**](InspectionsApi.md#assigninspectionchecklisttemplate) | **POST** /api/v1/inspections/{inspection_id}/checklist-template | Assign Checklist Template
[**attachInspectionMedia**](InspectionsApi.md#attachinspectionmedia) | **POST** /api/v1/inspections/{inspection_id}/media | Attach Inspection Media
[**attachInspectionVoiceNote**](InspectionsApi.md#attachinspectionvoicenote) | **POST** /api/v1/inspections/{inspection_id}/voice-notes | Attach Inspection Voice Note
[**cancelInspection**](InspectionsApi.md#cancelinspection) | **POST** /api/v1/inspections/{inspection_id}/cancel | Cancel Inspection
[**completeInspection**](InspectionsApi.md#completeinspection) | **POST** /api/v1/inspections/{inspection_id}/complete | Complete Inspection
[**createInspection**](InspectionsApi.md#createinspection) | **POST** /api/v1/inspections | Create Inspection
[**createInspectionAnnotation**](InspectionsApi.md#createinspectionannotation) | **POST** /api/v1/inspections/{inspection_id}/annotations | Create Inspection Annotation
[**deleteInspection**](InspectionsApi.md#deleteinspection) | **DELETE** /api/v1/inspections/{inspection_id} | Delete Inspection
[**deleteInspectionAnnotation**](InspectionsApi.md#deleteinspectionannotation) | **DELETE** /api/v1/inspections/{inspection_id}/annotations/{annotation_id} | Delete Inspection Annotation
[**detachInspectionMedia**](InspectionsApi.md#detachinspectionmedia) | **DELETE** /api/v1/inspections/{inspection_id}/media/{media_id} | Detach Inspection Media
[**detachInspectionVoiceNote**](InspectionsApi.md#detachinspectionvoicenote) | **DELETE** /api/v1/inspections/{inspection_id}/voice-notes/{voice_note_id} | Detach Inspection Voice Note
[**getInspection**](InspectionsApi.md#getinspection) | **GET** /api/v1/inspections/{inspection_id} | Get Inspection
[**listInspections**](InspectionsApi.md#listinspections) | **GET** /api/v1/inspections | List Inspections
[**startInspection**](InspectionsApi.md#startinspection) | **POST** /api/v1/inspections/{inspection_id}/start | Start Inspection
[**updateInspection**](InspectionsApi.md#updateinspection) | **PATCH** /api/v1/inspections/{inspection_id} | Update Inspection
[**updateInspectionAnnotation**](InspectionsApi.md#updateinspectionannotation) | **PATCH** /api/v1/inspections/{inspection_id}/annotations/{annotation_id} | Update Inspection Annotation
[**updateInspectionMedia**](InspectionsApi.md#updateinspectionmedia) | **PATCH** /api/v1/inspections/{inspection_id}/media/{media_id} | Update Inspection Media
[**updateInspectionVoiceNote**](InspectionsApi.md#updateinspectionvoicenote) | **PATCH** /api/v1/inspections/{inspection_id}/voice-notes/{voice_note_id} | Update Inspection Voice Note


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

# **attachInspectionMedia**
> InspectionDetail attachInspectionMedia(inspectionId, attachInspectionMediaRequest)

Attach Inspection Media

Registers a reference to media the mobile client already uploaded directly to Firebase Storage (Phase 7.4) -- no bytes pass through here.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final AttachInspectionMediaRequest attachInspectionMediaRequest = ; // AttachInspectionMediaRequest |

try {
    final response = api.attachInspectionMedia(inspectionId, attachInspectionMediaRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->attachInspectionMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **attachInspectionMediaRequest** | [**AttachInspectionMediaRequest**](AttachInspectionMediaRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attachInspectionVoiceNote**
> InspectionDetail attachInspectionVoiceNote(inspectionId, attachVoiceNoteRequest)

Attach Inspection Voice Note

Registers a reference to a voice-note recording the mobile client already uploaded directly to Firebase Storage via the same 7.4 media queue/worker (Phase 7.6) -- no bytes pass through here.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final AttachVoiceNoteRequest attachVoiceNoteRequest = ; // AttachVoiceNoteRequest |

try {
    final response = api.attachInspectionVoiceNote(inspectionId, attachVoiceNoteRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->attachInspectionVoiceNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **attachVoiceNoteRequest** | [**AttachVoiceNoteRequest**](AttachVoiceNoteRequest.md)|  |

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
> InspectionDetail completeInspection(inspectionId, completeInspectionRequest)

Complete Inspection

Signature capture is the final step of completion (Phase 7.8) -- signer identity (`current_user.uid`/`role_key`) always comes from the verified token, never from the request body.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final CompleteInspectionRequest completeInspectionRequest = ; // CompleteInspectionRequest |

try {
    final response = api.completeInspection(inspectionId, completeInspectionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->completeInspection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **completeInspectionRequest** | [**CompleteInspectionRequest**](CompleteInspectionRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **createInspectionAnnotation**
> InspectionDetail createInspectionAnnotation(inspectionId, createAnnotationRequest)

Create Inspection Annotation

Idempotent upsert keyed by the client-generated `id` (mirrors `create_inspection`) -- annotations are vector metadata only, no image bytes pass through here.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final CreateAnnotationRequest createAnnotationRequest = ; // CreateAnnotationRequest |

try {
    final response = api.createInspectionAnnotation(inspectionId, createAnnotationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->createInspectionAnnotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **createAnnotationRequest** | [**CreateAnnotationRequest**](CreateAnnotationRequest.md)|  |

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

# **deleteInspectionAnnotation**
> InspectionDetail deleteInspectionAnnotation(inspectionId, annotationId)

Delete Inspection Annotation

Idempotent on an already-deleted `annotation_id` -- the mobile outbox replays this call at-least-once.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String annotationId = annotationId_example; // String |

try {
    final response = api.deleteInspectionAnnotation(inspectionId, annotationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->deleteInspectionAnnotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **annotationId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **detachInspectionMedia**
> InspectionDetail detachInspectionMedia(inspectionId, mediaId)

Detach Inspection Media

Idempotent on an already-detached `media_id` -- the mobile outbox replays this call at-least-once.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String mediaId = mediaId_example; // String |

try {
    final response = api.detachInspectionMedia(inspectionId, mediaId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->detachInspectionMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **mediaId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **detachInspectionVoiceNote**
> InspectionDetail detachInspectionVoiceNote(inspectionId, voiceNoteId)

Detach Inspection Voice Note

Idempotent on an already-detached `voice_note_id` -- the mobile outbox replays this call at-least-once.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String voiceNoteId = voiceNoteId_example; // String |

try {
    final response = api.detachInspectionVoiceNote(inspectionId, voiceNoteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->detachInspectionVoiceNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **voiceNoteId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

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

# **updateInspectionAnnotation**
> InspectionDetail updateInspectionAnnotation(inspectionId, annotationId, updateAnnotationRequest)

Update Inspection Annotation

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String annotationId = annotationId_example; // String |
final UpdateAnnotationRequest updateAnnotationRequest = ; // UpdateAnnotationRequest |

try {
    final response = api.updateInspectionAnnotation(inspectionId, annotationId, updateAnnotationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->updateInspectionAnnotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **annotationId** | **String**|  |
 **updateAnnotationRequest** | [**UpdateAnnotationRequest**](UpdateAnnotationRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateInspectionMedia**
> InspectionDetail updateInspectionMedia(inspectionId, mediaId, updateInspectionMediaRequest)

Update Inspection Media

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String mediaId = mediaId_example; // String |
final UpdateInspectionMediaRequest updateInspectionMediaRequest = ; // UpdateInspectionMediaRequest |

try {
    final response = api.updateInspectionMedia(inspectionId, mediaId, updateInspectionMediaRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->updateInspectionMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **mediaId** | **String**|  |
 **updateInspectionMediaRequest** | [**UpdateInspectionMediaRequest**](UpdateInspectionMediaRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateInspectionVoiceNote**
> InspectionDetail updateInspectionVoiceNote(inspectionId, voiceNoteId, updateVoiceNoteRequest)

Update Inspection Voice Note

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String voiceNoteId = voiceNoteId_example; // String |
final UpdateVoiceNoteRequest updateVoiceNoteRequest = ; // UpdateVoiceNoteRequest |

try {
    final response = api.updateInspectionVoiceNote(inspectionId, voiceNoteId, updateVoiceNoteRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->updateInspectionVoiceNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **voiceNoteId** | **String**|  |
 **updateVoiceNoteRequest** | [**UpdateVoiceNoteRequest**](UpdateVoiceNoteRequest.md)|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
