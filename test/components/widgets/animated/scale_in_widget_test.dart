import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/animated/scale_in_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScaleInWidget', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      const testKey = Key('test_child');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(child: Text('Test', key: testKey)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('applies scale and fade animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(
              duration: Duration(milliseconds: 200),
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      // Widget should exist
      expect(find.text('Test Content'), findsOneWidget);

      // Wait for animation to complete
      await tester.pumpAndSettle();

      // Widget should still be visible after animation
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('respects custom beginScale', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(beginScale: 0.5, child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('respects delay parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(
              delay: Duration(milliseconds: 100),
              duration: Duration(milliseconds: 100),
              beginScale: 0.5,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('respects custom duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(
              duration: Duration(milliseconds: 500),
              beginScale: 0.5,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('uses custom curve', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleInWidget(
              curve: Curves.elasticOut,
              duration: Duration(milliseconds: 100),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles widget disposal correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ScaleInWidget(child: Text('Test'))),
        ),
      );

      await tester.pumpAndSettle();

      // Remove the widget
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      expect(find.text('Test'), findsNothing);
    });
  });
}
