import 'package:flutter_interview_ssr/components/widgets/pagination/pagination_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginationState', () {
    test('creates instance with default values', () {
      const state = PaginationState();

      expect(state.currentPage, equals(1));
      expect(state.itemsPerPage, equals(10));
      expect(state.isLoadingMore, isFalse);
      expect(state.hasMoreItems, isTrue);
    });

    test('creates instance with custom values', () {
      const state = PaginationState(
        currentPage: 5,
        itemsPerPage: 20,
        isLoadingMore: true,
        hasMoreItems: false,
      );

      expect(state.currentPage, equals(5));
      expect(state.itemsPerPage, equals(20));
      expect(state.isLoadingMore, isTrue);
      expect(state.hasMoreItems, isFalse);
    });

    test('copyWith creates new instance with updated values', () {
      const state = PaginationState(
        currentPage: 1,
        itemsPerPage: 10,
      );

      final updated = state.copyWith(
        currentPage: 2,
        isLoadingMore: true,
      );

      expect(updated.currentPage, equals(2));
      expect(updated.itemsPerPage, equals(10)); // unchanged
      expect(updated.isLoadingMore, isTrue);
      expect(updated.hasMoreItems, isTrue); // unchanged
    });

    test('copyWith with no parameters returns copy with same values', () {
      const state = PaginationState(
        currentPage: 3,
        itemsPerPage: 15,
        isLoadingMore: true,
        hasMoreItems: false,
      );

      final copy = state.copyWith();

      expect(copy.currentPage, equals(state.currentPage));
      expect(copy.itemsPerPage, equals(state.itemsPerPage));
      expect(copy.isLoadingMore, equals(state.isLoadingMore));
      expect(copy.hasMoreItems, equals(state.hasMoreItems));
    });

    test('copyWith can update currentPage', () {
      const state = PaginationState();

      final updated = state.copyWith(currentPage: 10);

      expect(updated.currentPage, equals(10));
    });

    test('copyWith can update itemsPerPage', () {
      const state = PaginationState();

      final updated = state.copyWith(itemsPerPage: 50);

      expect(updated.itemsPerPage, equals(50));
    });

    test('copyWith can update isLoadingMore', () {
      const state = PaginationState();

      final updated = state.copyWith(isLoadingMore: true);

      expect(updated.isLoadingMore, isTrue);
    });

    test('copyWith can update hasMoreItems', () {
      const state = PaginationState(hasMoreItems: true);

      final updated = state.copyWith(hasMoreItems: false);

      expect(updated.hasMoreItems, isFalse);
    });

    test('copyWith updates multiple fields', () {
      const state = PaginationState(
        currentPage: 1,
        itemsPerPage: 10,
      );

      final updated = state.copyWith(
        currentPage: 5,
        itemsPerPage: 25,
        isLoadingMore: true,
        hasMoreItems: false,
      );

      expect(updated.currentPage, equals(5));
      expect(updated.itemsPerPage, equals(25));
      expect(updated.isLoadingMore, isTrue);
      expect(updated.hasMoreItems, isFalse);
    });

    test('original state remains unchanged after copyWith', () {
      const state = PaginationState(
        currentPage: 2,
        itemsPerPage: 15,
      );

      state.copyWith(currentPage: 10, isLoadingMore: true);

      expect(state.currentPage, equals(2));
      expect(state.isLoadingMore, isFalse);
    });

    test('can chain multiple copyWith calls', () {
      const initial = PaginationState();

      final result = initial
          .copyWith(currentPage: 2)
          .copyWith(isLoadingMore: true)
          .copyWith(hasMoreItems: false);

      expect(result.currentPage, equals(2));
      expect(result.isLoadingMore, isTrue);
      expect(result.hasMoreItems, isFalse);
      expect(result.itemsPerPage, equals(10)); // original default
    });

    test('supports loading state transitions', () {
      const idle = PaginationState();

      // Start loading
      final loading = idle.copyWith(isLoadingMore: true);
      expect(loading.isLoadingMore, isTrue);

      // Finish loading, increment page
      final loaded = loading.copyWith(
        isLoadingMore: false,
        currentPage: idle.currentPage + 1,
      );
      expect(loaded.isLoadingMore, isFalse);
      expect(loaded.currentPage, equals(2));

      // No more items
      final complete = loaded.copyWith(hasMoreItems: false);
      expect(complete.hasMoreItems, isFalse);
    });

    test('supports reset to initial state', () {
      const advanced = PaginationState(
        currentPage: 5,
        isLoadingMore: true,
        hasMoreItems: false,
      );

      final reset = advanced.copyWith(
        currentPage: 1,
        isLoadingMore: false,
        hasMoreItems: true,
      );

      expect(reset.currentPage, equals(1));
      expect(reset.isLoadingMore, isFalse);
      expect(reset.hasMoreItems, isTrue);
    });
  });
}
