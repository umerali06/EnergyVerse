# fev_api_client.api.AuthApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCurrentUser**](AuthApi.md#getcurrentuser) | **GET** /api/v1/auth/me | Me
[**registerCompanyAdmin**](AuthApi.md#registercompanyadmin) | **POST** /api/v1/auth/register | Register Company Admin
[**sendVerificationEmail**](AuthApi.md#sendverificationemail) | **POST** /api/v1/auth/verification-email | Request Verification Email


# **getCurrentUser**
> CurrentUser getCurrentUser()

Me

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuthApi();

try {
    final response = api.getCurrentUser();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->getCurrentUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CurrentUser**](CurrentUser.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerCompanyAdmin**
> CompanyRegistrationResponse registerCompanyAdmin(companyRegistrationRequest)

Register Company Admin

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuthApi();
final CompanyRegistrationRequest companyRegistrationRequest = ; // CompanyRegistrationRequest |

try {
    final response = api.registerCompanyAdmin(companyRegistrationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->registerCompanyAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyRegistrationRequest** | [**CompanyRegistrationRequest**](CompanyRegistrationRequest.md)|  |

### Return type

[**CompanyRegistrationResponse**](CompanyRegistrationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendVerificationEmail**
> VerificationEmailResponse sendVerificationEmail()

Request Verification Email

Send this user a branded verification email through SES.  Returns `sent=false` when the address is already verified -- that is a no-op, not a failure. A missing SES configuration is reported as a 503 rather than a 500: the caller asked for something the deployment cannot currently do, and the distinction is actionable.  A configured-but-refused SES is a 502, kept separate from both. Credentials can be *present* and still rejected -- a rotated key, an unverified sender, the wrong region, sandbox restrictions -- and `ses_configured` cannot see any of that, so this used to escape as an unhandled 500 saying \"the server is broken\" about a working server whose mail provider had refused it. It matters more since D-103, because registration now sends through this route rather than the provider's own unbranded sender; the admin client falls back to that sender on any failure here, and a truthful status is what lets it tell \"cannot send\" apart from a genuine fault.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAuthApi();

try {
    final response = api.sendVerificationEmail();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->sendVerificationEmail: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VerificationEmailResponse**](VerificationEmailResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
