# fev_api_client.api.InspectionsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**analyzeInspectionMedia**](InspectionsApi.md#analyzeinspectionmedia) | **POST** /api/v1/inspections/{inspection_id}/media/{media_id}/analyze | Analyze Inspection Media
[**assignInspectionChecklistTemplate**](InspectionsApi.md#assigninspectionchecklisttemplate) | **POST** /api/v1/inspections/{inspection_id}/checklist-template | Assign Checklist Template
[**attachInspectionMedia**](InspectionsApi.md#attachinspectionmedia) | **POST** /api/v1/inspections/{inspection_id}/media | Attach Inspection Media
[**attachInspectionVoiceNote**](InspectionsApi.md#attachinspectionvoicenote) | **POST** /api/v1/inspections/{inspection_id}/voice-notes | Attach Inspection Voice Note
[**cancelInspection**](InspectionsApi.md#cancelinspection) | **POST** /api/v1/inspections/{inspection_id}/cancel | Cancel Inspection
[**completeInspection**](InspectionsApi.md#completeinspection) | **POST** /api/v1/inspections/{inspection_id}/complete | Complete Inspection
[**createInspection**](InspectionsApi.md#createinspection) | **POST** /api/v1/inspections | Create Inspection
[**createInspectionAnnotation**](InspectionsApi.md#createinspectionannotation) | **POST** /api/v1/inspections/{inspection_id}/annotations | Create Inspection Annotation
[**createInspectionArMeasurement**](InspectionsApi.md#createinspectionarmeasurement) | **POST** /api/v1/inspections/{inspection_id}/ar-measurements | Create Inspection Ar Measurement
[**deleteInspection**](InspectionsApi.md#deleteinspection) | **DELETE** /api/v1/inspections/{inspection_id} | Delete Inspection
[**deleteInspectionAnnotation**](InspectionsApi.md#deleteinspectionannotation) | **DELETE** /api/v1/inspections/{inspection_id}/annotations/{annotation_id} | Delete Inspection Annotation
[**deleteInspectionArMeasurement**](InspectionsApi.md#deleteinspectionarmeasurement) | **DELETE** /api/v1/inspections/{inspection_id}/ar-measurements/{measurement_id} | Delete Inspection Ar Measurement
[**detachInspectionMedia**](InspectionsApi.md#detachinspectionmedia) | **DELETE** /api/v1/inspections/{inspection_id}/media/{media_id} | Detach Inspection Media
[**detachInspectionVoiceNote**](InspectionsApi.md#detachinspectionvoicenote) | **DELETE** /api/v1/inspections/{inspection_id}/voice-notes/{voice_note_id} | Detach Inspection Voice Note
[**getInspection**](InspectionsApi.md#getinspection) | **GET** /api/v1/inspections/{inspection_id} | Get Inspection
[**listInspections**](InspectionsApi.md#listinspections) | **GET** /api/v1/inspections | List Inspections
[**reviewInspectionAiAnalysis**](InspectionsApi.md#reviewinspectionaianalysis) | **POST** /api/v1/inspections/{inspection_id}/ai-analysis/{analysis_id}/review | Review Inspection Ai Analysis
[**startInspection**](InspectionsApi.md#startinspection) | **POST** /api/v1/inspections/{inspection_id}/start | Start Inspection
[**updateInspection**](InspectionsApi.md#updateinspection) | **PATCH** /api/v1/inspections/{inspection_id} | Update Inspection
[**updateInspectionAnnotation**](InspectionsApi.md#updateinspectionannotation) | **PATCH** /api/v1/inspections/{inspection_id}/annotations/{annotation_id} | Update Inspection Annotation
[**updateInspectionArMeasurement**](InspectionsApi.md#updateinspectionarmeasurement) | **PATCH** /api/v1/inspections/{inspection_id}/ar-measurements/{measurement_id} | Update Inspection Ar Measurement
[**updateInspectionMedia**](InspectionsApi.md#updateinspectionmedia) | **PATCH** /api/v1/inspections/{inspection_id}/media/{media_id} | Update Inspection Media
[**updateInspectionVoiceNote**](InspectionsApi.md#updateinspectionvoicenote) | **PATCH** /api/v1/inspections/{inspection_id}/voice-notes/{voice_note_id} | Update Inspection Voice Note


# **analyzeInspectionMedia**
> InspectionDetail analyzeInspectionMedia(inspectionId, mediaId)

Analyze Inspection Media

Runs Claude vision analysis on one already-attached photo (spec 8 \"AI Photo & Video Analysis\", Phase 7.10) -- `media_id` is the media item's server id, matching `update_inspection_media`/`detach_inspection_media`'s own path parameter. Every finding lands as an advisory `Annotation(source=\"ai\", ...)`; nothing here ever auto-confirms a finding.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String mediaId = mediaId_example; // String |

try {
    final response = api.analyzeInspectionMedia(inspectionId, mediaId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->analyzeInspectionMedia: $e\n');
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

# **createInspectionArMeasurement**
> InspectionDetail createInspectionArMeasurement(inspectionId, createArMeasurementRequest)

Create Inspection Ar Measurement

Idempotent upsert keyed by the client-generated `id` (mirrors `create_inspection_annotation`) -- covers both AR-captured and manually-entered dimension measurements (spec 7.2 \"AR-based dimension measurement\", Phase 7.9, D-063).

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final CreateArMeasurementRequest createArMeasurementRequest = ; // CreateArMeasurementRequest |

try {
    final response = api.createInspectionArMeasurement(inspectionId, createArMeasurementRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->createInspectionArMeasurement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **createArMeasurementRequest** | [**CreateArMeasurementRequest**](CreateArMeasurementRequest.md)|  |

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

# **deleteInspectionArMeasurement**
> InspectionDetail deleteInspectionArMeasurement(inspectionId, measurementId)

Delete Inspection Ar Measurement

Idempotent on an already-deleted `measurement_id` -- the mobile outbox replays this call at-least-once.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String measurementId = measurementId_example; // String |

try {
    final response = api.deleteInspectionArMeasurement(inspectionId, measurementId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->deleteInspectionArMeasurement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **measurementId** | **String**|  |

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

# **reviewInspectionAiAnalysis**
> InspectionDetail reviewInspectionAiAnalysis(inspectionId, analysisId)

Review Inspection Ai Analysis

Marks an AI analysis run as reviewed by the authenticated caller -- the \"confirm\" half of \"confirm or override\" (D-008). Idempotent on an already-reviewed or missing `analysis_id`.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String analysisId = analysisId_example; // String |

try {
    final response = api.reviewInspectionAiAnalysis(inspectionId, analysisId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->reviewInspectionAiAnalysis: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **analysisId** | **String**|  |

### Return type

[**InspectionDetail**](InspectionDetail.md)

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

# **updateInspectionArMeasurement**
> InspectionDetail updateInspectionArMeasurement(inspectionId, measurementId, updateArMeasurementRequest)

Update Inspection Ar Measurement

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getInspectionsApi();
final String inspectionId = inspectionId_example; // String |
final String measurementId = measurementId_example; // String |
final UpdateArMeasurementRequest updateArMeasurementRequest = ; // UpdateArMeasurementRequest |

try {
    final response = api.updateInspectionArMeasurement(inspectionId, measurementId, updateArMeasurementRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InspectionsApi->updateInspectionArMeasurement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inspectionId** | **String**|  |
 **measurementId** | **String**|  |
 **updateArMeasurementRequest** | [**UpdateArMeasurementRequest**](UpdateArMeasurementRequest.md)|  |

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
