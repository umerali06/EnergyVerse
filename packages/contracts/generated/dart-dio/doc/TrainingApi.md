# fev_api_client.api.TrainingApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**completeTrainingModule**](TrainingApi.md#completetrainingmodule) | **POST** /api/v1/training/modules/{module_id}/complete | Complete Training Module
[**completeTrainingStep**](TrainingApi.md#completetrainingstep) | **POST** /api/v1/training/modules/{module_id}/steps/{step_id}/complete | Complete Training Step
[**getTrainingModule**](TrainingApi.md#gettrainingmodule) | **GET** /api/v1/training/modules/{module_id} | Get Training Module
[**listTrainingModules**](TrainingApi.md#listtrainingmodules) | **GET** /api/v1/training/modules | List Training Modules
[**listTrainingProgress**](TrainingApi.md#listtrainingprogress) | **GET** /api/v1/training/progress | List Training Progress
[**startTrainingModule**](TrainingApi.md#starttrainingmodule) | **POST** /api/v1/training/modules/{module_id}/start | Start Training Module


# **completeTrainingModule**
> TrainingProgressResponse completeTrainingModule(moduleId)

Complete Training Module

Scores the attempt and records pass or fail against the module's threshold.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String moduleId = moduleId_example; // String |

try {
    final response = api.completeTrainingModule(moduleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->completeTrainingModule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **moduleId** | **String**|  |

### Return type

[**TrainingProgressResponse**](TrainingProgressResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeTrainingStep**
> TrainingProgressResponse completeTrainingStep(moduleId, stepId, completeTrainingStepRequest)

Complete Training Step

Idempotent -- replaying a recorded step does not double-count its score.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String moduleId = moduleId_example; // String |
final String stepId = stepId_example; // String |
final CompleteTrainingStepRequest completeTrainingStepRequest = ; // CompleteTrainingStepRequest |

try {
    final response = api.completeTrainingStep(moduleId, stepId, completeTrainingStepRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->completeTrainingStep: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **moduleId** | **String**|  |
 **stepId** | **String**|  |
 **completeTrainingStepRequest** | [**CompleteTrainingStepRequest**](CompleteTrainingStepRequest.md)|  |

### Return type

[**TrainingProgressResponse**](TrainingProgressResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTrainingModule**
> TrainingModuleResponse getTrainingModule(moduleId)

Get Training Module

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String moduleId = moduleId_example; // String |

try {
    final response = api.getTrainingModule(moduleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->getTrainingModule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **moduleId** | **String**|  |

### Return type

[**TrainingModuleResponse**](TrainingModuleResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTrainingModules**
> TrainingModuleListPage listTrainingModules(facilityId, kind)

List Training Modules

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String facilityId = facilityId_example; // String |
final String kind = kind_example; // String |

try {
    final response = api.listTrainingModules(facilityId, kind);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->listTrainingModules: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  | [optional]
 **kind** | **String**|  | [optional]

### Return type

[**TrainingModuleListPage**](TrainingModuleListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTrainingProgress**
> TrainingProgressListPage listTrainingProgress(moduleId)

List Training Progress

The caller's own training record, newest attempt first.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String moduleId = moduleId_example; // String |

try {
    final response = api.listTrainingProgress(moduleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->listTrainingProgress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **moduleId** | **String**|  | [optional]

### Return type

[**TrainingProgressListPage**](TrainingProgressListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startTrainingModule**
> TrainingProgressResponse startTrainingModule(moduleId)

Start Training Module

Resumes an attempt already in progress rather than discarding it, so a dropped headset connection does not lose the run.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getTrainingApi();
final String moduleId = moduleId_example; // String |

try {
    final response = api.startTrainingModule(moduleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TrainingApi->startTrainingModule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **moduleId** | **String**|  |

### Return type

[**TrainingProgressResponse**](TrainingProgressResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
