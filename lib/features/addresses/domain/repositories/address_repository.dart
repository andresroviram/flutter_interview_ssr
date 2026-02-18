import '../../../../core/result.dart';
import '../entities/address_entity.dart';

abstract class IAddressRepository {
  Future<Result<List<AddressEntity>>> getAddressesByUserId(int userId);

  Future<Result<AddressEntity>> getAddressById(int id);

  Future<Result<AddressEntity?>> getPrimaryAddress(int userId);

  Future<Result<AddressEntity>> createAddress(AddressEntity address);

  Future<Result<AddressEntity>> updateAddress(AddressEntity address);

  Future<Result<void>> deleteAddress(int id);

  Future<Result<void>> setPrimaryAddress(int userId, int addressId);
}
