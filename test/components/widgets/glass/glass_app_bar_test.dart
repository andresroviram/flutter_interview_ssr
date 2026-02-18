import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass_app_bar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlassAppBar', () {
    testWidgets('renders with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(title: 'Test Title'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(GlassAppBar), findsOneWidget);
    });

    testWidgets('implements PreferredSizeWidget', (WidgetTester tester) async {
      const appBar = GlassAppBar(title: 'Test');

      expect(appBar, isA<PreferredSizeWidget>());
      expect(
          appBar.preferredSize, equals(const Size.fromHeight(kToolbarHeight)));
    });

    testWidgets('uses BackdropFilter for glass effect',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(title: 'Blur Test'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders AppBar internally', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(title: 'Internal AppBar'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays actions when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(
              title: 'Actions Test',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('displays custom leading widget when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(
              title: 'Leading Test',
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('respects automaticallyImplyLeading parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(
              title: 'No Leading',
              automaticallyImplyLeading: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlassAppBar), findsOneWidget);
    });

    testWidgets('uses ClipRRect for rounded effect',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(title: 'Clip Test'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('has zero elevation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(title: 'Elevation Test'),
          ),
        ),
      );
      await tester.pump();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, equals(0));
    });

    testWidgets('adapts to theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            appBar: GlassAppBar(title: 'Theme Test'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Theme Test'), findsOneWidget);
    });

    testWidgets('accepts custom blur parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(
              title: 'Custom Blur',
              blur: 20.0,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('accepts custom opacity parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: GlassAppBar(
              title: 'Custom Opacity',
              opacity: 0.3,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Custom Opacity'), findsOneWidget);
    });
  });
}
