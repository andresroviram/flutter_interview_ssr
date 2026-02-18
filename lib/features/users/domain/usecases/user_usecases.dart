import '../../../../core/error/failures.dart';
import '../../../../core/result.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UserUseCases {
  final IUserRepository repository;

  const UserUseCases(this.repository);

  Future<Result<List<UserEntity>>> getAllUsers() {
    return repository.getAllUsers();
  }

  Future<Result<UserEntity>> getUserById(int id) {
    return repository.getUserById(id);
  }

  Future<Result<UserEntity>> createUser(UserEntity user) async {
    final emailExistsResult = await repository.emailExists(user.email);

    return emailExistsResult.fold(
      onSuccess: (exists) {
        if (exists) {
          return Failure(
            ValidationFailure(message: 'El email ya está registrado'),
          );
        }
        return repository.createUser(user);
      },
      onFailure: (error) => Failure(error),
    );
  }

  Future<Result<UserEntity>> updateUser(UserEntity user) {
    return repository.updateUser(user);
  }

  Future<Result<void>> deleteUser(int id) {
    return repository.deleteUser(id);
  }

  Future<Result<List<UserEntity>>> searchUsers(String query) {
    if (query.trim().isEmpty) {
      return getAllUsers();
    }
    return repository.searchUsers(query);
  }

  Future<Result<bool>> isEmailAvailable(String email) async {
    final result = await repository.emailExists(email);
    return result.map((exists) => !exists);
  }
}
