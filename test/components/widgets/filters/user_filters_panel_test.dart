import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/filters/user_filters_panel.dart';
import 'package:flutter_interview_ssr/features/users/presentation/controllers/user_filters/user_filters_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserFiltersPanel', () {
    testWidgets('renders correctly with initial filters', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(UserFiltersPanel), findsOneWidget);
      expect(find.text('Filtros'), findsOneWidget);
    });

    testWidgets('displays close button', (WidgetTester tester) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('displays age range slider', (WidgetTester tester) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Rango de Edad'), findsOneWidget);
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('displays sort by options', (WidgetTester tester) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Ordenar por'), findsOneWidget);
      expect(find.byType(FilterChip), findsWidgets);
    });

    testWidgets('displays ascending order switch', (WidgetTester tester) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Orden ascendente'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('displays clear and apply buttons', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Limpiar'), findsOneWidget);
      expect(find.text('Aplicar Filtros'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('initializes with provided filters', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState(
        minAge: 25,
        maxAge: 35,
        sortBy: UserSortBy.age,
        sortAscending: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('25 - 35 años'), findsOneWidget);
    });

    testWidgets('clears filters when clear button is pressed', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState(minAge: 30, maxAge: 50);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Tap clear button
      await tester.tap(find.text('Limpiar'));
      await tester.pump();

      // Should reset to default age range
      expect(find.text('18 - 100 años'), findsOneWidget);
    });

    testWidgets('calls onApplyFilters when apply is pressed', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState(minAge: 20, maxAge: 40);
      UserFiltersState? appliedFilters;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (filters) {
                  appliedFilters = filters;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Aplicar Filtros'));
      await tester.pump();

      expect(appliedFilters, isNotNull);
      expect(appliedFilters?.minAge, equals(20));
      expect(appliedFilters?.maxAge, equals(40));
    });

    testWidgets('displays Z → A when sort ascending is false', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState(sortAscending: false);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Z → A'), findsOneWidget);
    });

    testWidgets('displays A → Z when sort ascending is true', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState(sortAscending: true);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('A → Z'), findsOneWidget);
    });

    testWidgets('uses SafeArea for proper padding', (
      WidgetTester tester,
    ) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SafeArea), findsWidgets);
    });

    testWidgets('has proper column layout', (WidgetTester tester) async {
      const initialFilters = UserFiltersState();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserFiltersPanel(
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });
  });
}
