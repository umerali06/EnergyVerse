import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for BillingApi
void main() {
  final instance = FevApiClient().getBillingApi();

  group(BillingApi, () {
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
