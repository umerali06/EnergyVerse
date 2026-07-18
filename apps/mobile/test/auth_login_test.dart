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
  emailVerified: true,
);

CurrentUser identity() => CurrentUser(
      (builder) => builder
        ..uid = 'firebase-uid'
        ..email = 'field_inspector@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..roleKey = 'field_inspector'
        ..emailVerified = true
        ..permissions.addAll([
          'assets.read',
          'inspections.write',
          'reports.generate',
        ]),
    );

class FakeApi implements ApiContract {
  FakeApi(this.result);

  Object result;
  int requests = 0;
  int registrations = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    if (result is Exception) throw result;
    return result as CurrentUser;
  }

  @override
  Future<HealthResponse> getHealth() => throw UnimplementedError();

  @override
  Future<CompanyRegistrationResponse> registerCompanyAdmin({
    required String companyName,
    required String displayName,
    required String email,
    required String password,
  }) async {
    registrations += 1;
    return CompanyRegistrationResponse(
      (builder) => builder
        ..companyId = 'new-company'
        ..email = email
        ..emailVerified = false
        ..roleKey = 'company_admin'
        ..uid = 'firebase-uid',
    );
  }
}

class FakeGateway implements AuthGateway {
  FakeGateway({this.initial, this.signInResult = session});

  final AuthSession? initial;
  Object signInResult;
  int signInCalls = 0;
  int signOutCalls = 0;
  int verificationCalls = 0;
  int passwordResetCalls = 0;
  Object? passwordResetResult;
  AuthSession refreshResult = session;

  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(initial);

  @override
  Future<String?> getIdToken() async => 'id-token';

  @override
  Future<AuthSession> refreshSession() async => refreshResult;

  @override
  Future<void> sendEmailVerification() async {
    verificationCalls += 1;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    passwordResetCalls += 1;
    final result = passwordResetResult;
    if (result is Exception) throw result;
    if (result is Future<void>) await result;
  }

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
  testWidgets('validation blocks empty and malformed credentials', (
    tester,
  ) async {
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

  testWidgets('loading toggles then /me populates home role and permissions', (
    tester,
  ) async {
    final completer = Completer<AuthSession>();
    final gateway = FakeGateway(signInResult: completer.future);
    await pumpLogin(tester, gateway: gateway);
    await enterCredentials(tester);

    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
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

  testWidgets('/me 403 signs out and shows inactive-account feedback', (
    tester,
  ) async {
    final gateway = FakeGateway();
    final api = FakeApi(
      const ApiException(
        code: 'forbidden',
        message: 'Forbidden',
        statusCode: 403,
      ),
    );
    await pumpLogin(tester, gateway: gateway, api: api);
    await enterCredentials(tester);
    await tester.pump();

    expect(
      find.text("Your account isn't active — contact your admin."),
      findsWidgets,
    );
    expect(gateway.signOutCalls, 1);
  });

  testWidgets('existing Firebase session restores through /me', (tester) async {
    final api = FakeApi(identity());
    await pumpLogin(
      tester,
      gateway: FakeGateway(initial: session),
      api: api,
    );
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

    final opacityWidgets = tester.widgetList<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(
      opacityWidgets.any((widget) => widget.duration == Duration.zero),
      isTrue,
    );
    controller.dispose();
  });

  testWidgets('signup validation blocks invalid values', (tester) async {
    final gateway = FakeGateway();
    final api = FakeApi(identity());
    await pumpLogin(tester, gateway: gateway, api: api);
    await tester.tap(find.byKey(const Key('open-signup')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create organization'));
    await tester.tap(find.text('Create organization'));
    await tester.pump();
    expect(find.text('Company name is required'), findsOneWidget);
    expect(find.text('Display name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(api.registrations, 0);
  });

  testWidgets('signup provisions then sends verification email', (
    tester,
  ) async {
    final unverified = identity().rebuild(
      (builder) => builder.emailVerified = false,
    );
    final gateway = FakeGateway(
      signInResult: const AuthSession(
        uid: 'firebase-uid',
        email: 'admin@example.com',
        emailVerified: false,
      ),
    );
    final api = FakeApi(unverified);
    await pumpLogin(tester, gateway: gateway, api: api);
    await tester.tap(find.byKey(const Key('open-signup')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('signup-company')),
      'Northstar',
    );
    await tester.enterText(
      find.byKey(const Key('signup-display-name')),
      'Ada Admin',
    );
    await tester.enterText(
      find.byKey(const Key('signup-email')),
      'admin@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('signup-password')),
      'StrongPass1',
    );
    await tester.enterText(
      find.byKey(const Key('signup-confirm-password')),
      'StrongPass1',
    );
    await tester.ensureVisible(find.text('Create organization'));
    await tester.tap(find.text('Create organization'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your email'), findsOneWidget);
    expect(api.registrations, 1);
    expect(gateway.verificationCalls, 1);
    expect(find.text('Verification email sent'), findsWidgets);
  });

  testWidgets(
    'unverified session resends once and verified refresh reaches home',
    (tester) async {
      final unverified = identity().rebuild(
        (builder) => builder.emailVerified = false,
      );
      final api = FakeApi(unverified);
      final gateway = FakeGateway(
        initial: const AuthSession(
          uid: 'firebase-uid',
          email: 'field_inspector@acme.example.invalid',
          emailVerified: false,
        ),
      );
      await pumpLogin(tester, gateway: gateway, api: api);
      await tester.pumpAndSettle();
      expect(find.text('Verify your email'), findsOneWidget);

      await tester.tap(find.text('Resend verification'));
      await tester.pump();
      expect(gateway.verificationCalls, 1);
      expect(find.text('Verification email sent'), findsWidgets);

      api.result = identity();
      gateway.refreshResult = session;
      await tester.tap(find.text("I've verified — continue"));
      await tester.pumpAndSettle();
      expect(find.text('Role: field_inspector'), findsOneWidget);
    },
  );

  testWidgets('forgot-password validation blocks empty and invalid email', (
    tester,
  ) async {
    final gateway = FakeGateway();
    await pumpLogin(tester, gateway: gateway);
    await tester.tap(find.byKey(const Key('open-forgot-password')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(gateway.passwordResetCalls, 0);
    await tester.enterText(find.byKey(const Key('forgot-email')), 'invalid');
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('reset loading becomes neutral confirmation with cooldown', (
    tester,
  ) async {
    final completer = Completer<void>();
    final gateway = FakeGateway()..passwordResetResult = completer.future;
    await pumpLogin(tester, gateway: gateway);
    await tester.tap(find.byKey(const Key('open-forgot-password')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('forgot-email')),
      'known@example.com',
    );
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
    completer.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.text(
        'If an account exists for that email, a reset link has been sent.',
      ),
      findsOneWidget,
    );
    expect(gateway.passwordResetCalls, 1);
    expect(find.textContaining('Resend available in'), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).onPressed, isNull);
    await tester.tap(find.text('Back to login'));
    await tester.pump();
  });

  testWidgets('user-not-found produces the same neutral confirmation', (
    tester,
  ) async {
    final gateway = FakeGateway()
      ..passwordResetResult = const ClientAuthException(
        'user-not-found',
        'raw provider response',
      );
    await pumpLogin(tester, gateway: gateway);
    await tester.tap(find.byKey(const Key('open-forgot-password')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('forgot-email')),
      'missing@example.com',
    );
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.text(
        'If an account exists for that email, a reset link has been sent.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Back to login'));
    await tester.pump();
  });

  for (final entry in <String, String>{
    'too-many-requests': 'Too many reset attempts. Please wait and try again',
    'network-request-failed':
        'Network unavailable. Check your connection and try again',
  }.entries) {
    testWidgets('reset maps ${entry.key} to genuine error feedback', (
      tester,
    ) async {
      final gateway = FakeGateway()
        ..passwordResetResult = ClientAuthException(entry.key, 'raw');
      await pumpLogin(tester, gateway: gateway);
      await tester.tap(find.byKey(const Key('open-forgot-password')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('forgot-email')),
        'operator@example.com',
      );
      await tester.tap(find.text('Send reset link'));
      await tester.pump();
      expect(find.text(entry.value), findsWidgets);
      expect(find.text('Reset link requested'), findsNothing);
    });
  }

  testWidgets('forgot-password entrance honors reduced motion', (tester) async {
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
    await tester.tap(find.byKey(const Key('open-forgot-password')));
    await tester.pump();
    final opacityWidgets =
        tester.widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacityWidgets.any((widget) => widget.duration == Duration.zero),
        isTrue);
    controller.dispose();
  });
}
