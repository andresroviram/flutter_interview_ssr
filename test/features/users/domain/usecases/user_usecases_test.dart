import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';
import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_interview_ssr/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_interview_ssr/features/users/domain/usecases/user_usecases.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late UserUseCases useCases;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCases = UserUseCases(mockRepository);
  });

  final testUser = UserEntity(
    id: 123,
    firstName: 'John',
    lastName: 'Doe',
    birthDate: DateTime(1990, 5, 20),
    email: 'john.doe@example.com',
    phone: '1234567890',
    createdAt: DateTime(2024, 1, 15),
    updatedAt: null,
  );

  final testUsers = [
    testUser,
    UserEntity(
      id: 456,
      firstName: 'Jane',
      lastName: 'Smith',
      birthDate: DateTime(1992, 8, 10),
      email: 'jane.smith@example.com',
      phone: '9876543210',
      createdAt: DateTime(2024, 1, 16),
      updatedAt: null,
    ),
  ];

  group('UserUseCases.getAllUsers', () {
    test('should return list of users from repository', () async {
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Success(testUsers));

      final result = await useCases.getAllUsers();

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testUsers);
      verify(() => mockRepository.getAllUsers()).called(1);
    });

    test('should return failure when repository fails', () async {
      final failure = StorageFailure(message: 'Storage error');
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.getAllUsers();

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('UserUseCases.getUserById', () {
    test('should return user when found', () async {
      when(
        () => mockRepository.getUserById(123),
      ).thenAnswer((_) async => Success(testUser));

      final result = await useCases.getUserById(123);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testUser);
      verify(() => mockRepository.getUserById(123)).called(1);
    });

    test('should return failure when user not found', () async {
      final failure = NotFoundFailure(message: 'User not found');
      when(
        () => mockRepository.getUserById(999),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.getUserById(999);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('UserUseCases.createUser', () {
    test('should create user when email does not exist', () async {
      when(
        () => mockRepository.emailExists(testUser.email),
      ).thenAnswer((_) async => const Success(false));
      when(
        () => mockRepository.createUser(testUser),
      ).thenAnswer((_) async => Success(testUser));

      final result = await useCases.createUser(testUser);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testUser);
      verify(() => mockRepository.emailExists(testUser.email)).called(1);
      verify(() => mockRepository.createUser(testUser)).called(1);
    });

    test(
      'should return validation failure when email already exists',
      () async {
        when(
          () => mockRepository.emailExists(testUser.email),
        ).thenAnswer((_) async => const Success(true));

        final result = await useCases.createUser(testUser);

        expect(result.isFailure, true);
        expect(result.errorOrNull, isA<ValidationFailure>());
        expect(result.errorOrNull?.message, 'El email ya está registrado');
        verify(() => mockRepository.emailExists(testUser.email)).called(1);
        verifyNever(() => mockRepository.createUser(testUser));
      },
    );

    test('should return failure when emailExists check fails', () async {
      final failure = StorageFailure(message: 'Storage error');
      when(
        () => mockRepository.emailExists(testUser.email),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.createUser(testUser);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
      verifyNever(() => mockRepository.createUser(testUser));
    });
  });

  group('UserUseCases.updateUser', () {
    test('should update user successfully', () async {
      final updatedUser = UserEntity(
        id: testUser.id,
        firstName: 'Johnny',
        lastName: testUser.lastName,
        birthDate: testUser.birthDate,
        email: testUser.email,
        phone: testUser.phone,
        createdAt: testUser.createdAt,
        updatedAt: DateTime(2024, 2, 10),
      );
      when(
        () => mockRepository.updateUser(updatedUser),
      ).thenAnswer((_) async => Success(updatedUser));

      final result = await useCases.updateUser(updatedUser);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, updatedUser);
      verify(() => mockRepository.updateUser(updatedUser)).called(1);
    });

    test('should return failure when update fails', () async {
      final failure = StorageFailure(message: 'Update failed');
      when(
        () => mockRepository.updateUser(testUser),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.updateUser(testUser);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('UserUseCases.deleteUser', () {
    test('should delete user successfully', () async {
      when(
        () => mockRepository.deleteUser(123),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCases.deleteUser(123);

      expect(result.isSuccess, true);
      verify(() => mockRepository.deleteUser(123)).called(1);
    });

    test('should return failure when delete fails', () async {
      final failure = StorageFailure(message: 'Delete failed');
      when(
        () => mockRepository.deleteUser(123),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.deleteUser(123);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('UserUseCases.searchUsers', () {
    test('should return all users when query is empty', () async {
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Success(testUsers));

      final result = await useCases.searchUsers('');

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testUsers);
      verify(() => mockRepository.getAllUsers()).called(1);
      verifyNever(() => mockRepository.searchUsers(any()));
    });

    test('should return all users when query is whitespace', () async {
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Success(testUsers));

      final result = await useCases.searchUsers('   ');

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testUsers);
      verify(() => mockRepository.getAllUsers()).called(1);
      verifyNever(() => mockRepository.searchUsers(any()));
    });

    test('should search users when query is not empty', () async {
      final searchResults = [testUser];
      when(
        () => mockRepository.searchUsers('John'),
      ).thenAnswer((_) async => Success(searchResults));

      final result = await useCases.searchUsers('John');

      expect(result.isSuccess, true);
      expect(result.valueOrNull, searchResults);
      verify(() => mockRepository.searchUsers('John')).called(1);
      verifyNever(() => mockRepository.getAllUsers());
    });

    test('should return failure when search fails', () async {
      final failure = StorageFailure(message: 'Search failed');
      when(
        () => mockRepository.searchUsers('John'),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.searchUsers('John');

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('UserUseCases.isEmailAvailable', () {
    test('should return true when email does not exist', () async {
      when(
        () => mockRepository.emailExists('new@example.com'),
      ).thenAnswer((_) async => const Success(false));

      final result = await useCases.isEmailAvailable('new@example.com');

      expect(result.isSuccess, true);
      expect(result.valueOrNull, true);
      verify(() => mockRepository.emailExists('new@example.com')).called(1);
    });

    test('should return false when email already exists', () async {
      when(
        () => mockRepository.emailExists('existing@example.com'),
      ).thenAnswer((_) async => const Success(true));

      final result = await useCases.isEmailAvailable('existing@example.com');

      expect(result.isSuccess, true);
      expect(result.valueOrNull, false);
      verify(
        () => mockRepository.emailExists('existing@example.com'),
      ).called(1);
    });

    test('should return failure when check fails', () async {
      final failure = StorageFailure(message: 'Check failed');
      when(
        () => mockRepository.emailExists('test@example.com'),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.isEmailAvailable('test@example.com');

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });
}
