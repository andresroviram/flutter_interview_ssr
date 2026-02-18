import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/pagination/load_more_indicator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadMoreIndicator', () {
    testWidgets('shows CircularProgressIndicator when loading more', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: true, hasMoreItems: true),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('No hay más elementos'), findsNothing);
      expect(find.text('Cargar más'), findsNothing);
    });

    testWidgets('shows "No hay más elementos" when no more items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: false, hasMoreItems: false),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No hay más elementos'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Cargar más'), findsNothing);
    });

    testWidgets('shows "Cargar más" button when onLoadMore provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(
              isLoadingMore: false,
              hasMoreItems: true,
              onLoadMore: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Cargar más'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No hay más elementos'), findsNothing);
    });

    testWidgets('shows nothing when no items and no callback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: false, hasMoreItems: true),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Cargar más'), findsNothing);
      expect(find.text('No hay más elementos'), findsNothing);
    });

    testWidgets('executes onLoadMore callback when button pressed', (
      WidgetTester tester,
    ) async {
      bool callbackExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(
              isLoadingMore: false,
              hasMoreItems: true,
              onLoadMore: () {
                callbackExecuted = true;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(callbackExecuted, isTrue);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: true, hasMoreItems: true),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('prioritizes loading state over other states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(
              isLoadingMore: true,
              hasMoreItems: false,
              onLoadMore: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      // Should show loading indicator even when hasMoreItems is false
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('No hay más elementos'), findsNothing);
      expect(find.text('Cargar más'), findsNothing);
    });

    testWidgets('centers content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: false, hasMoreItems: false),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('has styled text for no more items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadMoreIndicator(isLoadingMore: false, hasMoreItems: false),
          ),
        ),
      );
      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('No hay más elementos'));
      expect(textWidget.style?.fontSize, equals(14));
    });
  });
}
