import 'package:fev_mobile/auth/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('can, hasAny, and hasAll evaluate a sample permission set', () {
    final access = PermissionAccess(const [
      'assets.read',
      'assets.write',
      'reports.read',
    ]);

    expect(access.can('assets.write'), isTrue);
    expect(access.can('users.manage'), isFalse);
    expect(access.hasAny(const ['users.manage', 'reports.read']), isTrue);
    expect(access.hasAny(const ['users.manage', 'roles.manage']), isFalse);
    expect(access.hasAll(const ['assets.read', 'assets.write']), isTrue);
    expect(access.hasAll(const ['assets.read', 'users.manage']), isFalse);
  });

  test('loads permissions once from the protected /me response', () async {
    var requests = 0;
    final client = MockClient((request) async {
      requests += 1;
      expect(request.url.path, '/api/v1/auth/me');
      expect(request.headers['Authorization'], 'Bearer test-token');
      return http.Response(
        '{"permissions":["assets.read","assets.write"]}',
        200,
      );
    });
    final controller = PermissionController(client: client);

    await controller.loadFromMe(idToken: 'test-token');

    expect(requests, 1);
    expect(controller.status, PermissionStatus.ready);
    expect(controller.can('assets.write'), isTrue);
    controller.dispose();
  });

  testWidgets('role with permission sees the protected block', (tester) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.write'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('Protected asset action'), findsOneWidget);
    expect(find.text('No access'), findsNothing);
    controller.dispose();
  });

  testWidgets('role without permission sees the no-access state',
      (tester) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.read'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('No access'), findsOneWidget);
    expect(find.text('Protected asset action'), findsNothing);
    controller.dispose();
  });
}
