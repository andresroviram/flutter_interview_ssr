import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_datasource.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final IAddressDataSource dataSource;

  const AddressRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<AddressEntity>>> getAddressesByUserId(int userId) async {
    try {
      final addresses = await dataSource.getAddressesByUserId(userId);
      return Success(addresses);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<AddressEntity>> getAddressById(int id) async {
    try {
      final address = await dataSource.getAddressById(id);
      if (address == null) {
        return const Failure(
          NotFoundFailure(message: 'Dirección no encontrada'),
        );
      }
      return Success(address);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<AddressEntity?>> getPrimaryAddress(int userId) async {
    try {
      final address = await dataSource.getPrimaryAddress(userId);
      return Success(address);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<AddressEntity>> createAddress(AddressEntity address) async {
    try {
      final created = await dataSource.createAddress(address);
      return Success(created);
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<AddressEntity>> updateAddress(AddressEntity address) async {
    try {
      final updated = await dataSource.updateAddress(address);
      return Success(updated);
    } on NotFoundException catch (e) {
      return Failure(NotFoundFailure(message: e.message));
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAddress(int id) async {
    try {
      await dataSource.deleteAddress(id);
      return const Success(null);
    } on NotFoundException catch (e) {
      return Failure(NotFoundFailure(message: e.message));
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> setPrimaryAddress(int userId, int addressId) async {
    try {
      await dataSource.setPrimaryAddress(userId, addressId);
      return const Success(null);
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }
}
