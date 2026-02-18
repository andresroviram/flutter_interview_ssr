import 'package:equatable/equatable.dart';

class PaginateState<T> extends Equatable {
  final int currentPage;
  final int itemsPerPage;
  final List<T> displayedItems;
  final bool isLoading;

  const PaginateState({
    this.currentPage = 1,
    this.itemsPerPage = 20,
    this.displayedItems = const [],
    this.isLoading = false,
  });

  PaginateState<T> copyWith({
    int? currentPage,
    int? itemsPerPage,
    List<T>? displayedItems,
    bool? isLoading,
  }) {
    return PaginateState<T>(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      displayedItems: displayedItems ?? this.displayedItems,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  PaginateState<T> reset() {
    return PaginateState<T>(itemsPerPage: itemsPerPage);
  }

  @override
  List<Object?> get props => [
    currentPage,
    itemsPerPage,
    displayedItems,
    isLoading,
  ];
}
