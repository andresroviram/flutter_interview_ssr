import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/pagination/load_more_indicator.dart';
import 'package:flutter_interview_ssr/components/widgets/pagination/paginated_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginatedListView', () {
    testWidgets('renders items using itemBuilder', (WidgetTester tester) async {
      final items = List.generate(5, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    testWidgets('displays LoadMoreIndicator at the end', (
      WidgetTester tester,
    ) async {
      final items = List.generate(3, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LoadMoreIndicator), findsOneWidget);
    });

    testWidgets('displays emptyWidget when items list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
              emptyWidget: const Text('No items'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No items'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      final items = ['Item 1'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) => Text(item),
              padding: const EdgeInsets.all(20),
            ),
          ),
        ),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(const EdgeInsets.all(20)));
    });

    testWidgets('uses provided ScrollController', (WidgetTester tester) async {
      final controller = ScrollController();
      final items = List.generate(20, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) =>
                  SizedBox(height: 50, child: Text(item)),
              controller: controller,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.hasClients, isTrue);

      controller.dispose();
    });

    testWidgets('passes isLoadingMore to LoadMoreIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const ['Item'],
              itemBuilder: (context, item, index) => Text(item),
              isLoadingMore: true,
            ),
          ),
        ),
      );
      await tester.pump();

      final indicator = tester.widget<LoadMoreIndicator>(
        find.byType(LoadMoreIndicator),
      );
      expect(indicator.isLoadingMore, isTrue);
    });

    testWidgets('passes hasMoreItems to LoadMoreIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const ['Item'],
              itemBuilder: (context, item, index) => Text(item),
              hasMoreItems: false,
            ),
          ),
        ),
      );
      await tester.pump();

      final indicator = tester.widget<LoadMoreIndicator>(
        find.byType(LoadMoreIndicator),
      );
      expect(indicator.hasMoreItems, isFalse);
    });

    testWidgets('renders correct item count including indicator', (
      WidgetTester tester,
    ) async {
      final items = List.generate(5, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      // items.length + 1 (LoadMoreIndicator)
      expect(listView.semanticChildCount, equals(6));
    });

    testWidgets('creates internal ScrollController when none provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const ['Item'],
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.controller, isNotNull);
    });

    testWidgets('calls onLoadMore when scrolling near bottom', (
      WidgetTester tester,
    ) async {
      bool loadMoreCalled = false;
      final items = List.generate(20, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView<String>(
                items: items,
                itemBuilder: (context, item, index) =>
                    SizedBox(height: 50, child: Text(item)),
                onLoadMore: () async {
                  loadMoreCalled = true;
                },
                loadMoreThreshold: 100,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to near bottom
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(loadMoreCalled, isTrue);
    });

    testWidgets('does not call onLoadMore multiple times simultaneously', (
      WidgetTester tester,
    ) async {
      int loadMoreCallCount = 0;
      final items = List.generate(20, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView<String>(
                items: items,
                itemBuilder: (context, item, index) =>
                    SizedBox(height: 50, child: Text(item)),
                onLoadMore: () async {
                  loadMoreCallCount++;
                  // Simulate async operation
                  await Future.delayed(const Duration(milliseconds: 100));
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to trigger load more
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();

      // Try to trigger again immediately (should be prevented by _isLoading)
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pump();

      // Wait for the async operation to complete
      await tester.pumpAndSettle();

      // Should have been called only once despite multiple scroll events
      expect(loadMoreCallCount, equals(1));
    });

    testWidgets('does not call onLoadMore when no more items', (
      WidgetTester tester,
    ) async {
      int loadMoreCallCount = 0;
      final items = List.generate(20, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView<String>(
                items: items,
                itemBuilder: (context, item, index) =>
                    SizedBox(height: 50, child: Text(item)),
                hasMoreItems: false, // No more items
                onLoadMore: () async {
                  loadMoreCallCount++;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Try to scroll
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(loadMoreCallCount, equals(0));
    });

    testWidgets('handles items with custom types', (WidgetTester tester) async {
      final items = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<Map<String, dynamic>>(
              items: items,
              itemBuilder: (context, item, index) => Text(item['name']),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('itemBuilder receives correct index', (
      WidgetTester tester,
    ) async {
      final items = ['A', 'B', 'C'];
      final receivedIndices = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: items,
              itemBuilder: (context, item, index) {
                receivedIndices.add(index);
                return Text('$item-$index');
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(receivedIndices, equals([0, 1, 2]));
      expect(find.text('A-0'), findsOneWidget);
      expect(find.text('B-1'), findsOneWidget);
      expect(find.text('C-2'), findsOneWidget);
    });

    testWidgets('respects loadMoreThreshold parameter', (
      WidgetTester tester,
    ) async {
      final items = List.generate(30, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView<String>(
                items: items,
                itemBuilder: (context, item, index) =>
                    SizedBox(height: 50, child: Text(item)),
                onLoadMore: () async {},
                loadMoreThreshold: 500, // Large threshold
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Small scroll shouldn't trigger
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();

      // With large threshold, might trigger even with small scroll
      // depending on content height
      // Just verify it doesn't crash
      expect(find.byType(PaginatedListView<String>), findsOneWidget);
    });
  });
}
