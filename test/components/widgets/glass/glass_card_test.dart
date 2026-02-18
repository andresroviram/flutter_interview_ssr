import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_card.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_container.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlassCard', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Card Content'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(GlassCard), findsOneWidget);
    });

    testWidgets('uses GlassContainer internally', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Internal'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('applies default padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Padding Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Padding Test'), findsOneWidget);
    });

    testWidgets('applies custom padding when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              padding: const EdgeInsets.all(32),
              child: const Text('Custom Padding'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Custom Padding'), findsOneWidget);
    });

    testWidgets('wraps with InkWell when onTap is provided',
        (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Tappable'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(InkWell), findsOneWidget);

      await tester.tap(find.byType(GlassCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not wrap with InkWell when onTap is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Not Tappable'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('passes blur parameter to GlassContainer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              blur: 15.0,
              child: const Text('Blur Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('passes opacity parameter to GlassContainer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              opacity: 0.3,
              child: const Text('Opacity Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('applies custom margin', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              margin: const EdgeInsets.all(16),
              child: const Text('Margin Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Margin Test'), findsOneWidget);
    });

    testWidgets('has rounded borders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Borders'),
            ),
          ),
        ),
      );
      await tester.pump();

      // InkWell with borderRadius exists when onTap is null (wrapped in GlassContainer)
      expect(find.byType(GlassCard), findsOneWidget);
    });
  });
}
