import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../providers/user_providers.dart';
import 'user_list_state.dart';

class UserListNotifier extends Notifier<UserListState> {
  @override
  UserListState build() {
    return const UserListState.initial();
  }

  UserUseCases get _userUseCases => ref.read(userUseCasesProvider);

  Future<void> deleteUser({required int userId}) async {
    state = const UserListState.loading();

    final result = await _userUseCases.deleteUser(userId);

    result.fold(
      onSuccess: (_) {
        ref.invalidate(usersProvider);
        ref.invalidate(searchUsersProvider);
        ref.invalidate(filteredAndSortedUsersProvider);
        state = const UserListState.success();
      },
      onFailure: (error) {
        state = UserListState.error(error.message);
      },
    );
  }

  void reset() {
    state = const UserListState.initial();
  }
}

final userListNotifierProvider =
    NotifierProvider<UserListNotifier, UserListState>(UserListNotifier.new);
