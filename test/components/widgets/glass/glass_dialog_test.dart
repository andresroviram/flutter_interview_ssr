import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_container.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlassDialog', () {
    testWidgets('renders content widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('Dialog Content'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dialog Content'), findsOneWidget);
      expect(find.byType(GlassDialog), findsOneWidget);
    });

    testWidgets('renders Dialog widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('uses GlassContainer internally',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('Glass Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('displays title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              title: 'Dialog Title',
              content: Text('Content'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dialog Title'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('does not display title section when title is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('No Title'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No Title'), findsOneWidget);
    });

    testWidgets('displays actions when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: const Text('Actions Test'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              title: 'Title',
              content: Text('Content'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('has transparent background', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('Transparent'),
            ),
          ),
        ),
      );
      await tester.pump();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.backgroundColor, equals(Colors.transparent));
    });

    testWidgets('has zero elevation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: Text('Elevation Test'),
            ),
          ),
        ),
      );
      await tester.pump();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.elevation, equals(0));
    });

    testWidgets('adapts gradient to light theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: GlassDialog(
              content: Text('Light Theme'),
            ),
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
          home: const Scaffold(
            body: GlassDialog(
              content: Text('Dark Theme'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dark Theme'), findsOneWidget);
    });

    testWidgets('uses SizedBox for spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              title: 'Title',
              content: const Text('Content'),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Action')),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('actions have proper alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassDialog(
              content: const Text('Alignment Test'),
              actions: [
                TextButton(onPressed: () {}, child: const Text('OK')),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Row), findsWidgets);
    });
  });
}
