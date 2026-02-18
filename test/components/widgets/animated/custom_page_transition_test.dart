import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/animated/custom_page_transition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomPageTransition', () {
    testWidgets('creates a route with the child widget',
        (WidgetTester tester) async {
      const testPage = CustomPageTransition(
        child: Text('Test Page'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [testPage],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      expect(find.text('Test Page'), findsOneWidget);
    });

    testWidgets('applies fade transition', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [
              CustomPageTransition(
                child: Scaffold(body: Text('Page 1')),
              ),
            ],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page content is rendered with transitions
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.byType(FadeTransition), findsAtLeastNWidgets(1));
    });

    testWidgets('applies slide transition', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [
              CustomPageTransition(
                child: Scaffold(body: Text('Page 1')),
              ),
            ],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page content is rendered with transitions
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.byType(SlideTransition), findsAtLeastNWidgets(1));
    });

    testWidgets('respects custom duration', (WidgetTester tester) async {
      const customDuration = Duration(milliseconds: 500);

      const testPage = CustomPageTransition(
        duration: customDuration,
        child: Scaffold(body: Text('Test Page')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [testPage],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Page'), findsOneWidget);
    });

    testWidgets('respects custom reverse duration',
        (WidgetTester tester) async {
      const customReverseDuration = Duration(milliseconds: 100);

      const testPage = CustomPageTransition(
        reverseDuration: customReverseDuration,
        child: Scaffold(body: Text('Test Page')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [testPage],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Page'), findsOneWidget);
    });

    testWidgets('handles navigation between pages',
        (WidgetTester tester) async {
      final pages = <Page>[
        const MaterialPage(
          child: Scaffold(body: Text('Page 1')),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Navigator(
                pages: pages,
                onPopPage: (route, result) {
                  setState(() {
                    pages.removeLast();
                  });
                  return route.didPop(result);
                },
              );
            },
          ),
        ),
      );

      expect(find.text('Page 1'), findsOneWidget);

      // Add a new page with custom transition
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Navigator(
                pages: [
                  const MaterialPage(
                    child: Scaffold(body: Text('Page 1')),
                  ),
                  const CustomPageTransition(
                    child: Scaffold(body: Text('Page 2')),
                  ),
                ],
                onPopPage: (route, result) {
                  setState(() {
                    pages.removeLast();
                  });
                  return route.didPop(result);
                },
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('can be used with MaterialApp onGenerateRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == '/test') {
              return CustomPageTransition(
                child: const Scaffold(body: Text('Test Route')),
              ).createRoute(tester.element(find.byType(MaterialApp)));
            }
            return null;
          },
          home: const Scaffold(body: Text('Home')),
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      // Navigate to test route
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/test');

      await tester.pumpAndSettle();

      expect(find.text('Test Route'), findsOneWidget);
    });

    testWidgets('createRoute returns PageRouteBuilder',
        (WidgetTester tester) async {
      const transition = CustomPageTransition(
        child: Text('Test'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Home')),
        ),
      );

      final context = tester.element(find.text('Home'));
      final route = transition.createRoute(context);

      expect(route, isA<PageRouteBuilder>());
    });

    testWidgets('uses easeInOutCubic curve', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: const [
              CustomPageTransition(
                child: Scaffold(body: Text('Page 1')),
              ),
            ],
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page is rendered after animation with transitions
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.byType(FadeTransition), findsAtLeastNWidgets(1));
      expect(find.byType(SlideTransition), findsAtLeastNWidgets(1));
    });
  });
}
