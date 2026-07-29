# fev_api_client.api.QrApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resolveQrCode**](QrApi.md#resolveqrcode) | **GET** /api/v1/qr/{code}/resolve | Resolve Qr Code


# **resolveQrCode**
> QrScanResult resolveQrCode(code)

Resolve Qr Code

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getQrApi();
final String code = code_example; // String |

try {
    final response = api.resolveQrCode(code);
    print(response);
} catch on DioException (e) {
    print('Exception when calling QrApi->resolveQrCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  |

### Return type

[**QrScanResult**](QrScanResult.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
