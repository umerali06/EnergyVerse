import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

class _PendingApi implements ApiContract {
  final _health = Completer<HealthResponse>();
  final _identity = Completer<CurrentUser>();

  @override
  Future<CurrentUser> getCurrentUser() => _identity.future;

  @override
  Future<HealthResponse> getHealth() => _health.future;
}

void main() {
  testWidgets('renders the connection indicator', (WidgetTester tester) async {
    await tester.pumpWidget(FevApp(api: _PendingApi()));

    expect(find.text('API: checking · Firestore: checking'), findsOneWidget);
  });
}
