import '../../domain/entities/user_entity.dart';

abstract class IUserDataSource {
  Future<List<UserEntity>> getAllUsers();

  Future<UserEntity?> getUserById(int id);

  Future<UserEntity> createUser(UserEntity user);

  Future<UserEntity> updateUser(UserEntity user);

  Future<void> deleteUser(int id);

  Future<List<UserEntity>> searchUsers(String query);

  Future<bool> emailExists(String email);
}
