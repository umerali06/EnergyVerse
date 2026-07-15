import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the connection indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const FevApp());

    expect(find.text('API: checking · Firestore: checking'), findsOneWidget);
  });
}
