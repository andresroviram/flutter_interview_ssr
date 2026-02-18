import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_filters_state.dart';

class UserFiltersNotifier extends Notifier<UserFiltersState> {
  @override
  UserFiltersState build() => const UserFiltersState();

  void updateFilters(UserFiltersState filters) {
    state = filters;
  }

  void resetFilters() {
    state = const UserFiltersState();
  }
}

final currentFiltersProvider =
    NotifierProvider<UserFiltersNotifier, UserFiltersState>(
      UserFiltersNotifier.new,
    );
