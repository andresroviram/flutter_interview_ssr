import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserDataSource dataSource;

  const UserRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<UserEntity>>> getAllUsers() async {
    try {
      final users = await dataSource.getAllUsers();
      return Success(users);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<UserEntity>> getUserById(int id) async {
    try {
      final user = await dataSource.getUserById(id);
      if (user == null) {
        return const Failure(NotFoundFailure(message: 'Usuario no encontrado'));
      }
      return Success(user);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<UserEntity>> createUser(UserEntity user) async {
    try {
      final created = await dataSource.createUser(user);
      return Success(created);
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<UserEntity>> updateUser(UserEntity user) async {
    try {
      final updated = await dataSource.updateUser(user);
      return Success(updated);
    } on NotFoundException catch (e) {
      return Failure(NotFoundFailure(message: e.message));
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> deleteUser(int id) async {
    try {
      await dataSource.deleteUser(id);
      return const Success(null);
    } on NotFoundException catch (e) {
      return Failure(NotFoundFailure(message: e.message));
    } on StorageException catch (e) {
      return Failure(StorageFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUsers(String query) async {
    try {
      final users = await dataSource.searchUsers(query);
      return Success(users);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Result<bool>> emailExists(String email) async {
    try {
      final exists = await dataSource.emailExists(email);
      return Success(exists);
    } on StorageException catch (e) {
      return Failure(StorageReadFailure(message: e.message));
    } catch (e) {
      return Failure(UnknownFailure(message: 'Error inesperado: $e'));
    }
  }
}
