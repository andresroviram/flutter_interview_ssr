import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';
import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/features/users/data/datasources/user_datasource.dart';
import 'package:flutter_interview_ssr/features/users/data/repositories/user_repository_impl.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';

class MockUserDataSource extends Mock implements IUserDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserDataSource();
    repository = UserRepositoryImpl(mockDataSource);
  });

  final testUser = UserEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    birthDate: DateTime(1990, 1, 1),
    email: 'john@example.com',
    phone: '1234567890',
    createdAt: DateTime(2024, 1, 1),
  );

  group('getAllUsers', () {
    test('should return Success with users list', () async {
      when(
        () => mockDataSource.getAllUsers(),
      ).thenAnswer((_) async => [testUser]);

      final result = await repository.getAllUsers();

      expect(result, isA<Success<List<UserEntity>>>());
      expect((result as Success).value, [testUser]);
      verify(() => mockDataSource.getAllUsers()).called(1);
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.getAllUsers(),
      ).thenThrow(const StorageException(message: 'Storage error'));

      final result = await repository.getAllUsers();

      expect(result, isA<Failure<List<UserEntity>>>());
      final failure = (result as Failure).error;
      expect(failure, isA<StorageReadFailure>());
      expect(failure.message, 'Storage error');
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(() => mockDataSource.getAllUsers()).thenThrow(Exception('Boom'));

      final result = await repository.getAllUsers();

      expect(result, isA<Failure<List<UserEntity>>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('getUserById', () {
    test('should return Success with user when found', () async {
      when(
        () => mockDataSource.getUserById('1'),
      ).thenAnswer((_) async => testUser);

      final result = await repository.getUserById('1');

      expect(result, isA<Success<UserEntity>>());
      expect((result as Success).value, testUser);
      verify(() => mockDataSource.getUserById('1')).called(1);
    });

    test('should return NotFoundFailure when user is null', () async {
      when(() => mockDataSource.getUserById('1')).thenAnswer((_) async => null);

      final result = await repository.getUserById('1');

      expect(result, isA<Failure<UserEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'Usuario no encontrado');
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.getUserById('1'),
      ).thenThrow(const StorageException(message: 'Read error'));

      final result = await repository.getUserById('1');

      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).error, isA<StorageReadFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(() => mockDataSource.getUserById('1')).thenThrow(Exception('Boom'));

      final result = await repository.getUserById('1');

      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('createUser', () {
    test('should return Success with created user', () async {
      when(
        () => mockDataSource.createUser(testUser),
      ).thenAnswer((_) async => testUser);

      final result = await repository.createUser(testUser);

      expect(result, isA<Success<UserEntity>>());
      expect((result as Success).value, testUser);
      verify(() => mockDataSource.createUser(testUser)).called(1);
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.createUser(testUser),
      ).thenThrow(const StorageException(message: 'Create error'));

      final result = await repository.createUser(testUser);

      expect(result, isA<Failure<UserEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<StorageFailure>());
      expect(failure.message, 'Create error');
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.createUser(testUser),
      ).thenThrow(Exception('Boom'));

      final result = await repository.createUser(testUser);

      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('updateUser', () {
    test('should return Success with updated user', () async {
      when(
        () => mockDataSource.updateUser(testUser),
      ).thenAnswer((_) async => testUser);

      final result = await repository.updateUser(testUser);

      expect(result, isA<Success<UserEntity>>());
      expect((result as Success).value, testUser);
      verify(() => mockDataSource.updateUser(testUser)).called(1);
    });

    test('should return NotFoundFailure on NotFoundException', () async {
      when(
        () => mockDataSource.updateUser(testUser),
      ).thenThrow(const NotFoundException(message: 'User not found'));

      final result = await repository.updateUser(testUser);

      expect(result, isA<Failure<UserEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'User not found');
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.updateUser(testUser),
      ).thenThrow(const StorageException(message: 'Update error'));

      final result = await repository.updateUser(testUser);

      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).error, isA<StorageFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.updateUser(testUser),
      ).thenThrow(Exception('Boom'));

      final result = await repository.updateUser(testUser);

      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('deleteUser', () {
    test('should return Success when deletion succeeds', () async {
      when(() => mockDataSource.deleteUser('1')).thenAnswer((_) async => {});

      final result = await repository.deleteUser('1');

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.deleteUser('1')).called(1);
    });

    test('should return NotFoundFailure on NotFoundException', () async {
      when(
        () => mockDataSource.deleteUser('1'),
      ).thenThrow(const NotFoundException(message: 'User not found'));

      final result = await repository.deleteUser('1');

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<NotFoundFailure>());
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.deleteUser('1'),
      ).thenThrow(const StorageException(message: 'Delete error'));

      final result = await repository.deleteUser('1');

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<StorageFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(() => mockDataSource.deleteUser('1')).thenThrow(Exception('Boom'));

      final result = await repository.deleteUser('1');

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('searchUsers', () {
    test('should return Success with matching users', () async {
      when(
        () => mockDataSource.searchUsers('john'),
      ).thenAnswer((_) async => [testUser]);

      final result = await repository.searchUsers('john');

      expect(result, isA<Success<List<UserEntity>>>());
      expect((result as Success).value, [testUser]);
      verify(() => mockDataSource.searchUsers('john')).called(1);
    });

    test('should return empty list when no matches found', () async {
      when(() => mockDataSource.searchUsers('xyz')).thenAnswer((_) async => []);

      final result = await repository.searchUsers('xyz');

      expect(result, isA<Success<List<UserEntity>>>());
      expect((result as Success).value, isEmpty);
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.searchUsers('john'),
      ).thenThrow(const StorageException(message: 'Search error'));

      final result = await repository.searchUsers('john');

      expect(result, isA<Failure<List<UserEntity>>>());
      expect((result as Failure).error, isA<StorageReadFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.searchUsers('john'),
      ).thenThrow(Exception('Boom'));

      final result = await repository.searchUsers('john');

      expect(result, isA<Failure<List<UserEntity>>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('emailExists', () {
    test('should return Success with true when email exists', () async {
      when(
        () => mockDataSource.emailExists('john@example.com'),
      ).thenAnswer((_) async => true);

      final result = await repository.emailExists('john@example.com');

      expect(result, isA<Success<bool>>());
      expect((result as Success).value, true);
      verify(() => mockDataSource.emailExists('john@example.com')).called(1);
    });

    test(
      'should return Success with false when email does not exist',
      () async {
        when(
          () => mockDataSource.emailExists('new@example.com'),
        ).thenAnswer((_) async => false);

        final result = await repository.emailExists('new@example.com');

        expect(result, isA<Success<bool>>());
        expect((result as Success).value, false);
      },
    );

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.emailExists('test@example.com'),
      ).thenThrow(const StorageException(message: 'Check error'));

      final result = await repository.emailExists('test@example.com');

      expect(result, isA<Failure<bool>>());
      expect((result as Failure).error, isA<StorageReadFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.emailExists('test@example.com'),
      ).thenThrow(Exception('Boom'));

      final result = await repository.emailExists('test@example.com');

      expect(result, isA<Failure<bool>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });
}
