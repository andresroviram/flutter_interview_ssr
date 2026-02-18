import 'package:drift/drift.dart' as drift;
import 'package:flutter_interview_ssr/core/database/tables/addresses_table.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/address_entity.dart';
import 'address_datasource.dart';

class AddressDataSourceImpl implements IAddressDataSource {
  final AppDatabase _database;

  AddressDataSourceImpl({required AppDatabase database}) : _database = database;

  @override
  Future<List<AddressEntity>> getAddressesByUserId(int userId) async {
    try {
      final query = _database.select(_database.addresses)
        ..where((tbl) => tbl.userId.equals(userId));
      final addresses = await query.get();
      final entities = addresses.map((address) => address.toEntity()).toList();

      entities.sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return entities;
    } catch (e) {
      throw StorageException(message: 'Error al obtener direcciones: $e');
    }
  }

  @override
  Future<AddressEntity?> getAddressById(int id) async {
    try {
      final query = _database.select(_database.addresses)
        ..where((tbl) => tbl.id.equals(id));
      final address = await query.getSingleOrNull();
      return address?.toEntity();
    } catch (e) {
      throw StorageException(message: 'Error al obtener dirección: $e');
    }
  }

  @override
  Future<AddressEntity?> getPrimaryAddress(int userId) async {
    try {
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
      final id = await _database.into(_database.addresses).insert(
            AddressesCompanion.insert(
              userId: address.userId,
              street: address.street,
              neighborhood: address.neighborhood,
              city: address.city,
              state: address.state,
              postalCode: address.postalCode,
              label: address.label.name,
              isPrimary: address.isPrimary,
              createdAt: address.createdAt,
              updatedAt: drift.Value(address.updatedAt),
            ),
          );

      return AddressEntity(
        id: id,
        userId: address.userId,
        street: address.street,
        neighborhood: address.neighborhood,
        city: address.city,
        state: address.state,
        postalCode: address.postalCode,
        label: address.label,
        isPrimary: address.isPrimary,
        createdAt: address.createdAt,
        updatedAt: address.updatedAt,
      );
    } catch (e) {
      throw StorageException(message: 'Error al crear dirección: $e');
    }
  }

  @override
  Future<AddressEntity> updateAddress(AddressEntity address) async {
    try {
      final existing = await getAddressById(address.id);
      if (existing == null) {
        throw NotFoundException(message: 'Dirección no encontrada');
      }

      await (_database.update(
        _database.addresses,
      )..where((tbl) => tbl.id.equals(address.id)))
          .write(
        AddressesCompanion(
          userId: drift.Value(address.userId),
          street: drift.Value(address.street),
          neighborhood: drift.Value(address.neighborhood),
          city: drift.Value(address.city),
          state: drift.Value(address.state),
          postalCode: drift.Value(address.postalCode),
          label: drift.Value(address.label.name),
          isPrimary: drift.Value(address.isPrimary),
          updatedAt: drift.Value(address.updatedAt),
        ),
      );

      return address;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al actualizar dirección: $e');
    }
  }

  @override
  Future<void> deleteAddress(int id) async {
    try {
      final existing = await getAddressById(id);
      if (existing == null) {
        throw NotFoundException(message: 'Dirección no encontrada');
      }

      await (_database.delete(
        _database.addresses,
      )..where((tbl) => tbl.id.equals(id)))
          .go();
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al eliminar dirección: $e');
    }
  }

  @override
  Future<void> setPrimaryAddress(int userId, int addressId) async {
    try {
      final addresses = await getAddressesByUserId(userId);

      for (final address in addresses) {
        final updated = address.copyWith(
          isPrimary: address.id == addressId,
          updatedAt: DateTime.now(),
        );

        await (_database.update(
          _database.addresses,
        )..where((tbl) => tbl.id.equals(address.id)))
            .write(
          AddressesCompanion(
            isPrimary: drift.Value(updated.isPrimary),
            updatedAt: drift.Value(updated.updatedAt),
          ),
        );
      }
    } catch (e) {
      throw StorageException(
        message: 'Error al establecer dirección principal: $e',
      );
    }
  }
}
