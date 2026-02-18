import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/address_card_shimmer.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/shimmer_loading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddressCardShimmer', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AddressCardShimmer), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('contains circular icon shimmer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      final shimmerWidgets = tester.widgetList<ShimmerLoading>(
        find.byType(ShimmerLoading),
      ).toList();

      // First shimmer should be circular icon
      expect(shimmerWidgets.first.width, equals(40));
      expect(shimmerWidgets.first.height, equals(40));
      expect(
        shimmerWidgets.first.borderRadius,
        equals(const BorderRadius.all(Radius.circular(20))),
      );
    });

    testWidgets('contains multiple shimmer elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      // Should have 5 ShimmerLoading widgets:
      // 1 icon + 2 header lines + 2 address lines
      expect(find.byType(ShimmerLoading), findsNWidgets(5));
    });

    testWidgets('uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('uses Row for header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, equals(const EdgeInsets.only(bottom: 12)));
    });

    testWidgets('shimmers have different widths', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: const AddressCardShimmer(),
            ),
          ),
        ),
      );
      await tester.pump();

      final shimmerWidgets = tester.widgetList<ShimmerLoading>(
        find.byType(ShimmerLoading),
      ).toList();

      expect(shimmerWidgets.length, equals(5));
      // Icon has fixed width
      expect(shimmerWidgets[0].width, equals(40));
      // Address lines should span full width
      expect(shimmerWidgets[3].width, equals(double.infinity));
      expect(shimmerWidgets[4].width, equals(double.infinity));
    });

    testWidgets('contains proper spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressCardShimmer(),
          ),
        ),
      );
      await tester.pump();

      // Verify SizedBox widgets for spacing exist
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
