import 'package:flutter_test/flutter_test.dart';
import 'package:dms_mobile/main.dart';

void main() {
  testWidgets('DMS Login Screen loads successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DmsApp());

    expect(find.text('DMS Mobile'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
