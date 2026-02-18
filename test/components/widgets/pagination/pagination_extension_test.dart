import 'package:flutter_interview_ssr/components/widgets/pagination/pagination_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginationExtension', () {
    group('paginate', () {
      test('returns correct items for page 1', () {
        final list = List.generate(30, (index) => index);

        final result = list.paginate(1, 10);

        expect(result.length, equals(10));
        expect(result.first, equals(0));
        expect(result.last, equals(9));
      });

      test('returns correct items for page 2', () {
        final list = List.generate(30, (index) => index);

        final result = list.paginate(2, 10);

        expect(result.length, equals(10));
        expect(result.first, equals(10));
        expect(result.last, equals(19));
      });

      test('returns correct items for last page', () {
        final list = List.generate(25, (index) => index);

        final result = list.paginate(3, 10);

        expect(result.length, equals(5));
        expect(result.first, equals(20));
        expect(result.last, equals(24));
      });

      test('returns empty list when page exceeds total pages', () {
        final list = List.generate(10, (index) => index);

        final result = list.paginate(5, 10);

        expect(result, isEmpty);
      });

      test('handles empty list', () {
        final List<int> list = [];

        final result = list.paginate(1, 10);

        expect(result, isEmpty);
      });

      test('handles custom itemsPerPage', () {
        final list = List.generate(50, (index) => index);

        final result = list.paginate(2, 20);

        expect(result.length, equals(20));
        expect(result.first, equals(20));
        expect(result.last, equals(39));
      });
    });

    group('hasMorePages', () {
      test('returns true when more pages exist', () {
        final list = List.generate(30, (index) => index);

        final result = list.hasMorePages(2, 10);

        expect(result, isTrue);
      });

      test('returns false when on last page', () {
        final list = List.generate(30, (index) => index);

        final result = list.hasMorePages(3, 10);

        expect(result, isFalse);
      });

      test('returns false when page exceeds total', () {
        final list = List.generate(10, (index) => index);

        final result = list.hasMorePages(5, 10);

        expect(result, isFalse);
      });

      test('returns false for empty list', () {
        final List<int> list = [];

        final result = list.hasMorePages(1, 10);

        expect(result, isFalse);
      });

      test('handles partial last page correctly', () {
        final list = List.generate(25, (index) => index);

        expect(list.hasMorePages(2, 10), isTrue); // 20 < 25
        expect(list.hasMorePages(3, 10), isFalse); // 30 >= 25
      });
    });

    group('getTotalPages', () {
      test('returns correct total pages', () {
        final list = List.generate(30, (index) => index);

        final result = list.getTotalPages(10);

        expect(result, equals(3));
      });

      test('rounds up for partial pages', () {
        final list = List.generate(25, (index) => index);

        final result = list.getTotalPages(10);

        expect(result, equals(3));
      });

      test('returns 0 for empty list', () {
        final List<int> list = [];

        final result = list.getTotalPages(10);

        expect(result, equals(0));
      });

      test('returns 1 when items fit in one page', () {
        final list = List.generate(5, (index) => index);

        final result = list.getTotalPages(10);

        expect(result, equals(1));
      });

      test('handles custom itemsPerPage', () {
        final list = List.generate(100, (index) => index);

        expect(list.getTotalPages(20), equals(5));
        expect(list.getTotalPages(30), equals(4));
        expect(list.getTotalPages(50), equals(2));
      });

      test('handles single item', () {
        final list = [1];

        final result = list.getTotalPages(10);

        expect(result, equals(1));
      });
    });

    group('integration', () {
      test('paginate and hasMorePages work together', () {
        final list = List.generate(25, (index) => index);

        // Page 1
        final page1 = list.paginate(1, 10);
        expect(page1.length, equals(10));
        expect(list.hasMorePages(1, 10), isTrue);

        // Page 2
        final page2 = list.paginate(2, 10);
        expect(page2.length, equals(10));
        expect(list.hasMorePages(2, 10), isTrue);

        // Page 3 (last partial page)
        final page3 = list.paginate(3, 10);
        expect(page3.length, equals(5));
        expect(list.hasMorePages(3, 10), isFalse);
      });

      test('getTotalPages and paginate consistency', () {
        final list = List.generate(43, (index) => index);
        final itemsPerPage = 10;

        final totalPages = list.getTotalPages(itemsPerPage);
        expect(totalPages, equals(5)); // 43/10 = 4.3 → 5 pages

        // Verify we can paginate all pages
        for (int page = 1; page <= totalPages; page++) {
          final pageItems = list.paginate(page, itemsPerPage);
          expect(pageItems, isNotEmpty);
        }

        // Verify next page is empty
        final beyondPages = list.paginate(totalPages + 1, itemsPerPage);
        expect(beyondPages, isEmpty);
      });
    });
  });
}
