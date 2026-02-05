import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_interview_ssr/features/users/presentation/widgets/search_bar_widget.dart';

void main() {
  group('SearchBarWidget Tests', () {
    Widget createTestWidget({
      required String hintText,
      required Function(String) onChanged,
      int debounceDuration = 500,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              hintText: hintText,
              onChanged: onChanged,
              debounceDuration: debounceDuration,
            ),
          ),
        ),
      );
    }

    testWidgets('should render with hint text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar usuarios', onChanged: (_) {}),
      );

      expect(find.text('Buscar usuarios'), findsOneWidget);
    });

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should not show clear icon when text is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should show clear icon when text is entered', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onChanged with debounce when text is entered', (
      tester,
    ) async {
      String? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValue = value,
          debounceDuration: 300,
        ),
      );

      await tester.enterText(find.byType(TextField), 'flutter');

      // Don't wait, check immediately - should not have called yet
      expect(capturedValue, isNull);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 350));

      expect(capturedValue, 'flutter');
    });

    testWidgets('should debounce multiple rapid inputs', (tester) async {
      final capturedValues = <String>[];

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValues.add(value),
          debounceDuration: 300,
        ),
      );

      // Rapid inputs
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextField), 'abc');

      // Before debounce completes, should have no calls
      expect(capturedValues, isEmpty);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 350));

      // Only the last value should be captured
      expect(capturedValues, hasLength(1));
      expect(capturedValues.last, 'abc');
    });

    testWidgets('should call onChanged immediately when clear is tapped', (
      tester,
    ) async {
      String? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValue = value,
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      capturedValue = null; // Reset

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Should call immediately without debounce
      expect(capturedValue, '');
    });

    testWidgets('should accept text input', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      await tester.enterText(find.byType(TextField), 'Flutter Test');
      await tester.pump();

      expect(find.text('Flutter Test'), findsOneWidget);
    });

    testWidgets('should use custom debounce duration', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValue = value,
          debounceDuration: 100,
        ),
      );

      await tester.enterText(find.byType(TextField), 'fast');

      // Wait less time due to shorter debounce
      await tester.pump(const Duration(milliseconds: 120));

      expect(capturedValue, 'fast');
    });

    testWidgets('should maintain state across rebuilds', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      await tester.enterText(find.byType(TextField), 'persistent');
      await tester.pump();

      // Rebuild
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      expect(find.text('persistent'), findsOneWidget);
    });

    testWidgets('should dispose debouncer properly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(hintText: 'Buscar', onChanged: (_) {}),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Remove widget from tree
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Should not throw error after disposal
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle special characters', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValue = value,
          debounceDuration: 200,
        ),
      );

      await tester.enterText(find.byType(TextField), '@#\$%&*');
      await tester.pump(const Duration(milliseconds: 250));

      expect(capturedValue, '@#\$%&*');
    });

    testWidgets('should handle unicode characters', (tester) async {
      String? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          hintText: 'Buscar',
          onChanged: (value) => capturedValue = value,
          debounceDuration: 200,
        ),
      );

      await tester.enterText(find.byType(TextField), 'José García');
      await tester.pump(const Duration(milliseconds: 250));

      expect(capturedValue, 'José García');
    });
  });
}
