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
  Future<UserListPage> getUsers({
    String? search,
    String? roleId,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  });
  Future<UserDetail> getUser(String userId);
  Future<RoleList> getRoles();
  Future<RoleDetail> getRole(String roleId);
  Future<CompanyProfile> getCompanyProfile();
  Future<AuditLogPage> getAuditLogs({
    DateTime? fromDate,
    DateTime? toDate,
    String? actorUid,
    String? action,
    String? targetType,
    String? q,
    String? cursor,
    int limit = 20,
  });
  Future<AuditLogFacets> getAuditLogFacets({DateTime? fromDate, DateTime? toDate});
  Future<AssetListPage> getAssets({
    String? facilityId,
    String? areaId,
    String? category,
    String? currentStatus,
    String? parentAssetId,
    String? search,
    String sort = '-created_at',
    String? cursor,
    int limit = 25,
  });
  Future<AssetDetail> getAsset(String assetId);
  Future<AssetHistoryPage> getAssetHistory(String assetId);
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  });
  Future<FacilityDetail> getFacility(String facilityId);
  Future<AreaListPage> getAreas({
    String? facilityId,
    String? search,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  });
  Future<AreaDetail> getArea(String areaId);
}

extension AssetWriteContract on ApiContract {
  ApiService get _assetWriter {
    final service = this;
    if (service is ApiService) return service;
    throw UnsupportedError('Asset writes are not available on this API test double');
  }

  Future<AssetDetail> createAsset(CreateAssetRequest request) =>
      _assetWriter.createAsset(request);
  Future<AssetDetail> updateAsset(String assetId, UpdateAssetRequest request) =>
      _assetWriter.updateAsset(assetId, request);
  Future<AssetDetail> uploadAssetMedia({
    required String assetId,
    required String kind,
    required String path,
    required String filename,
    void Function(int sent, int total)? onProgress,
  }) =>
      _assetWriter.uploadAssetMedia(
        assetId: assetId,
        kind: kind,
        path: path,
        filename: filename,
        onProgress: onProgress,
      );
  Future<AssetDetail> deleteAssetMedia(String assetId, String mediaId) =>
      _assetWriter.deleteAssetMedia(assetId, mediaId);
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

  @override
  Future<UserListPage> getUsers({
    String? search,
    String? roleId,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async {
    try {
      final response = await _client.getUsersApi().listUsers(
            search: search,
            roleId: roleId,
            status: status,
            sort: sort,
            cursor: cursor,
            limit: limit,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty user list',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<UserDetail> getUser(String userId) async {
    try {
      final response = await _client.getUsersApi().getUser(userId: userId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty user detail',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<RoleList> getRoles() async {
    try {
      final response = await _client.getRolesApi().listRoles();
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty role list',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<RoleDetail> getRole(String roleId) async {
    try {
      final response = await _client.getRolesApi().getRole(roleId: roleId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty role detail',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AuditLogPage> getAuditLogs({
    DateTime? fromDate,
    DateTime? toDate,
    String? actorUid,
    String? action,
    String? targetType,
    String? q,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _client.getAuditApi().listAuditLogs(
            fromDate: fromDate?.toDate(),
            toDate: toDate?.toDate(),
            actorUid: actorUid,
            action: action,
            targetType: targetType,
            q: q,
            cursor: cursor,
            limit: limit,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty audit log page',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AuditLogFacets> getAuditLogFacets({DateTime? fromDate, DateTime? toDate}) async {
    try {
      final response = await _client.getAuditApi().getAuditLogFacets(
            fromDate: fromDate?.toDate(),
            toDate: toDate?.toDate(),
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty audit facets response',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AssetListPage> getAssets({
    String? facilityId,
    String? areaId,
    String? category,
    String? currentStatus,
    String? parentAssetId,
    String? search,
    String sort = '-created_at',
    String? cursor,
    int limit = 25,
  }) async {
    try {
      final response = await _client.getAssetsApi().listAssets(
            facilityId: facilityId,
            areaId: areaId,
            category: category,
            currentStatus: currentStatus,
            parentAssetId: parentAssetId,
            search: search,
            sort: sort,
            cursor: cursor,
            limit: limit,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty asset list',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AssetDetail> getAsset(String assetId) async {
    try {
      final response = await _client.getAssetsApi().getAsset(assetId: assetId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty asset detail',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AssetHistoryPage> getAssetHistory(String assetId) async {
    try {
      final response = await _client.getAssetsApi().getAssetHistory(assetId: assetId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty asset history page',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  Future<AssetDetail> createAsset(CreateAssetRequest request) async {
    try {
      final response = await _client.getAssetsApi().createAsset(
            createAssetRequest: request,
          );
      return _requireAsset(response.data);
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  Future<AssetDetail> updateAsset(String assetId, UpdateAssetRequest request) async {
    try {
      final response = await _client.getAssetsApi().updateAsset(
            assetId: assetId,
            updateAssetRequest: request,
          );
      return _requireAsset(response.data);
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  Future<AssetDetail> uploadAssetMedia({
    required String assetId,
    required String kind,
    required String path,
    required String filename,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final response = await _client.getAssetsApi().uploadAssetMedia(
            assetId: assetId,
            kind: kind,
            file: await MultipartFile.fromFile(path, filename: filename),
            onSendProgress: onProgress,
          );
      return _requireAsset(response.data);
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  Future<AssetDetail> deleteAssetMedia(String assetId, String mediaId) async {
    try {
      final response = await _client.getAssetsApi().deleteAssetMedia(
            assetId: assetId,
            mediaId: mediaId,
          );
      return _requireAsset(response.data);
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  AssetDetail _requireAsset(AssetDetail? value) {
    if (value == null) {
      throw const ApiException(
        code: 'invalid_response',
        message: 'The API returned an empty asset detail',
      );
    }
    return value;
  }

  @override
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async {
    try {
      final response = await _client.getFacilitiesApi().listFacilities(
            search: search,
            status: status,
            sort: sort,
            cursor: cursor,
            limit: limit,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty facility list',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<FacilityDetail> getFacility(String facilityId) async {
    try {
      final response = await _client.getFacilitiesApi().getFacility(facilityId: facilityId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty facility detail',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AreaListPage> getAreas({
    String? facilityId,
    String? search,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async {
    try {
      final response = await _client.getAreasApi().listAreas(
            facilityId: facilityId,
            search: search,
            sort: sort,
            cursor: cursor,
            limit: limit,
          );
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty area list',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<AreaDetail> getArea(String areaId) async {
    try {
      final response = await _client.getAreasApi().getArea(areaId: areaId);
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty area detail',
        );
      }
      return value;
    } on DioException catch (error) {
      throw _typedError(error);
    }
  }

  @override
  Future<CompanyProfile> getCompanyProfile() async {
    try {
      final response = await _client.getCompanyApi().getCompany();
      final value = response.data;
      if (value == null) {
        throw const ApiException(
          code: 'invalid_response',
          message: 'The API returned an empty company profile',
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
