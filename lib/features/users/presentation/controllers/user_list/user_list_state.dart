import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list_state.freezed.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState.initial() = UserListInitial;
  const factory UserListState.loading() = UserListLoading;
  const factory UserListState.success() = UserListSuccess;
  const factory UserListState.error(String message) = UserListError;
}
