# fev_api_client.api.PermitsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acknowledgePermit**](PermitsApi.md#acknowledgepermit) | **POST** /api/v1/permits/{permit_id}/acknowledge | Acknowledge Permit
[**activatePermit**](PermitsApi.md#activatepermit) | **POST** /api/v1/permits/{permit_id}/activate | Activate Permit
[**closePermit**](PermitsApi.md#closepermit) | **POST** /api/v1/permits/{permit_id}/close | Close Permit
[**createPermit**](PermitsApi.md#createpermit) | **POST** /api/v1/permits | Create Permit
[**decidePermitApproval**](PermitsApi.md#decidepermitapproval) | **POST** /api/v1/permits/{permit_id}/approval-decision | Decide Permit Approval
[**deletePermit**](PermitsApi.md#deletepermit) | **DELETE** /api/v1/permits/{permit_id} | Delete Permit
[**getPermit**](PermitsApi.md#getpermit) | **GET** /api/v1/permits/{permit_id} | Get Permit
[**listPermits**](PermitsApi.md#listpermits) | **GET** /api/v1/permits | List Permits
[**resumePermit**](PermitsApi.md#resumepermit) | **POST** /api/v1/permits/{permit_id}/resume | Resume Permit
[**revokePermit**](PermitsApi.md#revokepermit) | **POST** /api/v1/permits/{permit_id}/revoke | Revoke Permit
[**submitPermit**](PermitsApi.md#submitpermit) | **POST** /api/v1/permits/{permit_id}/submit | Submit Permit
[**suspendPermit**](PermitsApi.md#suspendpermit) | **POST** /api/v1/permits/{permit_id}/suspend | Suspend Permit
[**updatePermit**](PermitsApi.md#updatepermit) | **PATCH** /api/v1/permits/{permit_id} | Update Permit


# **acknowledgePermit**
> PermitDetail acknowledgePermit(permitId, acknowledgePermitRequest)

Acknowledge Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final AcknowledgePermitRequest acknowledgePermitRequest = ; // AcknowledgePermitRequest |

try {
    final response = api.acknowledgePermit(permitId, acknowledgePermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->acknowledgePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **acknowledgePermitRequest** | [**AcknowledgePermitRequest**](AcknowledgePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **activatePermit**
> PermitDetail activatePermit(permitId, activatePermitRequest)

Activate Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final ActivatePermitRequest activatePermitRequest = ; // ActivatePermitRequest |

try {
    final response = api.activatePermit(permitId, activatePermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->activatePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **activatePermitRequest** | [**ActivatePermitRequest**](ActivatePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **closePermit**
> PermitDetail closePermit(permitId, closePermitRequest)

Close Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final ClosePermitRequest closePermitRequest = ; // ClosePermitRequest |

try {
    final response = api.closePermit(permitId, closePermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->closePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **closePermitRequest** | [**ClosePermitRequest**](ClosePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPermit**
> PermitDetail createPermit(createPermitRequest)

Create Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final CreatePermitRequest createPermitRequest = ; // CreatePermitRequest |

try {
    final response = api.createPermit(createPermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->createPermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPermitRequest** | [**CreatePermitRequest**](CreatePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decidePermitApproval**
> PermitDetail decidePermitApproval(permitId, decidePermitApprovalRequest)

Decide Permit Approval

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final DecidePermitApprovalRequest decidePermitApprovalRequest = ; // DecidePermitApprovalRequest |

try {
    final response = api.decidePermitApproval(permitId, decidePermitApprovalRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->decidePermitApproval: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **decidePermitApprovalRequest** | [**DecidePermitApprovalRequest**](DecidePermitApprovalRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePermit**
> PermitDeleted deletePermit(permitId)

Delete Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |

try {
    final response = api.deletePermit(permitId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->deletePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |

### Return type

[**PermitDeleted**](PermitDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPermit**
> PermitDetail getPermit(permitId)

Get Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |

try {
    final response = api.getPermit(permitId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->getPermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPermits**
> PermitListPage listPermits(permitType, facilityId, workerId, cursor, limit)

List Permits

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitType = permitType_example; // String |
final String facilityId = facilityId_example; // String |
final String workerId = workerId_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listPermits(permitType, facilityId, workerId, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->listPermits: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitType** | **String**|  | [optional]
 **facilityId** | **String**|  | [optional]
 **workerId** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**PermitListPage**](PermitListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resumePermit**
> PermitDetail resumePermit(permitId, resumePermitRequest)

Resume Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final ResumePermitRequest resumePermitRequest = ; // ResumePermitRequest |

try {
    final response = api.resumePermit(permitId, resumePermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->resumePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **resumePermitRequest** | [**ResumePermitRequest**](ResumePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokePermit**
> PermitDetail revokePermit(permitId, controlPermitRequest)

Revoke Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final ControlPermitRequest controlPermitRequest = ; // ControlPermitRequest |

try {
    final response = api.revokePermit(permitId, controlPermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->revokePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **controlPermitRequest** | [**ControlPermitRequest**](ControlPermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitPermit**
> PermitDetail submitPermit(permitId, submitPermitRequest)

Submit Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final SubmitPermitRequest submitPermitRequest = ; // SubmitPermitRequest |

try {
    final response = api.submitPermit(permitId, submitPermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->submitPermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **submitPermitRequest** | [**SubmitPermitRequest**](SubmitPermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **suspendPermit**
> PermitDetail suspendPermit(permitId, controlPermitRequest)

Suspend Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final ControlPermitRequest controlPermitRequest = ; // ControlPermitRequest |

try {
    final response = api.suspendPermit(permitId, controlPermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->suspendPermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **controlPermitRequest** | [**ControlPermitRequest**](ControlPermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePermit**
> PermitDetail updatePermit(permitId, updatePermitRequest)

Update Permit

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getPermitsApi();
final String permitId = permitId_example; // String |
final UpdatePermitRequest updatePermitRequest = ; // UpdatePermitRequest |

try {
    final response = api.updatePermit(permitId, updatePermitRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PermitsApi->updatePermit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **permitId** | **String**|  |
 **updatePermitRequest** | [**UpdatePermitRequest**](UpdatePermitRequest.md)|  |

### Return type

[**PermitDetail**](PermitDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
