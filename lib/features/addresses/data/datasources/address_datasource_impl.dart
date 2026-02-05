import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/box_converter.dart';
import '../../domain/entities/address_entity.dart';
import '../models/address_model.dart';
import 'address_datasource.dart';

class AddressDataSourceImpl implements IAddressDataSource {
  static const String _boxName = 'addresses';
  late Box<Map> _box;
  bool _isInitialized = false;

  AddressDataSourceImpl({Box<Map>? box}) {
    if (box != null) {
      _box = box;
      _isInitialized = true;
    }
  }

  Future<void> init() async {
    if (!_isInitialized) {
      _box = await Hive.openBox<Map>(_boxName);
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  @override
  Future<List<AddressEntity>> getAddressesByUserId(String userId) async {
    try {
      await _ensureInitialized();

      final addresses = _box.values.toEntityListWhere<AddressEntity>(
        callback: (json) => AddressModel.fromJson(json).toEntity(),
        test: (address) => address.userId == userId,
      );

      addresses.sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return addresses;
    } catch (e) {
      throw StorageException(message: 'Error al obtener direcciones: $e');
    }
  }

  @override
  Future<AddressEntity?> getAddressById(String id) async {
    try {
      await _ensureInitialized();

      return _box
          .get(id)
          .toEntityOrNull<AddressEntity>(
            callback: (json) => AddressModel.fromJson(json).toEntity(),
          );
    } catch (e) {
      throw StorageException(message: 'Error al obtener dirección: $e');
    }
  }

  @override
  Future<AddressEntity?> getPrimaryAddress(String userId) async {
    try {
      await _ensureInitialized();

      final addresses = await getAddressesByUserId(userId);

      for (final address in addresses) {
        if (address.isPrimary) return address;
      }

      return null;
    } catch (e) {
      throw StorageException(
        message: 'Error al obtener dirección principal: $e',
      );
    }
  }

  @override
  Future<AddressEntity> createAddress(AddressEntity address) async {
    try {
      await _ensureInitialized();

      final model = address.toModel();
      await _box.put(address.id, model.toJson());

      return address;
    } catch (e) {
      throw StorageException(message: 'Error al crear dirección: $e');
    }
  }

  @override
  Future<AddressEntity> updateAddress(AddressEntity address) async {
    try {
      await _ensureInitialized();

      if (!_box.containsKey(address.id)) {
        throw NotFoundException(message: 'Dirección no encontrada');
      }

      final model = address.toModel();
      await _box.put(address.id, model.toJson());

      return address;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al actualizar dirección: $e');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await _ensureInitialized();

      if (!_box.containsKey(id)) {
        throw NotFoundException(message: 'Dirección no encontrada');
      }

      await _box.delete(id);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al eliminar dirección: $e');
    }
  }

  @override
  Future<void> setPrimaryAddress(String userId, String addressId) async {
    try {
      await _ensureInitialized();

      final addresses = await getAddressesByUserId(userId);

      for (final address in addresses) {
        final updated = address.copyWith(
          isPrimary: address.id == addressId,
          updatedAt: DateTime.now(),
        );
        final model = updated.toModel();
        await _box.put(address.id, model.toJson());
      }
    } catch (e) {
      throw StorageException(
        message: 'Error al establecer dirección principal: $e',
      );
    }
  }

  Future<void> clear() async {
    await _ensureInitialized();
    await _box.clear();
  }

  Future<void> close() async {
    if (_isInitialized) {
      await _box.close();
      _isInitialized = false;
    }
  }
}
