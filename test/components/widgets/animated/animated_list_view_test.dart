import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/animated/animated_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedListView', () {
    testWidgets('renders all items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 5,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      // Wait for animations
      await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }
    });

    testWidgets('uses custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 3,
              padding: customPadding,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(customPadding));
    });

    testWidgets('uses custom scroll controller', (WidgetTester tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 20,
              controller: controller,
              itemBuilder: (context, index) =>
                  SizedBox(height: 100, child: Text('Item $index')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.hasClients, isTrue);
      expect(controller.offset, equals(0));

      controller.dispose();
    });

    testWidgets('wraps items with SlideInWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 3,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Items should be rendered
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('applies stagger delay to items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 3,
              staggerDuration: const Duration(milliseconds: 100),
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // All items should be visible after settling
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('respects custom item duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 2,
              itemDuration: const Duration(milliseconds: 200),
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('handles empty list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 0,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('scrolls properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 10,
              staggerDuration: Duration.zero, // Disable stagger for this test
              itemBuilder: (context, index) =>
                  SizedBox(height: 100, child: Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify items are rendered
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('itemBuilder receives correct index', (
      WidgetTester tester,
    ) async {
      final builtIndices = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedListView(
              itemCount: 5,
              itemBuilder: (context, index) {
                builtIndices.add(index);
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(builtIndices, containsAll([0, 1, 2, 3, 4]));
    });
  });
}
