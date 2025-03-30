import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:resume_builder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('should navigate through the complete auth flow', (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the splash screen
      expect(find.text('Resume Builder'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Test invalid login
      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid@email.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'wrongpassword',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);

      // Navigate to signup
      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      // Verify we're on the signup screen
      expect(find.text('Create Account'), findsOneWidget);

      // Test signup
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify we're on the home screen after successful signup
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should handle theme switching', (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify initial theme (light)
      expect(
        tester.widget<Container>(find.byType(Container)).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          equals(ThemeData.light().scaffoldBackgroundColor),
        ),
      );

      // Switch to dark theme
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      // Verify dark theme
      expect(
        tester.widget<Container>(find.byType(Container)).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          equals(ThemeData.dark().scaffoldBackgroundColor),
        ),
      );
    });
  });
}
