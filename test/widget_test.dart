import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resturent_billinng_app/app/app.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';

void main() {
  testWidgets('Login routes to main shell after phone entry', (
    WidgetTester tester,
  ) async {
    configureDependencies();

    await tester.pumpWidget(const MyApp());

    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Restaurant Billing'), findsNothing);

    await tester.enterText(find.byType(EditableText).last, '9876543210');
    await tester.pump();

    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Restaurant Billing'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });
}
