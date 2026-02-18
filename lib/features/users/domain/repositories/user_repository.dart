import '../../../../core/result.dart';
import '../entities/user_entity.dart';

abstract class IUserRepository {
  Future<Result<List<UserEntity>>> getAllUsers();

  Future<Result<UserEntity>> getUserById(int id);

  Future<Result<UserEntity>> createUser(UserEntity user);

  Future<Result<UserEntity>> updateUser(UserEntity user);

  Future<Result<void>> deleteUser(int id);

  Future<Result<List<UserEntity>>> searchUsers(String query);

  Future<Result<bool>> emailExists(String email);
}
