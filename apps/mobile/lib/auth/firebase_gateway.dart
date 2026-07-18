import 'package:firebase_auth/firebase_auth.dart';

const _authActionUrl = String.fromEnvironment('AUTH_ACTION_URL');

class ClientAuthException implements Exception {
  const ClientAuthException(this.code, this.message);

  final String code;
  final String message;
}

class AuthSession {
  const AuthSession({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  final String uid;
  final String? email;
  final bool emailVerified;
}

abstract interface class AuthGateway {
  Stream<AuthSession?> authStateChanges();
  Future<String?> getIdToken();
  Future<AuthSession> refreshSession();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);
  Future<AuthSession> signIn(String email, String password);
  Future<void> signOut();
}

class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static AuthSession _session(User user) => AuthSession(
        uid: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
      );

  @override
  Stream<AuthSession?> authStateChanges() => _auth.authStateChanges().map(
        (user) => user == null ? null : _session(user),
      );

  @override
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    return user == null ? null : await user.getIdToken();
  }

  @override
  Future<AuthSession> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const ClientAuthException(
          'client-error',
          'Firebase returned no authenticated user',
        );
      }
      return _session(user);
    } on FirebaseAuthException catch (error) {
      throw ClientAuthException(
        error.code,
        error.message ?? 'Authentication failed',
      );
    }
  }

  @override
  Future<AuthSession> refreshSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ClientAuthException(
        'no-current-user',
        'No authenticated user is available',
      );
    }
    try {
      await user.reload();
      final refreshed = _auth.currentUser;
      if (refreshed == null) {
        throw const ClientAuthException(
          'no-current-user',
          'No authenticated user is available',
        );
      }
      await refreshed.getIdToken(true);
      return _session(refreshed);
    } on FirebaseAuthException catch (error) {
      throw ClientAuthException(
        error.code,
        error.message ?? 'Unable to refresh the session',
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ClientAuthException(
        'no-current-user',
        'No authenticated user is available',
      );
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      throw ClientAuthException(
        error.code,
        error.message ?? 'Unable to send the verification email',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: _authActionUrl.isEmpty
            ? null
            : ActionCodeSettings(
                url: _authActionUrl,
                handleCodeInApp: false,
              ),
      );
    } on FirebaseAuthException catch (error) {
      throw ClientAuthException(
        error.code,
        error.message ?? 'Unable to send the reset email',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw ClientAuthException(error.code, error.message ?? 'Sign out failed');
    }
  }
}
