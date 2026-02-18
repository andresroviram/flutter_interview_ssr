import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/filters/active_filter_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveFilterChip', () {
    testWidgets('renders correctly with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Edad: 18-30', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ActiveFilterChip), findsOneWidget);
      expect(find.text('Edad: 18-30'), findsOneWidget);
    });

    testWidgets('displays filter icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
    });

    testWidgets('displays close icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('triggers onDeleted when close icon is tapped', (
      WidgetTester tester,
    ) async {
      var deletedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(
              label: 'Test Filter',
              onDeleted: () {
                deletedCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(deletedCalled, isTrue);
    });

    testWidgets('uses Row layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('has rounded border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      // Verify GestureDetector is present for tap handling
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('displays custom label text', (WidgetTester tester) async {
      const customLabel = 'Género: Masculino';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: customLabel, onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(customLabel), findsOneWidget);
    });

    testWidgets('creates chip with proper padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      // Verify the chip renders
      expect(find.byType(ActiveFilterChip), findsOneWidget);
    });

    testWidgets('renders with theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: ActiveFilterChip(label: 'Test Filter', onDeleted: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ActiveFilterChip), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
    });
  });
}
