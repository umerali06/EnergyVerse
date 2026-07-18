import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/auth_controller.dart';
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

CurrentUser writerIdentity() => identity().rebuild(
      (builder) => builder
        ..roleKey = 'operations_manager'
        ..permissions.add('assets.write'),
    );

class FakeApi implements ApiContract {
  FakeApi(this.result);

  Object result;
  Future<void>? gate;
  int requests = 0;
  int registrations = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    if (gate != null) await gate;
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
  int refreshCalls = 0;
  Object? passwordResetResult;
  AuthSession refreshResult = session;

  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(initial);

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'id-token';

  @override
  Future<AuthSession> refreshSession() async {
    refreshCalls += 1;
    return refreshResult;
  }

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

Future<void> pumpApp(
  WidgetTester tester, {
  FakeGateway? gateway,
  FakeApi? api,
  String initialRoute = AppRoutes.login,
}) async {
  await tester.pumpWidget(
    FevApp(
      authGateway: gateway ?? FakeGateway(),
      api: api ?? FakeApi(identity()),
      initialRoute: initialRoute,
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

Future<AuthController> pumpReducedMotion(
  WidgetTester tester, {
  String initialRoute = AppRoutes.login,
}) async {
  final controller = AuthController(
    gateway: FakeGateway(),
    api: FakeApi(identity()),
    feedback: (_) {},
  )..start();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.dark,
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (initial) => [
        AppRoutes.onGenerateRoute(RouteSettings(name: initial))!,
      ],
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: (context, child) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: AuthProvider(controller: controller, child: child!),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return controller;
}

void main() {
  testWidgets('validation blocks empty and malformed credentials', (
    tester,
  ) async {
    final gateway = FakeGateway();
    await pumpApp(tester, gateway: gateway);

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
    await pumpApp(tester, gateway: gateway);
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
      await pumpApp(tester, gateway: gateway);
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
    await pumpApp(tester, gateway: gateway, api: api);
    await enterCredentials(tester);
    await tester.pump();

    expect(
      find.text("Your account isn't active — contact your admin."),
      findsWidgets,
    );
    expect(gateway.signOutCalls, 1);
  });

  testWidgets('restore shows the splash and never flashes login', (
    tester,
  ) async {
    final api = FakeApi(identity());
    final gate = Completer<void>();
    api.gate = gate.future;
    await pumpApp(
      tester,
      gateway: FakeGateway(initial: session),
      api: api,
      initialRoute: AppRoutes.home,
    );

    expect(find.byKey(const Key('auth-splash')), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('Role: field_inspector'), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('Role: field_inspector'), findsOneWidget);
    expect(api.requests, 1);
  });

  testWidgets('a dead session expires with feedback and a login redirect', (
    tester,
  ) async {
    final gateway = FakeGateway(initial: session);
    final api = FakeApi(
      const ApiException(
        code: 'token_revoked',
        message: 'Token has been revoked',
        statusCode: 401,
      ),
    );
    await pumpApp(
      tester,
      gateway: gateway,
      api: api,
      initialRoute: AppRoutes.home,
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text(AuthController.sessionExpiredMessage), findsWidgets);
    expect(gateway.signOutCalls, 1);
  });

  testWidgets('deep link is remembered through login and reached after it', (
    tester,
  ) async {
    final api = FakeApi(writerIdentity());
    await pumpApp(tester, api: api, initialRoute: AppRoutes.rbacDemo);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    await enterCredentials(tester);
    await tester.pumpAndSettle();

    expect(find.text('Assets demo'), findsWidgets);
    expect(find.text("You can't view this area"), findsNothing);
  });

  testWidgets('a role without the permission gets the branded 403 screen', (
    tester,
  ) async {
    await pumpApp(
      tester,
      gateway: FakeGateway(initial: session),
      api: FakeApi(identity()),
      initialRoute: AppRoutes.rbacDemo,
    );
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    expect(find.text('Assets demo'), findsNothing);
    await tester.ensureVisible(find.text('Back to Home'));
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.text('Role: field_inspector'), findsOneWidget);
  });

  testWidgets('an authenticated user is redirected away from login', (
    tester,
  ) async {
    await pumpApp(
      tester,
      gateway: FakeGateway(initial: session),
      initialRoute: AppRoutes.login,
    );
    await tester.pumpAndSettle();

    expect(find.text('Role: field_inspector'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  testWidgets('an unverified user is blocked from protected routes', (
    tester,
  ) async {
    final unverified = identity().rebuild(
      (builder) => builder.emailVerified = false,
    );
    await pumpApp(
      tester,
      gateway: FakeGateway(
        initial: const AuthSession(
          uid: 'firebase-uid',
          email: 'field_inspector@acme.example.invalid',
          emailVerified: false,
        ),
      ),
      api: FakeApi(unverified),
      initialRoute: AppRoutes.rbacDemo,
    );
    await tester.pumpAndSettle();

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('Assets demo'), findsNothing);
    expect(find.text("You can't view this area"), findsNothing);
  });

  testWidgets('sign out clears everything and back-nav stays on login', (
    tester,
  ) async {
    final gateway = FakeGateway(initial: session);
    await pumpApp(tester, gateway: gateway, initialRoute: AppRoutes.home);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(gateway.signOutCalls, 1);

    // Simulate returning to the protected URL after logout.
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .pushNamed(AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Role: field_inspector'), findsNothing);
  });

  testWidgets('refresh session re-resolves /me and surfaces new permissions', (
    tester,
  ) async {
    final gateway = FakeGateway(initial: session);
    final api = FakeApi(identity());
    await pumpApp(tester, gateway: gateway, api: api, initialRoute: AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.text('assets.write'), findsNothing);

    api.result = writerIdentity();
    await tester.ensureVisible(find.byKey(const Key('refresh-session')));
    await tester.tap(find.byKey(const Key('refresh-session')));
    await tester.pumpAndSettle();

    expect(gateway.refreshCalls, 1);
    expect(api.requests, 2);
    expect(find.text('assets.write'), findsOneWidget);
  });

  testWidgets('login entrance honors reduced motion', (tester) async {
    final controller = await pumpReducedMotion(tester);

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
    await pumpApp(tester, gateway: gateway, api: api);
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
    await pumpApp(tester, gateway: gateway, api: api);
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
      await pumpApp(
        tester,
        gateway: gateway,
        api: api,
        initialRoute: AppRoutes.home,
      );
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
    await pumpApp(tester, gateway: gateway);
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
    await pumpApp(tester, gateway: gateway);
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
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('user-not-found produces the same neutral confirmation', (
    tester,
  ) async {
    final gateway = FakeGateway()
      ..passwordResetResult = const ClientAuthException(
        'user-not-found',
        'raw provider response',
      );
    await pumpApp(tester, gateway: gateway);
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
    await tester.pump(const Duration(seconds: 1));
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
      await pumpApp(tester, gateway: gateway);
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
    final controller = await pumpReducedMotion(
      tester,
      initialRoute: AppRoutes.forgotPassword,
    );
    expect(find.text('Forgot password'), findsOneWidget);
    final opacityWidgets =
        tester.widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacityWidgets.any((widget) => widget.duration == Duration.zero),
        isTrue);
    controller.dispose();
  });
}
