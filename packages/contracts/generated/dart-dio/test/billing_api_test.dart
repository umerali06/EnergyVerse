import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for BillingApi
void main() {
  final instance = FevApiClient().getBillingApi();

  group(BillingApi, () {
    // Settle a returning checkout from its session id
    //
    // Confirm the purchase the browser has just come back from.  Stripe redirects to the success URL as soon as the payment page is done, which is *before* it has necessarily delivered `checkout.session.completed`. Polling the read model alone therefore made a successful purchase look like a failure whenever the webhook was slow — or, on a deployment where the endpoint is not reachable, permanently. This route closes that gap by reading the session Stripe itself named in the return URL.  It is not a second source of truth: the state still comes from a live `retrieve_subscription`, exactly as webhook reconciliation does, so the two paths are interchangeable and replaying either is idempotent.
    //
    //Future<CheckoutConfirmResponse> confirmCheckoutSession(CheckoutConfirmRequest checkoutConfirmRequest) async
    test('test confirmCheckoutSession', () async {
      // TODO
    });

    // Start a Stripe Checkout session for a plan
    //
    // Only a Company Admin may attach billing to the company. The tier and interval are validated against the catalog rather than passed to Stripe as given, so a tampered request cannot buy an unpublished price.
    //
    //Future<CheckoutSessionResponse> createCheckoutSession(CheckoutSessionRequest checkoutSessionRequest) async
    test('test createCheckoutSession', () async {
      // TODO
    });

    // Published plan catalog
    //
    // Public. Serves the same catalog the API enforces against, so a client can never render a tier the backend does not honour.
    //
    //Future<BillingCatalogResponse> getBillingCatalog() async
    test('test getBillingCatalog', () async {
      // TODO
    });

    // This company's plan and entitlements
    //
    // Every authenticated user may read their own company's plan — the shell needs it to decide which modules to render, so gating it behind an admin permission would break the app for everyone else.
    //
    //Future<SubscriptionResponse> getSubscription() async
    test('test getSubscription', () async {
      // TODO
    });
  });
}
