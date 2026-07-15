import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the FEV scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const FevApp());

    expect(find.text('FEV Field App — scaffold OK'), findsOneWidget);
  });
}
