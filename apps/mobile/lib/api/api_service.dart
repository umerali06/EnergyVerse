import 'package:dio/dio.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';

import '../config.dart';

typedef TokenProvider = Future<String?> Function();
typedef UnauthorizedHook = Future<void> Function();

abstract interface class ApiFeedback {
  void error(String message);
}

class NoopApiFeedback implements ApiFeedback {
  const NoopApiFeedback();

  @override
  void error(String message) {}
}

class CallbackApiFeedback implements ApiFeedback {
  const CallbackApiFeedback(this.onError);

  final void Function(String message) onError;

  @override
  void error(String message) => onError(message);
}

class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
    this.requestId,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;
  final String? requestId;

  @override
  String toString() => 'ApiException($code, requestId: $requestId)';
}

abstract interface class ApiContract {
  Future<HealthResponse> getHealth();
  Future<CurrentUser> getCurrentUser();
  Future<CompanyRegistrationResponse> registerCompanyAdmin({
    required String companyName,
    required String displayName,
    required String email,
    required String password,
  });
  Future<DashboardSummary> getDashboardSummary({int window = 30});
  Future<DashboardActivityPage> getDashboardActivity({
    int limit = 20,
    String? cursor,
    String? action,
  });
  Future<DashboardActivitySeries> getDashboardActivitySeries({int window = 30});
}

class ApiService implements ApiContract {
  ApiService({
    String baseUrl = apiBaseUrl,
    Dio? dio,
    TokenProvider? getIdToken,
    TokenProvider? refreshIdToken,
    UnauthorizedHook? onUnauthorized,
    ApiFeedback feedback = const NoopApiFeedback(),
  })  : _feedback = feedback,
        _onUnauthorized = onUnauthorized ?? _noopUnauthorized {
    final configuredDio = dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl.replaceFirst(RegExp(r'/$'), ''),
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );
    configuredDio.options.baseUrl = baseUrl.replaceFirst(RegExp(r'/$'), '');
    configuredDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await (getIdToken ?? _noToken)();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // A 401 may just mean the cached token expired: force one refresh
          // and retry once before treating the session as dead.
          final alreadyRetried =
              error.requestOptions.extra[_retriedFlag] == true;
          if (error.response?.statusCode == 401 &&
              !alreadyRetried &&
              refreshIdToken != null) {
            try {
              final token = await refreshIdToken();
              if (token != null && token.isNotEmpty) {
                final retried = error.requestOptions
                  ..extra[_retriedFlag] = true
                  ..headers['Authorization'] = 'Bearer $token';
                final response = await configuredDio.fetch<dynamic>(retried);
                return handler.resolve(response);
              }
            } on DioException catch (retryFailure) {
              final retryTyped = _fromDio(retryFailure);
              if (retryTyped.statusCode != 401) {
                // The refreshed retry failed for a non-auth reason; surface it
                // instead of expiring the session.
                return handler.reject(
                  retryFailure.copyWith(error: retryTyped),
                );
              }
              // Still 401 after a fresh token: the session is dead.
            } catch (_) {
              // Refresh itself failed; fall through to unauthorized handling.
            }
          }
          final typed = _fromDio(error);
          // 401s stay quiet here: the onUnauthorized hook owns session-expired
          // messaging.
          if (typed.code != 'request_cancelled' && typed.statusCode != 401) {
            _feedback.error(typed.message);
          }
          if (typed.statusCode == 401 && !alreadyRetried) {
            await _onUnauthorized();
          }
          if (kDebugMode && typed.requestId != null) {
            debugPrint('FEV API error request_id=${typed.requestId}');
          }
          handler.reject(error.copyWith(error: typed));
        },
      ),
    );
    _client = FevApiClient(dio: configuredDio, interceptors: const []);
  }

  static const _retriedFlag = 'fev_auth_retried';

  late final FevApiClient _client;
  final ApiFeedback _feedback;
  final UnauthorizedHook _onUnauthorized;

  static Future<String?> _noToken() async => null;
  static Future<void> _noopUnauthorized() async {}

  @override
  Future<HealthResponse> getHealth() async {
    try {
      final response = await _client.getSystemApi().getHealth();
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty health response',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<CurrentUser> getCurrentUser() async {
    try {
      final response = await _client.getAuthApi().getCurrentUser();
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty identity response',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<CompanyRegistrationResponse> registerCompanyAdmin({
    required String companyName,
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final request = CompanyRegistrationRequest(
        (builder) => builder
          ..companyName = companyName
          ..displayName = displayName
          ..email = email
          ..password = password,
      );
      final response = await _client.getAuthApi().registerCompanyAdmin(
            companyRegistrationRequest: request,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty registration response',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<DashboardSummary> getDashboardSummary({int window = 30}) async {
    try {
      final response = await _client.getDashboardApi().getDashboardSummary(window: window);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty dashboard summary',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<DashboardActivityPage> getDashboardActivity({
    int limit = 20,
    String? cursor,
    String? action,
  }) async {
    try {
      final response = await _client.getDashboardApi().getDashboardActivity(
            limit: limit,
            cursor: cursor,
            action: action,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty activity page',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<DashboardActivitySeries> getDashboardActivitySeries({int window = 30}) async {
    try {
      final response =
          await _client.getDashboardApi().getDashboardActivitySeries(window: window);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty activity series',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  ApiException _typedError(DioException error) {
    final nested = error.error;
    return nested is ApiException ? nested : _fromDio(error);
  }

  static ApiException _fromDio(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const ApiException(
        code: 'request_cancelled',
        message: 'Request was cancelled',
      );
    }
    final response = error.response;
    final data = response?.data;
    if (data is Map<String, dynamic> &&
        data['error'] is String &&
        data['message'] is String &&
        data['request_id'] is String) {
      final rawDetails = data['details'];
      return ApiException(
        code: data['error'] as String,
        message: data['message'] as String,
        statusCode: response?.statusCode,
        details: rawDetails is Map<String, dynamic> ? rawDetails : null,
        requestId: data['request_id'] as String,
      );
    }
    if (response != null) {
      return ApiException(
        code: 'http_error',
        message: 'API request failed with HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
    return const ApiException(
      code: 'network_error',
      message: 'Unable to reach the API',
    );
  }
}
