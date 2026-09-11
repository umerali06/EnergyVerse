import 'package:firebase_core/firebase_core.dart';

const firebaseApiKey = String.fromEnvironment(
  'FIREBASE_API_KEY',
  defaultValue: 'AIzaSyAU6bVpt590C_eEoZ__x_YbhQTByhGKQN0',
);
const firebaseAuthDomain = String.fromEnvironment(
  'FIREBASE_AUTH_DOMAIN',
  defaultValue: 'thinking-case-469504-c0.firebaseapp.com',
);
const firebaseProjectId = String.fromEnvironment(
  'FIREBASE_PROJECT_ID',
  defaultValue: 'thinking-case-469504-c0',
);
const firebaseStorageBucket = String.fromEnvironment(
  'FIREBASE_STORAGE_BUCKET',
  defaultValue: 'thinking-case-469504-c0.firebasestorage.app',
);
const firebaseMessagingSenderId = String.fromEnvironment(
  'FIREBASE_MESSAGING_SENDER_ID',
  defaultValue: '236253954361',
);
const firebaseAppId = String.fromEnvironment(
  'FIREBASE_APP_ID',
  defaultValue: '1:236253954361:web:44b9ba1d4fb7148ba968e8',
);

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
