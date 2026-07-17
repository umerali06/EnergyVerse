import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import 'firebase_gateway.dart';

enum AuthStatus { restoring, signedOut, signingIn, authenticated }

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

  AuthStatus _status = AuthStatus.restoring;
  CurrentUser? _currentUser;
  String? _error;

  AuthStatus get status => _status;
  CurrentUser? get currentUser => _currentUser;
  String? get error => _error;

  void start() {
    _subscription ??= _gateway.authStateChanges().listen(
      (session) {
        if (session == null) {
          _currentUser = null;
          if (_status != AuthStatus.signingIn) _status = AuthStatus.signedOut;
          _notify();
        } else {
          unawaited(_resolveSession(session));
        }
      },
      onError: _fail,
    );
  }

  Future<void> signIn(String email, String password) async {
    if (_status == AuthStatus.signingIn) return;
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
        _status = AuthStatus.authenticated;
        _notify();
      } catch (failure) {
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
    }
    if (failure is ApiException) {
      if (failure.statusCode == 403) {
        return "Your account isn't active — contact your admin.";
      }
      if (failure.code == 'network_error') {
        return 'Network unavailable. Check your connection and try again';
      }
    }
    return 'Unable to sign in. Please try again';
  }

  void _fail(Object failure) {
    final message = friendlyMessage(failure);
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
