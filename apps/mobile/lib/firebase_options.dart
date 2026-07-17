import 'package:firebase_core/firebase_core.dart';

const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
const firebaseAuthDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
const firebaseStorageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
const firebaseMessagingSenderId =
    String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');

FirebaseOptions get firebaseClientOptions {
  final values = {
    'FIREBASE_API_KEY': firebaseApiKey,
    'FIREBASE_AUTH_DOMAIN': firebaseAuthDomain,
    'FIREBASE_PROJECT_ID': firebaseProjectId,
    'FIREBASE_STORAGE_BUCKET': firebaseStorageBucket,
    'FIREBASE_MESSAGING_SENDER_ID': firebaseMessagingSenderId,
    'FIREBASE_APP_ID': firebaseAppId,
  };
  final missing = values.entries
      .where((entry) => entry.value.isEmpty)
      .map((entry) => entry.key)
      .join(', ');
  if (missing.isNotEmpty) {
    throw StateError('Firebase client configuration is missing: $missing');
  }
  return const FirebaseOptions(
    apiKey: firebaseApiKey,
    authDomain: firebaseAuthDomain,
    projectId: firebaseProjectId,
    storageBucket: firebaseStorageBucket,
    messagingSenderId: firebaseMessagingSenderId,
    appId: firebaseAppId,
  );
}
