import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../components/widgets/pagination/pagination.dart';
import 'paginate_state.dart';

class PaginateNotifier<T> extends Notifier<PaginateState<T>> {
  @override
  PaginateState<T> build() => PaginateState<T>();

  void loadInitialPage(List<T> allItems) {
    state = state.copyWith(
      currentPage: 1,
      displayedItems: allItems.paginate(1, state.itemsPerPage),
    );
  }

  Future<void> loadMoreItems(List<T> allItems) async {
    if (!allItems.hasMorePages(state.currentPage, state.itemsPerPage)) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final nextPage = state.currentPage + 1;
    final nextPageItems = allItems.paginate(nextPage, state.itemsPerPage);

    state = state.copyWith(
      currentPage: nextPage,
      displayedItems: [...state.displayedItems, ...nextPageItems],
      isLoading: false,
    );
  }

  void reset(List<T> allItems) {
    state = state.reset();
    loadInitialPage(allItems);
  }

  void resetPagination() {
    state = state.reset();
  }
}

final usersPaginateProvider =
    NotifierProvider<PaginateNotifier<UserEntity>, PaginateState<UserEntity>>(
      PaginateNotifier<UserEntity>.new,
    );
