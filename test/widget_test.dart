import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resturent_billinng_app/app/app.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Onboarding completes after OTP, language, category, and setup', (
    WidgetTester tester,
  ) async {
    configureDependencies();

    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Send OTP'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).last, '9876543210');
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('send_otp_button')).last);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Verify OTP'), findsWidgets);

    await tester.enterText(find.byType(EditableText).last, '123456');
    await tester.pump();

    await tester.tap(find.text('Verify OTP').last);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('What language do you speak?'), findsOneWidget);
    await tester.tap(find.text('Next').last);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('What do you run?'), findsOneWidget);
    await tester.tap(find.text('Cafe'));
    await tester.pump();
    await tester.tap(find.text('Next').last);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Create your business'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Restaurant or cafe name'),
      'Cafe Test',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Owner full name'),
      'Test Owner',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter phone number').last,
      '9876543210',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Shop number, street, area, city'),
      '12 Main Road',
    );
    await tester.ensureVisible(
      find.widgetWithText(TextFormField, '6 digit pincode'),
    );
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextFormField, '6 digit pincode'),
      '400001',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('finish_setup_button')).last,
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('finish_setup_button')).last);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Home', skipOffstage: false), findsOneWidget);
    expect(find.text('Menu', skipOffstage: false), findsOneWidget);
    expect(find.text('Orders', skipOffstage: false), findsWidgets);
    expect(find.text('Reports', skipOffstage: false), findsOneWidget);
  });
}
