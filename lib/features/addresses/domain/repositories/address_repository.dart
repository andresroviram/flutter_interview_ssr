import '../../../../core/result.dart';
import '../entities/address_entity.dart';

abstract class IAddressRepository {
  Future<Result<List<AddressEntity>>> getAddressesByUserId(String userId);

  Future<Result<AddressEntity>> getAddressById(String id);

  Future<Result<AddressEntity?>> getPrimaryAddress(String userId);

  Future<Result<AddressEntity>> createAddress(AddressEntity address);

  Future<Result<AddressEntity>> updateAddress(AddressEntity address);

  Future<Result<void>> deleteAddress(String id);

  Future<Result<void>> setPrimaryAddress(String userId, String addressId);
}
