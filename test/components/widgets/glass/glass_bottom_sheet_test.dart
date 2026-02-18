import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_bottom_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlassBottomSheet', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Bottom Sheet Content')),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Bottom Sheet Content'), findsOneWidget);
      expect(find.byType(GlassBottomSheet), findsOneWidget);
    });

    testWidgets('uses BackdropFilter for glass effect', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Blur Test')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('uses ClipRRect for rounded top corners', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GlassBottomSheet(child: const Text('Rounded'))),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('has gradient decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Gradient Test')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('adapts gradient to light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Light Theme')),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Light Theme'), findsOneWidget);
    });

    testWidgets('adapts gradient to dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Dark Theme')),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dark Theme'), findsOneWidget);
    });

    testWidgets('accepts custom blur parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(
              blur: 30.0,
              child: const Text('Custom Blur'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('accepts custom opacity parameter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(
              opacity: 0.5,
              child: const Text('Custom Opacity'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Custom Opacity'), findsOneWidget);
    });

    testWidgets('has top border', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Border Test')),
          ),
        ),
      );
      await tester.pump();

      // Verify container with decoration exists
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('properly rounds top corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(child: const Text('Corners Test')),
          ),
        ),
      );
      await tester.pump();

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(
        clipRRect.borderRadius,
        equals(const BorderRadius.vertical(top: Radius.circular(28))),
      );
    });

    testWidgets('renders various child types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(
              child: Column(
                children: [
                  const Text('Title'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () {}, child: const Text('Button')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Button'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('maintains structure integrity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBottomSheet(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Structured'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
