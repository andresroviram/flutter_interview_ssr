import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/box_converter.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'user_datasource.dart';

class UserDataSourceImpl implements IUserDataSource {
  static const String _boxName = 'users';
  late Box<Map> _box;
  bool _isInitialized = false;

  UserDataSourceImpl({Box<Map>? box}) {
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
  Future<List<UserEntity>> getAllUsers() async {
    try {
      await _ensureInitialized();

      final users = _box.values.toEntityList<UserEntity>(
        callback: (json) => UserModel.fromJson(json).toEntity(),
      );

      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return users;
    } catch (e) {
      throw StorageException(message: 'Error al obtener usuarios: $e');
    }
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    try {
      await _ensureInitialized();

      return _box
          .get(id)
          .toEntityOrNull<UserEntity>(
            callback: (json) => UserModel.fromJson(json).toEntity(),
          );
    } catch (e) {
      throw StorageException(message: 'Error al obtener usuario: $e');
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      await _ensureInitialized();

      final model = user.toModel();
      await _box.put(user.id, model.toJson());

      return user;
    } catch (e) {
      throw StorageException(message: 'Error al crear usuario: $e');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    try {
      await _ensureInitialized();

      if (!_box.containsKey(user.id)) {
        throw NotFoundException(message: 'Usuario no encontrado');
      }

      final model = user.toModel();
      await _box.put(user.id, model.toJson());

      return user;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al actualizar usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _ensureInitialized();

      if (!_box.containsKey(id)) {
        throw NotFoundException(message: 'Usuario no encontrado');
      }

      await _box.delete(id);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException(message: 'Error al eliminar usuario: $e');
    }
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    try {
      await _ensureInitialized();

      final lowerQuery = query.toLowerCase();

      final users = _box.values.toEntityListWhere<UserEntity>(
        callback: (json) => UserModel.fromJson(json).toEntity(),
        test: (user) {
          return user.firstName.toLowerCase().contains(lowerQuery) ||
              user.lastName.toLowerCase().contains(lowerQuery) ||
              user.email.toLowerCase().contains(lowerQuery) ||
              user.fullName.toLowerCase().contains(lowerQuery);
        },
      );

      users.sort((a, b) {
        final aStartsWith = a.fullName.toLowerCase().startsWith(lowerQuery);
        final bStartsWith = b.fullName.toLowerCase().startsWith(lowerQuery);
        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;
        return a.fullName.compareTo(b.fullName);
      });

      return users;
    } catch (e) {
      throw StorageException(message: 'Error al buscar usuarios: $e');
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      await _ensureInitialized();

      return _box.values.anyEntity<UserEntity>(
        callback: (json) => UserModel.fromJson(json).toEntity(),
        test: (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      throw StorageException(message: 'Error al verificar email: $e');
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
