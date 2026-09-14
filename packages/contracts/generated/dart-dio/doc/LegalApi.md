# fev_api_client.api.LegalApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getLegalAcceptance**](LegalApi.md#getlegalacceptance) | **GET** /api/v1/legal/acceptance | What this user accepted, and whether it is still current
[**submitContactMessage**](LegalApi.md#submitcontactmessage) | **POST** /api/v1/contact | Send a message to Flacron Energy support


# **getLegalAcceptance**
> LegalAcceptanceResponse getLegalAcceptance()

What this user accepted, and whether it is still current

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getLegalApi();

try {
    final response = api.getLegalAcceptance();
    print(response);
} catch on DioException (e) {
    print('Exception when calling LegalApi->getLegalAcceptance: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**LegalAcceptanceResponse**](LegalAcceptanceResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitContactMessage**
> ContactResponse submitContactMessage(contactRequest)

Send a message to Flacron Energy support

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getLegalApi();
final ContactRequest contactRequest = ; // ContactRequest |

try {
    final response = api.submitContactMessage(contactRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LegalApi->submitContactMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contactRequest** | [**ContactRequest**](ContactRequest.md)|  |

### Return type

[**ContactResponse**](ContactResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
