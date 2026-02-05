import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/usecases/address_usecases.dart';
import 'package:flutter_interview_ssr/features/addresses/presentation/providers/address_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../providers/user_providers.dart';
import '../search_query_notifier.dart';
import '../../../../addresses/domain/entities/address_entity.dart';
import 'user_form_state.dart';

class UserFormNotifier extends Notifier<UserFormState> {
  @override
  UserFormState build() {
    return const UserFormState.initial();
  }

  UserUseCases get _userUseCases => ref.read(userUseCasesProvider);
  AddressUseCases get _addressUseCases => ref.read(addressUseCasesProvider);

  Future<void> submitUserForm({
    required UserEntity user,
    required bool isUpdate,
    AddressEntity? initialAddress,
  }) async {
    state = const UserFormState.saving();

    final result = isUpdate
        ? await _userUseCases.updateUser(user)
        : await _userUseCases.createUser(user);

    result.fold(
      onSuccess: (savedUser) async {
        ref.read(searchQueryProvider.notifier).updateQuery('');

        ref.invalidate(usersProvider);
        ref.invalidate(searchUsersProvider);
        ref.invalidate(filteredAndSortedUsersProvider);
        if (isUpdate) {
          ref.invalidate(userByIdProvider(savedUser.id));
        }

        if (!isUpdate && initialAddress != null) {
          await _addressUseCases.createAddress(initialAddress);
          ref.invalidate(userAddressesProvider(savedUser.id));
        }

        state = UserFormState.success(savedUser);
      },
      onFailure: (error) {
        state = UserFormState.error(error.message);
      },
    );
  }

  void reset() {
    state = const UserFormState.initial();
  }
}

final userFormNotifierProvider =
    NotifierProvider<UserFormNotifier, UserFormState>(UserFormNotifier.new);
