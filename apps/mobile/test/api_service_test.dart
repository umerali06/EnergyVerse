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
          'company_name': 'Acme Energy',
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

  test('maps the envelope and runs the 401 hook without generic feedback',
      () async {
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
    // Session-expired messaging belongs to the onUnauthorized hook.
    expect(feedback.errors, isEmpty);
    expect(unauthorizedCalls, 1);
  });

  test('retries a 401 once with a force-refreshed token and succeeds',
      () async {
    var refreshCalls = 0;
    var unauthorizedCalls = 0;
    var requests = 0;
    final adapter = _StubAdapter((options) async {
      requests += 1;
      if (requests == 1) {
        return _jsonBody({
          'error': 'token_expired',
          'message': 'Token has expired',
          'request_id': '11111111-45d0-40ff-81db-758b22c90eaa',
        }, 401);
      }
      expect(options.headers['Authorization'], 'Bearer fresh-token');
      return _jsonBody({
        'uid': 'firebase-uid',
        'email': 'operator@example.invalid',
        'company_id': 'acme-energy',
        'company_name': 'Acme Energy',
        'role_key': 'operations_manager',
        'email_verified': true,
        'permissions': ['assets.read', 'assets.write'],
      }, 200);
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final api = ApiService(
      baseUrl: 'http://api.test',
      dio: dio,
      getIdToken: () async => refreshCalls == 0 ? 'stale-token' : 'fresh-token',
      refreshIdToken: () async {
        refreshCalls += 1;
        return 'fresh-token';
      },
      onUnauthorized: () async => unauthorizedCalls += 1,
    );

    final identity = await api.getCurrentUser();

    expect(identity.uid, 'firebase-uid');
    expect(refreshCalls, 1);
    expect(requests, 2);
    expect(unauthorizedCalls, 0);
  });

  test('expires the session once when the refreshed retry still returns 401',
      () async {
    final feedback = _Feedback();
    var refreshCalls = 0;
    var unauthorizedCalls = 0;
    var requests = 0;
    final adapter = _StubAdapter((_) async {
      requests += 1;
      return _jsonBody({
        'error': 'token_revoked',
        'message': 'Token has been revoked',
        'request_id': '22222222-45d0-40ff-81db-758b22c90eaa',
      }, 401);
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final api = ApiService(
      baseUrl: 'http://api.test',
      dio: dio,
      feedback: feedback,
      refreshIdToken: () async {
        refreshCalls += 1;
        return 'fresh-token';
      },
      onUnauthorized: () async => unauthorizedCalls += 1,
    );

    await expectLater(
      api.getCurrentUser(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
    );
    expect(refreshCalls, 1);
    expect(requests, 2);
    expect(unauthorizedCalls, 1);
    expect(feedback.errors, isEmpty);
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
