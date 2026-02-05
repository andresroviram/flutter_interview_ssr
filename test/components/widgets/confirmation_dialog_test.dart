import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/components/widgets/confirmation_dialog.dart';

void main() {
  group('ConfirmationDialog Tests', () {
    Widget createTestApp(Widget child) {
      return MaterialApp(
        home: Scaffold(body: Builder(builder: (context) => child)),
      );
    }

    testWidgets('showConfirmationDialog should display title and message', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                  context: context,
                  title: 'Test Title',
                  message: 'Test Message',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('showConfirmationDialog should display default button texts', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                  context: context,
                  title: 'Test',
                  message: 'Message',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('showConfirmationDialog should display custom button texts', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                  context: context,
                  title: 'Test',
                  message: 'Message',
                  confirmText: 'Accept',
                  cancelText: 'Decline',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets(
      'showConfirmationDialog should return true when confirm is tapped',
      (tester) async {
        bool? result;

        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showConfirmationDialog(
                    context: context,
                    title: 'Test',
                    message: 'Message',
                    useGlassEffect: false,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirmar'));
        await tester.pumpAndSettle();

        expect(result, isTrue);
      },
    );

    testWidgets(
      'showConfirmationDialog should return false when cancel is tapped',
      (tester) async {
        bool? result;

        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showConfirmationDialog(
                    context: context,
                    title: 'Test',
                    message: 'Message',
                    useGlassEffect: false,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        expect(result, isFalse);
      },
    );

    testWidgets(
      'showConfirmationDialog should close on cancel without useGlassEffect',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(
                    context: context,
                    title: 'Test',
                    message: 'Message',
                    useGlassEffect: false,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsNothing);
      },
    );

    testWidgets('showDeleteConfirmationDialog should display delete message', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'Usuario: Juan Pérez',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show Delete'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar'), findsWidgets);
      expect(find.textContaining('¿Estás seguro de eliminar?'), findsOneWidget);
      expect(find.textContaining('Usuario: Juan Pérez'), findsOneWidget);
    });

    testWidgets(
      'showDeleteConfirmationDialog should have delete and cancel buttons',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDeleteConfirmationDialog(
                    context: context,
                    itemName: 'Test Item',
                    useGlassEffect: false,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Eliminar'), findsAtLeastNWidgets(1));
        expect(find.text('Cancelar'), findsOneWidget);
      },
    );

    testWidgets('showDeleteConfirmationDialog should return true on confirm', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'Test Item',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Find the button with text 'Eliminar' that is not the title
      final deleteButtons = find.text('Eliminar');
      expect(deleteButtons, findsAtLeastNWidgets(1));

      // Tap the last Eliminar button (the action button)
      await tester.tap(deleteButtons.last);
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('showDeleteConfirmationDialog should return false on cancel', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'Test Item',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('showDeleteConfirmationDialog should use custom title', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'Test',
                  title: 'Confirmar Borrado',
                  useGlassEffect: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmar Borrado'), findsOneWidget);
    });
  });
}
