import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import 'firebase_gateway.dart';

enum AuthStatus {
  restoring,
  signedOut,
  signingIn,
  signingUp,
  sendingPasswordReset,
  verificationRequired,
  checkingVerification,
  authenticated,
}

class RegistrationInput {
  const RegistrationInput({
    required this.companyName,
    required this.displayName,
    required this.email,
    required this.password,
  });

  final String companyName;
  final String displayName;
  final String email;
  final String password;
}

typedef AuthFeedback = void Function(String message);

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthGateway gateway,
    required ApiContract api,
    required AuthFeedback feedback,
  })  : _gateway = gateway,
        _api = api,
        _feedback = feedback;

  final AuthGateway _gateway;
  final ApiContract _api;
  final AuthFeedback _feedback;
  StreamSubscription<AuthSession?>? _subscription;
  Future<void>? _resolution;
  String? _resolutionUid;
  bool _disposed = false;

  static const sessionExpiredMessage =
      'Your session has expired. Please sign in again';

  AuthStatus _status = AuthStatus.restoring;
  CurrentUser? _currentUser;
  String? _error;
  DateTime? _verificationSentAt;
  DateTime? _passwordResetSentAt;
  String? _pendingRoute;
  bool _expiring = false;

  AuthStatus get status => _status;
  CurrentUser? get currentUser => _currentUser;
  String? get error => _error;
  DateTime? get verificationSentAt => _verificationSentAt;
  DateTime? get passwordResetSentAt => _passwordResetSentAt;

  /// Destination captured by a route guard before redirecting to login,
  /// consumed once after a successful sign-in.
  set pendingRoute(String? route) => _pendingRoute = route;
  String? takePendingRoute() {
    final route = _pendingRoute;
    _pendingRoute = null;
    return route;
  }
  bool get verificationResendAvailable =>
      _verificationSentAt == null ||
      DateTime.now().difference(_verificationSentAt!) >=
          const Duration(seconds: 60);

  void start() {
    _subscription ??= _gateway.authStateChanges().listen((session) {
      if (session == null) {
        _currentUser = null;
        if (_status != AuthStatus.signingIn &&
            _status != AuthStatus.signingUp) {
          _status = AuthStatus.signedOut;
        }
        _notify();
      } else {
        unawaited(_resolveSession(session));
      }
    }, onError: (Object error) => _fail(error));
  }

  Future<void> signIn(String email, String password) async {
    if (_status == AuthStatus.signingIn) return;
    _expiring = false;
    _error = null;
    _status = AuthStatus.signingIn;
    _notify();
    try {
      final session = await _gateway.signIn(email, password);
      await _resolveSession(session);
    } catch (failure) {
      _fail(failure);
    }
  }

  Future<void> register(RegistrationInput input) async {
    if (_status == AuthStatus.signingUp) return;
    _expiring = false;
    _error = null;
    _status = AuthStatus.signingUp;
    _notify();
    try {
      await _api.registerCompanyAdmin(
        companyName: input.companyName,
        displayName: input.displayName,
        email: input.email,
        password: input.password,
      );
      final session = await _gateway.signIn(input.email, input.password);
      await _resolveSession(session);
      await _gateway.sendEmailVerification();
      _verificationSentAt = DateTime.now();
      _feedback('Verification email sent');
      _status = AuthStatus.verificationRequired;
      _notify();
    } catch (failure) {
      _fail(
        failure,
        fallback: 'Unable to create your account. Please try again',
      );
    }
  }

  Future<void> resendVerification() async {
    if (!verificationResendAvailable) return;
    try {
      await _gateway.sendEmailVerification();
      _verificationSentAt = DateTime.now();
      _feedback('Verification email sent');
      _notify();
    } catch (failure) {
      final message = friendlyMessage(failure);
      _error = message;
      _feedback(message);
      _notify();
    }
  }

  Future<bool> refreshVerification() async {
    _status = AuthStatus.checkingVerification;
    _notify();
    try {
      final session = await _gateway.refreshSession();
      await _resolveSession(session);
      if (_currentUser?.emailVerified == true) return true;
      _status = AuthStatus.verificationRequired;
      _feedback('Your email is not verified yet');
      _notify();
      return false;
    } catch (failure) {
      _fail(failure);
      return false;
    }
  }

  /// Clean local sign-out for a dead session (refresh + retry already failed).
  /// Idempotent until the next sign-in attempt, so the API hook and resolve
  /// paths never double-report the same dead session.
  Future<void> expireSession() async {
    if (_expiring) return;
    _expiring = true;
    try {
      await _gateway.signOut();
    } catch (_) {
      // The local session is cleared regardless of the provider call outcome.
    } finally {
      _currentUser = null;
      _error = null;
      _status = AuthStatus.signedOut;
      _feedback(sessionExpiredMessage);
      _notify();
    }
  }

  /// Force-refreshes the Firebase token and re-resolves `/me`, surfacing
  /// server-side role/claims changes without a fresh login.
  Future<void> refreshSession() async {
    try {
      final session = await _gateway.refreshSession();
      await _resolveSession(session);
    } catch (failure) {
      if (failure is ClientAuthException &&
          const {
            'no-current-user',
            'user-token-expired',
            'invalid-user-token',
            'user-disabled',
          }.contains(failure.code)) {
        await expireSession();
        return;
      }
      final message = friendlyMessage(failure);
      _error = message;
      _feedback(message);
      _notify();
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    if (_status == AuthStatus.sendingPasswordReset) return false;
    _error = null;
    _status = AuthStatus.sendingPasswordReset;
    _notify();
    try {
      await _gateway.sendPasswordResetEmail(email);
    } catch (failure) {
      if (failure is! ClientAuthException ||
          !{'user-not-found', 'user-disabled'}.contains(failure.code)) {
        final message = friendlyPasswordResetMessage(failure);
        _error = message;
        _status = AuthStatus.signedOut;
        _feedback(message);
        _notify();
        return false;
      }
      // Deliberately indistinguishable from success to prevent enumeration.
    }
    _passwordResetSentAt = DateTime.now();
    _status = AuthStatus.signedOut;
    _notify();
    return true;
  }

  Future<void> _resolveSession(AuthSession session) async {
    if (_resolution != null && _resolutionUid == session.uid) {
      await _resolution;
      return;
    }
    _resolutionUid = session.uid;
    _resolution = () async {
      try {
        final identity = await _api.getCurrentUser();
        _currentUser = identity;
        _error = null;
        _status = identity.emailVerified
            ? AuthStatus.authenticated
            : AuthStatus.verificationRequired;
        _notify();
      } catch (failure) {
        if (failure is ApiException && failure.statusCode == 401) {
          // Token refresh + retry already failed inside the API layer: the
          // session is dead. expireSession is idempotent with the API hook.
          await expireSession();
          return;
        }
        if (failure is ApiException && failure.statusCode == 403) {
          await _gateway.signOut();
        }
        _fail(failure);
      } finally {
        _resolution = null;
        _resolutionUid = null;
      }
    }();
    await _resolution;
  }

  Future<void> signOut() async {
    try {
      await _gateway.signOut();
    } finally {
      _currentUser = null;
      _error = null;
      _status = AuthStatus.signedOut;
      _notify();
    }
  }

  static String friendlyMessage(Object failure) {
    if (failure is ClientAuthException) {
      if ({
        'invalid-credential',
        'invalid-login-credentials',
        'user-not-found',
        'wrong-password',
      }.contains(failure.code)) {
        return 'Invalid email or password';
      }
      if (failure.code == 'user-disabled') {
        return 'This account has been disabled';
      }
      if (failure.code == 'too-many-requests') {
        return 'Too many login attempts. Please wait and try again';
      }
      if (failure.code == 'network-request-failed') {
        return 'Network unavailable. Check your connection and try again';
      }
      if (failure.code == 'email-already-in-use') {
        return 'An account already exists for this email';
      }
      if (failure.code == 'weak-password') {
        return 'Use a stronger password';
      }
    }
    if (failure is ApiException) {
      if (failure.code == 'email_already_in_use' ||
          failure.code == 'conflict') {
        return 'An account already exists for this email';
      }
      if (failure.statusCode == 403) {
        return "Your account isn't active — contact your admin.";
      }
      if (failure.code == 'network_error') {
        return 'Network unavailable. Check your connection and try again';
      }
    }
    return 'Unable to sign in. Please try again';
  }

  static String friendlyPasswordResetMessage(Object failure) {
    if (failure is ClientAuthException) {
      if (failure.code == 'too-many-requests') {
        return 'Too many reset attempts. Please wait and try again';
      }
      if (failure.code == 'network-request-failed') {
        return 'Network unavailable. Check your connection and try again';
      }
    }
    return 'Unable to send the reset link. Please try again';
  }

  void _fail(Object failure, {String? fallback}) {
    var message = friendlyMessage(failure);
    if (fallback != null && message == 'Unable to sign in. Please try again') {
      message = fallback;
    }
    _currentUser = null;
    _error = message;
    _status = AuthStatus.signedOut;
    _feedback(message);
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}

class AuthProvider extends InheritedNotifier<AuthController> {
  const AuthProvider({
    required AuthController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(provider != null, 'AuthProvider is required');
    return provider!.notifier!;
  }
}
