import '../../../../core/result.dart';
import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class AddressUseCases {
  final IAddressRepository repository;

  const AddressUseCases(this.repository);

  Future<Result<List<AddressEntity>>> getAddressesByUserId(String userId) {
    return repository.getAddressesByUserId(userId);
  }

  Future<Result<AddressEntity>> getAddressById(String id) {
    return repository.getAddressById(id);
  }

  Future<Result<AddressEntity?>> getPrimaryAddress(String userId) {
    return repository.getPrimaryAddress(userId);
  }

  Future<Result<AddressEntity>> createAddress(AddressEntity address) async {
    final existingAddresses = await repository.getAddressesByUserId(
      address.userId,
    );

    return existingAddresses.fold(
      onSuccess: (addresses) {
        final newAddress = addresses.isEmpty
            ? address.copyWith(isPrimary: true)
            : address;

        if (newAddress.isPrimary && addresses.isNotEmpty) {
          return _createAndSetPrimary(newAddress);
        }

        return repository.createAddress(newAddress);
      },
      onFailure: (error) => Failure(error),
    );
  }

  Future<Result<AddressEntity>> updateAddress(AddressEntity address) async {
    if (address.isPrimary) {
      final setPrimaryResult = await repository.setPrimaryAddress(
        address.userId,
        address.id,
      );

      return setPrimaryResult.fold(
        onSuccess: (_) => repository.updateAddress(address),
        onFailure: (error) => Failure(error),
      );
    }

    return repository.updateAddress(address);
  }

  Future<Result<void>> deleteAddress(String addressId) async {
    final addressResult = await repository.getAddressById(addressId);

    return addressResult.fold(
      onSuccess: (address) async {
        if (address.isPrimary) {
          final allAddresses = await repository.getAddressesByUserId(
            address.userId,
          );

          return allAddresses.fold(
            onSuccess: (addresses) async {
              if (addresses.length == 1) {
                return repository.deleteAddress(addressId);
              }

              await repository.deleteAddress(addressId);
              final nextAddress = addresses.firstWhere(
                (a) => a.id != addressId,
              );
              await repository.setPrimaryAddress(
                address.userId,
                nextAddress.id,
              );

              return const Success(null);
            },
            onFailure: (error) => Failure(error),
          );
        }

        return repository.deleteAddress(addressId);
      },
      onFailure: (error) => Failure(error),
    );
  }

  Future<Result<void>> setPrimaryAddress(String userId, String addressId) {
    return repository.setPrimaryAddress(userId, addressId);
  }

  Future<Result<AddressEntity>> _createAndSetPrimary(
    AddressEntity address,
  ) async {
    final createResult = await repository.createAddress(address);

    return createResult.fold(
      onSuccess: (created) async {
        await repository.setPrimaryAddress(address.userId, created.id);
        return Success(created);
      },
      onFailure: (error) => Failure(error),
    );
  }
}
