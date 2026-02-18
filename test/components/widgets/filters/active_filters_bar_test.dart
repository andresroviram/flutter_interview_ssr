import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/filters/active_filter_chip.dart';
import 'package:flutter_interview_ssr/components/widgets/filters/active_filters_bar.dart';
import 'package:flutter_interview_ssr/features/users/presentation/controllers/user_filters/user_filters_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveFiltersBar', () {
    testWidgets('renders nothing when no filters are active', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ActiveFilterChip), findsNothing);
    });

    testWidgets('displays age filter chip when age range is set', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(minAge: 25, maxAge: 35);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ActiveFilterChip), findsOneWidget);
      expect(find.text('Edad: 25-35'), findsOneWidget);
    });

    testWidgets('displays clear all button when filters are active', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(minAge: 18, maxAge: 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Limpiar todo'), findsOneWidget);
      expect(find.byIcon(Icons.clear_all), findsOneWidget);
    });

    testWidgets('triggers onUpdateFilters when age filter is deleted', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(minAge: 20, maxAge: 40);
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(
              filters: filters,
              onUpdateFilters: (newFilters) {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      // Tap the close icon on the age filter chip
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('triggers onUpdateFilters when clear all is pressed', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(
        minAge: 25,
        maxAge: 50,
        sortBy: UserSortBy.age,
      );
      UserFiltersState? updatedFilters;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(
              filters: filters,
              onUpdateFilters: (newFilters) {
                updatedFilters = newFilters;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Limpiar todo'));
      await tester.pump();

      expect(updatedFilters, isNotNull);
      expect(updatedFilters?.hasActiveFilters, isFalse);
    });

    testWidgets('uses horizontal scroll view', (WidgetTester tester) async {
      const filters = UserFiltersState(minAge: 20, maxAge: 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('applies proper padding to container', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(minAge: 18, maxAge: 25);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(
        container.padding,
        equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      );
    });

    testWidgets('displays default age values when only minAge is set', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(minAge: 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Edad: 30-100'), findsOneWidget);
    });

    testWidgets('displays default age values when only maxAge is set', (
      WidgetTester tester,
    ) async {
      const filters = UserFiltersState(maxAge: 50);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveFiltersBar(filters: filters, onUpdateFilters: (_) {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Edad: 18-50'), findsOneWidget);
    });
  });
}
