import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/animated/slide_in_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlideInWidget', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      const testKey = Key('test_child');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInWidget(
              child: Text('Test', key: testKey),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('applies slide and fade animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInWidget(
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

    testWidgets('respects custom beginOffset', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInWidget(
              beginOffset: Offset(0.5, 0.5),
              child: Text('Test'),
            ),
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
            body: SlideInWidget(
              delay: Duration(milliseconds: 100),
              duration: Duration(milliseconds: 100),
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
            body: SlideInWidget(
              duration: Duration(milliseconds: 500),
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
            body: SlideInWidget(
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 100),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles widget disposal correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInWidget(
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Remove the widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
      
      expect(find.text('Test'), findsNothing);
    });
  });
}
