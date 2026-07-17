import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

typedef AdapterHandler = Future<ResponseBody> Function(RequestOptions options);

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.handler);

  final AdapterHandler handler;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastRequest = options;
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

class _Feedback implements ApiFeedback {
  final errors = <String>[];

  @override
  void error(String message) => errors.add(message);
}

ResponseBody _jsonBody(Object body, int statusCode) => ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  test(
    'injects token and returns typed /me through generated Dart client',
    () async {
      final adapter = _StubAdapter(
        (_) async => _jsonBody({
          'uid': 'firebase-uid',
          'email': 'operator@example.invalid',
          'company_id': 'acme-energy',
          'role_key': 'operations_manager',
          'email_verified': true,
          'permissions': ['assets.read', 'assets.write'],
        }, 200),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final api = ApiService(
        baseUrl: 'http://api.test',
        dio: dio,
        getIdToken: () async => 'real-id-token',
      );

      final identity = await api.getCurrentUser();

      expect(identity.uid, 'firebase-uid');
      expect(identity.companyId, 'acme-energy');
      expect(identity.permissions, contains('assets.write'));
      expect(
        adapter.lastRequest?.headers['Authorization'],
        'Bearer real-id-token',
      );
    },
  );

  test('maps envelope, reports toast feedback, and runs 401 hook', () async {
    final feedback = _Feedback();
    var unauthorizedCalls = 0;
    final adapter = _StubAdapter(
      (_) async => _jsonBody({
        'error': 'token_expired',
        'message': 'Token has expired',
        'request_id': 'bd7deca2-45d0-40ff-81db-758b22c90eaa',
      }, 401),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final api = ApiService(
      baseUrl: 'http://api.test',
      dio: dio,
      feedback: feedback,
      onUnauthorized: () async => unauthorizedCalls += 1,
    );

    await expectLater(
      api.getCurrentUser(),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'token_expired')
            .having((error) => error.statusCode, 'status', 401)
            .having(
              (error) => error.requestId,
              'requestId',
              'bd7deca2-45d0-40ff-81db-758b22c90eaa',
            ),
      ),
    );
    expect(feedback.errors, ['Token has expired']);
    expect(unauthorizedCalls, 1);
  });

  test('network failure becomes a typed graceful error and feedback', () async {
    final feedback = _Feedback();
    final adapter = _StubAdapter(
      (options) async => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final api = ApiService(
      baseUrl: 'http://api.test',
      dio: dio,
      feedback: feedback,
    );

    await expectLater(
      api.getHealth(),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'network_error')
            .having(
              (error) => error.message,
              'message',
              'Unable to reach the API',
            ),
      ),
    );
    expect(feedback.errors, ['Unable to reach the API']);
  });

  test('registers a company admin through the generated client', () async {
    final adapter = _StubAdapter(
      (_) async => _jsonBody({
        'uid': 'firebase-uid',
        'email': 'admin@northstar.example',
        'email_verified': false,
        'company_id': 'cmp_generated',
        'role_key': 'company_admin',
      }, 201),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final api = ApiService(baseUrl: 'http://api.test', dio: dio);

    final result = await api.registerCompanyAdmin(
      companyName: 'Northstar Energy',
      displayName: 'First Admin',
      email: 'admin@northstar.example',
      password: 'StrongPass1',
    );

    expect(result.companyId, 'cmp_generated');
    expect(result.roleKey, 'company_admin');
    expect(adapter.lastRequest?.path, '/api/v1/auth/register');
    expect(adapter.lastRequest?.data,
        containsPair('company_name', 'Northstar Energy'));
  });
}
