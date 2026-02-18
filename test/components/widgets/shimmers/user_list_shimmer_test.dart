import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/user_card_shimmer.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/user_list_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserListShimmer', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer())),
      );
      await tester.pump();

      expect(find.byType(UserListShimmer), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders default number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer())),
      );
      await tester.pump();

      // Default is 5 items
      expect(find.byType(UserCardShimmer), findsNWidgets(5));
    });

    testWidgets('renders custom number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer(itemCount: 3))),
      );
      await tester.pump();

      expect(find.byType(UserCardShimmer), findsNWidgets(3));
    });

    testWidgets('uses ListView.builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer())),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer())),
      );
      await tester.pump();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('renders zero items when itemCount is 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer(itemCount: 0))),
      );
      await tester.pump();

      expect(find.byType(UserCardShimmer), findsNothing);
    });

    testWidgets('can render many items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserListShimmer(itemCount: 10))),
      );
      await tester.pump();

      // ListView.builder only builds visible items, so we check if ListView exists
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
