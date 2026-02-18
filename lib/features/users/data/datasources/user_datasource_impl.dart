import 'package:drift/drift.dart' as drift;
import 'package:flutter_interview_ssr/core/database/tables/users_table.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import 'user_datasource.dart';

class UserDataSourceImpl implements IUserDataSource {
  final AppDatabase _database;

  UserDataSourceImpl({required AppDatabase database}) : _database = database;

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final users = await _database.select(_database.users).get();
      final entities = users.map((user) => user.toEntity()).toList();
      entities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entities;
    } catch (e) {
      throw StorageException(message: 'Error al obtener usuarios: $e');
    }
  }

  @override
  Future<UserEntity?> getUserById(int id) async {
    try {
      final query = _database.select(_database.users)
        ..where((tbl) => tbl.id.equals(id));
      final user = await query.getSingleOrNull();
      return user?.toEntity();
    } catch (e) {
      throw StorageException(message: 'Error al obtener usuario: $e');
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      final id = await _database.into(_database.users).insert(
            UsersCompanion.insert(
              firstName: user.firstName,
              lastName: user.lastName,
              birthDate: user.birthDate,
              email: user.email,
              phone: user.phone,
              createdAt: user.createdAt,
              updatedAt: drift.Value(user.updatedAt),
            ),
          );

      return UserEntity(
        id: id,
        firstName: user.firstName,
        lastName: user.lastName,
        birthDate: user.birthDate,
        email: user.email,
        phone: user.phone,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
    } catch (e) {
      throw StorageException(message: 'Error al crear usuario: $e');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    try {
      final existing = await getUserById(user.id);
      if (existing == null) {
        throw NotFoundException(message: 'Usuario no encontrado');
      }

      await (_database.update(
        _database.users,
      )..where((tbl) => tbl.id.equals(user.id)))
          .write(
        UsersCompanion(
          firstName: drift.Value(user.firstName),
          lastName: drift.Value(user.lastName),
          birthDate: drift.Value(user.birthDate),
          email: drift.Value(user.email),
          phone: drift.Value(user.phone),
          updatedAt: drift.Value(user.updatedAt),
        ),
      );

      return user;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al actualizar usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      final existing = await getUserById(id);
      if (existing == null) {
        throw NotFoundException(message: 'Usuario no encontrado');
      }

      await (_database.delete(
        _database.users,
      )..where((tbl) => tbl.id.equals(id)))
          .go();
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al eliminar usuario: $e');
    }
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    try {
      final lowerQuery = query.toLowerCase();

      final allUsers = await getAllUsers();
      final filtered = allUsers.where((user) {
        return user.firstName.toLowerCase().contains(lowerQuery) ||
            user.lastName.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            user.fullName.toLowerCase().contains(lowerQuery);
      }).toList();

      filtered.sort((a, b) {
        final aStartsWith = a.fullName.toLowerCase().startsWith(lowerQuery);
        final bStartsWith = b.fullName.toLowerCase().startsWith(lowerQuery);
        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;
        return a.fullName.compareTo(b.fullName);
      });

      return filtered;
    } catch (e) {
      throw StorageException(message: 'Error al buscar usuarios: $e');
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final query = _database.select(_database.users)
        ..where((tbl) => tbl.email.lower().equals(email.toLowerCase()));
      final user = await query.getSingleOrNull();
      return user != null;
    } catch (e) {
      throw StorageException(message: 'Error al verificar email: $e');
    }
  }
}
