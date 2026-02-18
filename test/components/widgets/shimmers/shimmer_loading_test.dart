import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/shimmers/shimmer_loading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('ShimmerLoading', () {
    testWidgets('renders with required dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ShimmerLoading), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('uses custom border radius', (WidgetTester tester) async {
      const customRadius = BorderRadius.all(Radius.circular(16));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
              borderRadius: customRadius,
            ),
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ShimmerLoading),
          matching: find.byType(Container),
        ),
      );

      expect(
        (container.decoration as BoxDecoration).borderRadius,
        equals(customRadius),
      );
    });

    testWidgets('uses default border radius when not specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
            ),
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ShimmerLoading),
          matching: find.byType(Container),
        ),
      );

      expect(
        (container.decoration as BoxDecoration).borderRadius,
        equals(BorderRadius.circular(8)),
      );
    });

    testWidgets('adapts colors for light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('adapts colors for dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('uses custom base color when provided',
        (WidgetTester tester) async {
      const customBaseColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
              baseColor: customBaseColor,
            ),
          ),
        ),
      );
      await tester.pump();

      final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
      expect(shimmer.gradient.colors, contains(customBaseColor));
    });

    testWidgets('uses custom highlight color when provided',
        (WidgetTester tester) async {
      const customHighlightColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 100,
              height: 50,
              highlightColor: customHighlightColor,
            ),
          ),
        ),
      );
      await tester.pump();

      final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
      expect(shimmer.gradient.colors, contains(customHighlightColor));
    });

    testWidgets('renders container with specified dimensions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoading(
              width: 200,
              height: 100,
            ),
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ShimmerLoading),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxWidth, equals(200));
      expect(container.constraints?.maxHeight, equals(100));
    });
  });
}
