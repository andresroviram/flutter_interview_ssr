import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/shimmer_loading.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/user_detail_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDetailShimmer', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      expect(find.byType(UserDetailShimmer), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('contains large circular avatar shimmer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      final shimmerWidgets = tester
          .widgetList<ShimmerLoading>(find.byType(ShimmerLoading))
          .toList();

      // First shimmer should be large circular avatar
      expect(shimmerWidgets.first.width, equals(120));
      expect(shimmerWidgets.first.height, equals(120));
      expect(
        shimmerWidgets.first.borderRadius,
        equals(const BorderRadius.all(Radius.circular(60))),
      );
    });

    testWidgets('contains multiple shimmer elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      // Should have multiple ShimmerLoading widgets:
      // 1 avatar + 2 header lines + 3 cards with 2 lines each = 9 total
      expect(find.byType(ShimmerLoading), findsNWidgets(9));
    });

    testWidgets('uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('contains multiple cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      // Should have 3 information cards
      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('cards have proper structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      // Each card should contain shimmer elements
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.length, equals(3));
    });

    testWidgets('is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserDetailShimmer())),
      );
      await tester.pump();

      // Verify SingleChildScrollView exists and is scrollable
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);
    });
  });
}
