import '../../domain/entities/address_entity.dart';

abstract class IAddressDataSource {
  Future<List<AddressEntity>> getAddressesByUserId(int userId);

  Future<AddressEntity?> getAddressById(int id);

  Future<AddressEntity?> getPrimaryAddress(int userId);

  Future<AddressEntity> createAddress(AddressEntity address);

  Future<AddressEntity> updateAddress(AddressEntity address);

  Future<void> deleteAddress(int id);

  Future<void> setPrimaryAddress(int userId, int addressId);
}
