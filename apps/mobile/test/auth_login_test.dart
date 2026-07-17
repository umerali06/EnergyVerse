import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/auth_controller.dart';
import 'package:fev_mobile/auth/auth_experience.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/design_system/primitives.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const session = AuthSession(
  uid: 'firebase-uid',
  email: 'field_inspector@acme.example.invalid',
);

CurrentUser identity() => CurrentUser(
      (builder) => builder
        ..uid = 'firebase-uid'
        ..email = 'field_inspector@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..roleKey = 'field_inspector'
        ..permissions.addAll([
          'assets.read',
          'inspections.write',
          'reports.generate',
        ]),
    );

class FakeApi implements ApiContract {
  FakeApi(this.result);

  final Object result;
  int requests = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    if (result is Exception) throw result;
    return result as CurrentUser;
  }

  @override
  Future<HealthResponse> getHealth() => throw UnimplementedError();
}

class FakeGateway implements AuthGateway {
  FakeGateway({this.initial, this.signInResult = session});

  final AuthSession? initial;
  Object signInResult;
  int signInCalls = 0;
  int signOutCalls = 0;

  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(initial);

  @override
  Future<String?> getIdToken() async => 'id-token';

  @override
  Future<AuthSession> signIn(String email, String password) async {
    signInCalls += 1;
    if (signInResult is Exception) throw signInResult;
    if (signInResult is Future<AuthSession>) {
      return signInResult as Future<AuthSession>;
    }
    return signInResult as AuthSession;
  }

  @override
  Future<void> signOut() async {
    signOutCalls += 1;
  }
}

Future<void> pumpLogin(
  WidgetTester tester, {
  FakeGateway? gateway,
  FakeApi? api,
}) async {
  await tester.pumpWidget(
    FevApp(
      authGateway: gateway ?? FakeGateway(),
      api: api ?? FakeApi(identity()),
    ),
  );
  await tester.pump();
}

Future<void> enterCredentials(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'field_inspector@acme.example.invalid',
  );
  await tester.enterText(
    find.byKey(const Key('login-password')),
    'dev-password',
  );
  await tester.tap(find.text('Login'));
  await tester.pump();
}

void main() {
  testWidgets('validation blocks empty and malformed credentials',
      (tester) async {
    final gateway = FakeGateway();
    await pumpLogin(tester, gateway: gateway);

    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(gateway.signInCalls, 0);

    await tester.enterText(find.byKey(const Key('login-email')), 'invalid');
    await tester.enterText(find.byKey(const Key('login-password')), 'x');
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('loading toggles then /me populates home role and permissions',
      (tester) async {
    final completer = Completer<AuthSession>();
    final gateway = FakeGateway(signInResult: completer.future);
    await pumpLogin(tester, gateway: gateway);
    await enterCredentials(tester);

    expect(
      tester.widget<AppButton>(find.byType(AppButton)).loading,
      isTrue,
    );
    completer.complete(session);
    await tester.pumpAndSettle();
    expect(find.text('Role: field_inspector'), findsOneWidget);
    expect(find.text('inspections.write'), findsOneWidget);
  });

  for (final entry in <String, String>{
    'wrong-password': 'Invalid email or password',
    'user-not-found': 'Invalid email or password',
    'user-disabled': 'This account has been disabled',
    'too-many-requests': 'Too many login attempts. Please wait and try again',
    'network-request-failed':
        'Network unavailable. Check your connection and try again',
  }.entries) {
    testWidgets('maps ${entry.key} to safe feedback', (tester) async {
      final gateway = FakeGateway(
        signInResult: ClientAuthException(entry.key, 'raw provider error'),
      );
      await pumpLogin(tester, gateway: gateway);
      await enterCredentials(tester);
      await tester.pump();
      expect(find.text(entry.value), findsWidgets);
    });
  }

  testWidgets('/me 403 signs out and shows inactive-account feedback',
      (tester) async {
    final gateway = FakeGateway();
    final api = FakeApi(const ApiException(
      code: 'forbidden',
      message: 'Forbidden',
      statusCode: 403,
    ));
    await pumpLogin(tester, gateway: gateway, api: api);
    await enterCredentials(tester);
    await tester.pump();

    expect(find.text("Your account isn't active — contact your admin."),
        findsWidgets);
    expect(gateway.signOutCalls, 1);
  });

  testWidgets('existing Firebase session restores through /me', (tester) async {
    final api = FakeApi(identity());
    await pumpLogin(tester, gateway: FakeGateway(initial: session), api: api);
    await tester.pumpAndSettle();

    expect(find.text('Role: field_inspector'), findsOneWidget);
    expect(api.requests, 1);
  });

  testWidgets('sign out clears context and returns to login', (tester) async {
    final gateway = FakeGateway(initial: session);
    await pumpLogin(tester, gateway: gateway);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(gateway.signOutCalls, 1);
  });

  testWidgets('login entrance honors reduced motion', (tester) async {
    final controller = AuthController(
      gateway: FakeGateway(),
      api: FakeApi(identity()),
      feedback: (_) {},
    )..start();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AuthProvider(
            controller: controller,
            child: const AuthExperience(),
          ),
        ),
      ),
    );
    await tester.pump();

    final opacityWidgets =
        tester.widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacityWidgets.any((widget) => widget.duration == Duration.zero),
        isTrue);
    controller.dispose();
  });
}
