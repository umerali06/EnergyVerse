//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_value/json_object.dart';
import 'package:fev_api_client/src/api_util.dart';
import 'package:fev_api_client/src/model/audit_log_facets.dart';
import 'package:fev_api_client/src/model/audit_log_page.dart';
import 'package:fev_api_client/src/model/date.dart';
import 'package:fev_api_client/src/model/error_envelope.dart';

class AuditApi {
  final Dio _dio;

  final Serializers _serializers;

  const AuditApi(this._dio, this._serializers);

  /// Export Audit Logs
  ///
  ///
  /// Parameters:
  /// * [fromDate]
  /// * [toDate]
  /// * [actorUid]
  /// * [action]
  /// * [targetType]
  /// * [q]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [JsonObject] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<JsonObject>> exportAuditLogs({
    Date? fromDate,
    Date? toDate,
    String? actorUid,
    String? action,
    String? targetType,
    String? q,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/audit-logs/export';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'HTTPBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'from_date':
          encodeQueryParameter(_serializers, fromDate, const FullType(Date)),
      r'to_date':
          encodeQueryParameter(_serializers, toDate, const FullType(Date)),
      r'actor_uid':
          encodeQueryParameter(_serializers, actorUid, const FullType(String)),
      r'action':
          encodeQueryParameter(_serializers, action, const FullType(String)),
      r'target_type': encodeQueryParameter(
          _serializers, targetType, const FullType(String)),
      r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    JsonObject? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(JsonObject),
            ) as JsonObject;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<JsonObject>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Get Audit Log Facets
  ///
  ///
  /// Parameters:
  /// * [fromDate]
  /// * [toDate]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AuditLogFacets] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AuditLogFacets>> getAuditLogFacets({
    Date? fromDate,
    Date? toDate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/audit-logs/actions';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'HTTPBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'from_date':
          encodeQueryParameter(_serializers, fromDate, const FullType(Date)),
      r'to_date':
          encodeQueryParameter(_serializers, toDate, const FullType(Date)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AuditLogFacets? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(AuditLogFacets),
            ) as AuditLogFacets;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AuditLogFacets>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// List Audit Logs
  ///
  ///
  /// Parameters:
  /// * [fromDate]
  /// * [toDate]
  /// * [actorUid]
  /// * [action]
  /// * [targetType]
  /// * [q]
  /// * [cursor]
  /// * [limit]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AuditLogPage] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AuditLogPage>> listAuditLogs({
    Date? fromDate,
    Date? toDate,
    String? actorUid,
    String? action,
    String? targetType,
    String? q,
    String? cursor,
    int? limit = 20,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/audit-logs';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'HTTPBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'from_date':
          encodeQueryParameter(_serializers, fromDate, const FullType(Date)),
      r'to_date':
          encodeQueryParameter(_serializers, toDate, const FullType(Date)),
      r'actor_uid':
          encodeQueryParameter(_serializers, actorUid, const FullType(String)),
      r'action':
          encodeQueryParameter(_serializers, action, const FullType(String)),
      r'target_type': encodeQueryParameter(
          _serializers, targetType, const FullType(String)),
      r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      r'cursor':
          encodeQueryParameter(_serializers, cursor, const FullType(String)),
      if (limit != null)
        r'limit':
            encodeQueryParameter(_serializers, limit, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AuditLogPage? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(AuditLogPage),
            ) as AuditLogPage;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AuditLogPage>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
