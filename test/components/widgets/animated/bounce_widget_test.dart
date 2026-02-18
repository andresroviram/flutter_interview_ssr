import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/animated/bounce_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BounceWidget', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      const testKey = Key('test_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(
              child: const Text('Test', key: testKey),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('responds to tap gesture', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(
              onTap: () => tapped = true,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('works without onTap callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BounceWidget(child: Text('Test'))),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles tap cancel', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(child: const Text('Test'), onTap: () {}),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Test')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Move finger away to cancel
      await gesture.moveBy(const Offset(100, 100));
      await tester.pump();
      await gesture.cancel();
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('respects custom duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(
              duration: Duration(milliseconds: 50),
              onTap: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('can be tapped multiple times', (WidgetTester tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(
              onTap: () => tapCount++,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(tapCount, equals(3));
    });

    testWidgets('animates on tap down and up', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceWidget(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Center(child: Text('Test')),
              ),
              onTap: () {},
            ),
          ),
        ),
      );

      // Perform tap with gesture
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Test')),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
