import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';

enum QrScanState { idle, resolving, success, notFound, error }

/// The backend encodes a deep-link URL (`{APP_BASE_URL}/qr/{code}`) as the QR
/// payload, but manual entry may just be the raw opaque code -- either way
/// the code is the last non-empty path segment.
String extractQrCode(String raw) {
  final trimmed = raw.trim();
  final segments = trimmed.split('/').where((segment) => segment.isNotEmpty).toList();
  return segments.isEmpty ? trimmed : segments.last;
}

class QrScanController extends ChangeNotifier {
  QrScanController({required ApiContract api}) : _api = api;

  final ApiContract _api;

  QrScanState state = QrScanState.idle;
  QrScanResult? result;
  String? errorMessage;

  Future<void> resolve(String rawCode) async {
    final code = extractQrCode(rawCode);
    if (code.isEmpty || state == QrScanState.resolving) return;
    state = QrScanState.resolving;
    errorMessage = null;
    notifyListeners();
    try {
      result = await _api.resolveQrCode(code);
      state = QrScanState.success;
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        state = QrScanState.notFound;
      } else {
        state = QrScanState.error;
        errorMessage = error.code == 'network_error'
            ? "Couldn't reach the network. Check your connection and try again."
            : "Couldn't resolve this code. Check your connection and try again.";
      }
    }
    notifyListeners();
  }

  /// Called after navigating away from a successful resolve, so scanning
  /// again starts from a clean slate rather than re-showing the last result.
  void reset() {
    state = QrScanState.idle;
    result = null;
    errorMessage = null;
    notifyListeners();
  }
}
