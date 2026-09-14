# fev_api_client.api.BillingApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmCheckoutSession**](BillingApi.md#confirmcheckoutsession) | **POST** /api/v1/billing/checkout/confirm | Settle a returning checkout from its session id
[**createCheckoutSession**](BillingApi.md#createcheckoutsession) | **POST** /api/v1/billing/checkout | Start a Stripe Checkout session for a plan
[**getBillingCatalog**](BillingApi.md#getbillingcatalog) | **GET** /api/v1/billing/catalog | Published plan catalog
[**getSubscription**](BillingApi.md#getsubscription) | **GET** /api/v1/billing/subscription | This company&#39;s plan and entitlements


# **confirmCheckoutSession**
> CheckoutConfirmResponse confirmCheckoutSession(checkoutConfirmRequest)

Settle a returning checkout from its session id

Confirm the purchase the browser has just come back from.  Stripe redirects to the success URL as soon as the payment page is done, which is *before* it has necessarily delivered `checkout.session.completed`. Polling the read model alone therefore made a successful purchase look like a failure whenever the webhook was slow — or, on a deployment where the endpoint is not reachable, permanently. This route closes that gap by reading the session Stripe itself named in the return URL.  It is not a second source of truth: the state still comes from a live `retrieve_subscription`, exactly as webhook reconciliation does, so the two paths are interchangeable and replaying either is idempotent.

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getBillingApi();
final CheckoutConfirmRequest checkoutConfirmRequest = ; // CheckoutConfirmRequest |

try {
    final response = api.confirmCheckoutSession(checkoutConfirmRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BillingApi->confirmCheckoutSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkoutConfirmRequest** | [**CheckoutConfirmRequest**](CheckoutConfirmRequest.md)|  |

### Return type

[**CheckoutConfirmResponse**](CheckoutConfirmResponse.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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
