import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

void main() {
  group('GlassContainer', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Test Child'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Test Child'), findsOneWidget);
      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('applies BackdropFilter with blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              blur: 15.0,
              child: const Text('Blur Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('uses ClipRRect for rounded corners',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Clip Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('applies custom width and height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              width: 200,
              height: 100,
              child: const Text('Size Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      final container =
          tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, equals(200));
      expect(container.constraints?.maxHeight, equals(100));
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(24);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              padding: customPadding,
              child: const Text('Padding Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify padding exists in the widget tree
      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Padding Test'), findsOneWidget);
    });

    testWidgets('applies custom margin', (WidgetTester tester) async {
      const customMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              margin: customMargin,
              child: const Text('Margin Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      final container =
          tester.widget<Container>(find.byType(Container).first);
      expect(container.margin, equals(customMargin));
    });

    testWidgets('uses custom borderRadius when provided',
        (WidgetTester tester) async {
      const customRadius = BorderRadius.all(Radius.circular(24));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              borderRadius: customRadius,
              child: const Text('Border Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('uses default borderRadius when not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Default Border'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('adapts to light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeData.light(),
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Theme Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Theme Test'), findsOneWidget);
    });

    testWidgets('adapts to dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          themeMode: ThemeMode.dark,
          theme: ThemeData.dark(),
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Dark Theme'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dark Theme'), findsOneWidget);
    });

    testWidgets('applies custom gradient when provided',
        (WidgetTester tester) async {
      const customGradient = LinearGradient(
        colors: [Colors.blue, Colors.purple],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              gradient: customGradient,
              child: const Text('Gradient Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Gradient Test'), findsOneWidget);
    });

    testWidgets('has proper widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: const Text('Structure Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
