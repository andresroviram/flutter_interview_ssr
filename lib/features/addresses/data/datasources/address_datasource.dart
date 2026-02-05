import '../../domain/entities/address_entity.dart';

abstract class IAddressDataSource {
  Future<List<AddressEntity>> getAddressesByUserId(String userId);

  Future<AddressEntity?> getAddressById(String id);

  Future<AddressEntity?> getPrimaryAddress(String userId);

  Future<AddressEntity> createAddress(AddressEntity address);

  Future<AddressEntity> updateAddress(AddressEntity address);

  Future<void> deleteAddress(String id);

  Future<void> setPrimaryAddress(String userId, String addressId);
}
