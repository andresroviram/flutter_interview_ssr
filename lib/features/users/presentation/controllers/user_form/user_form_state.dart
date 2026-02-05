import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_form_state.freezed.dart';

@freezed
class UserFormState with _$UserFormState {
  const factory UserFormState.initial() = UserFormInitial;
  const factory UserFormState.saving() = UserFormSaving;
  const factory UserFormState.success([UserEntity? user]) = UserFormSuccess;
  const factory UserFormState.error(String message) = UserFormError;
}
