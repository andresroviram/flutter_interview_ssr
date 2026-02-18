import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/shimmer_loading.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/user_card_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserCardShimmer', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(UserCardShimmer), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('contains circular avatar shimmer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      // Find ShimmerLoading widgets
      final shimmerWidgets = tester.widgetList<ShimmerLoading>(
        find.byType(ShimmerLoading),
      );

      // First shimmer should be circular (avatar)
      expect(shimmerWidgets.first.width, equals(56));
      expect(shimmerWidgets.first.height, equals(56));
      expect(
        shimmerWidgets.first.borderRadius,
        equals(const BorderRadius.all(Radius.circular(28))),
      );
    });

    testWidgets('contains multiple text line shimmers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      // Should have 4 ShimmerLoading widgets: 1 avatar + 3 text lines
      expect(find.byType(ShimmerLoading), findsNWidgets(4));
    });

    testWidgets('uses Row layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('uses Column for text lines', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, equals(const EdgeInsets.only(bottom: 12)));
    });

    testWidgets('text lines have different widths',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: const UserCardShimmer(),
            ),
          ),
        ),
      );
      await tester.pump();

      final shimmerWidgets = tester
          .widgetList<ShimmerLoading>(
            find.byType(ShimmerLoading),
          )
          .toList();

      // Skip first (avatar), check text lines
      expect(shimmerWidgets.length, equals(4));
      expect(shimmerWidgets[1].width, equals(double.infinity));
      expect(shimmerWidgets[2].width, greaterThan(0));
      expect(shimmerWidgets[3].width, greaterThan(0));
    });
  });
}
