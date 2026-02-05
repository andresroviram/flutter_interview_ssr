import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationState {
  final int currentPage;
  final int itemsPerPage;
  final bool isLoadingMore;
  final bool hasMoreItems;

  const PaginationState({
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.isLoadingMore = false,
    this.hasMoreItems = true,
  });

  PaginationState copyWith({
    int? currentPage,
    int? itemsPerPage,
    bool? isLoadingMore,
    bool? hasMoreItems,
  }) {
    return PaginationState(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
    );
  }
}

final paginationStateProvider = Provider<PaginationState>(
  (ref) => const PaginationState(),
);
