import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/address_card_shimmer.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/address_list_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddressListShimmer', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AddressListShimmer), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders default number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(),
          ),
        ),
      );
      await tester.pump();

      // Default is 3 items
      expect(find.byType(AddressCardShimmer), findsNWidgets(3));
    });

    testWidgets('renders custom number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(itemCount: 5),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AddressCardShimmer), findsNWidgets(5));
    });

    testWidgets('uses ListView.builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(),
          ),
        ),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(),
          ),
        ),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('renders zero items when itemCount is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(itemCount: 0),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AddressCardShimmer), findsNothing);
    });

    testWidgets('renders single item', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(itemCount: 1),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AddressCardShimmer), findsOneWidget);
    });

    testWidgets('can render many items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressListShimmer(itemCount: 10),
          ),
        ),
      );
      await tester.pump();

      // ListView.builder only builds visible items
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
