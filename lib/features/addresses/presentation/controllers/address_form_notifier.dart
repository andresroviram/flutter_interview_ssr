import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/result.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/address_usecases.dart';
import '../providers/address_providers.dart';
import 'address_form_state.dart';

class AddressFormNotifier extends Notifier<AddressFormState> {
  @override
  AddressFormState build() => const AddressFormState.initial();

  AddressUseCases get _useCases => ref.read(addressUseCasesProvider);

  Future<void> saveAddress({
    required AddressEntity address,
    required bool isUpdate,
    required String userId,
  }) async {
    state = const AddressFormState.saving();

    final result = isUpdate
        ? await _useCases.updateAddress(address)
        : await _useCases.createAddress(address);

    result.fold(
      onSuccess: (savedAddress) {
        ref.invalidate(userAddressesProvider(userId));
        state = AddressFormState.success(savedAddress);
      },
      onFailure: (error) {
        state = AddressFormState.error(error.message);
      },
    );
  }

  Future<void> deleteAddress({
    required String addressId,
    required String userId,
  }) async {
    state = const AddressFormState.saving();

    final result = await _useCases.deleteAddress(addressId);

    result.fold(
      onSuccess: (_) {
        ref.invalidate(userAddressesProvider(userId));
        state = const AddressFormState.success();
      },
      onFailure: (error) {
        state = AddressFormState.error(error.message);
      },
    );
  }

  Future<void> setPrimaryAddress({
    required AddressEntity address,
    required String userId,
  }) async {
    state = const AddressFormState.saving();

    final updatedAddress = address.copyWith(isPrimary: true);
    final result = await _useCases.updateAddress(updatedAddress);

    result.fold(
      onSuccess: (savedAddress) {
        ref.invalidate(userAddressesProvider(userId));
        state = AddressFormState.success(savedAddress);
      },
      onFailure: (error) {
        state = AddressFormState.error(error.message);
      },
    );
  }

  void reset() => state = const AddressFormState.initial();
}

final addressFormNotifierProvider =
    NotifierProvider<AddressFormNotifier, AddressFormState>(
      AddressFormNotifier.new,
    );
