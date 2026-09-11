# fev_api_client.api.BillingApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCheckoutSession**](BillingApi.md#createcheckoutsession) | **POST** /api/v1/billing/checkout | Start a Stripe Checkout session for a plan
[**getBillingCatalog**](BillingApi.md#getbillingcatalog) | **GET** /api/v1/billing/catalog | Published plan catalog
[**getSubscription**](BillingApi.md#getsubscription) | **GET** /api/v1/billing/subscription | This company&#39;s plan and entitlements


# **createCheckoutSession**
> CheckoutSessionResponse createCheckoutSession(checkoutSessionRequest)

Start a Stripe Checkout session for a plan

Only a Company Admin may attach billing to the company. The tier and interval are validated against the catalog rather than passed to Stripe as given, so a tampered request cannot buy an unpublished price.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getBillingApi();
final CheckoutSessionRequest checkoutSessionRequest = ; // CheckoutSessionRequest |

try {
    final response = api.createCheckoutSession(checkoutSessionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BillingApi->createCheckoutSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkoutSessionRequest** | [**CheckoutSessionRequest**](CheckoutSessionRequest.md)|  |

### Return type

[**CheckoutSessionResponse**](CheckoutSessionResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBillingCatalog**
> BillingCatalogResponse getBillingCatalog()

Published plan catalog

Public. Serves the same catalog the API enforces against, so a client can never render a tier the backend does not honour.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getBillingApi();

try {
    final response = api.getBillingCatalog();
    print(response);
} catch on DioException (e) {
    print('Exception when calling BillingApi->getBillingCatalog: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BillingCatalogResponse**](BillingCatalogResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSubscription**
> SubscriptionResponse getSubscription()

This company's plan and entitlements

Every authenticated user may read their own company's plan — the shell needs it to decide which modules to render, so gating it behind an admin permission would break the app for everyone else.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getBillingApi();

try {
    final response = api.getSubscription();
    print(response);
} catch on DioException (e) {
    print('Exception when calling BillingApi->getSubscription: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SubscriptionResponse**](SubscriptionResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
