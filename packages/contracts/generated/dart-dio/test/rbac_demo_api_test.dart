import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for RbacDemoApi
void main() {
  final instance = FevApiClient().getRbacDemoApi();

  group(RbacDemoApi, () {
    // All Permissions
    //
    //Future<DemoGateResponse> rbacDemoAllPermissions() async
    test('test rbacDemoAllPermissions', () async {
      // TODO
    });

    // Any Permission
    //
    //Future<DemoGateResponse> rbacDemoAnyPermission() async
    test('test rbacDemoAnyPermission', () async {
      // TODO
    });

    // Single Permission
    //
    //Future<DemoGateResponse> rbacDemoSinglePermission() async
    test('test rbacDemoSinglePermission', () async {
      // TODO
    });
  });
}
