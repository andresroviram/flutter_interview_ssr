import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_interview_ssr/core/database/app_database.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_interview_ssr/features/users/data/datasources/user_datasource_impl.dart';

void main() {
  late AppDatabase database;
  late UserDataSourceImpl dataSource;

  setUp(() {
    // Crear base de datos en memoria para tests
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = UserDataSourceImpl(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  final testUser1 = UserEntity(
    id: 1,
    firstName: 'Juan',
    lastName: 'Pérez',
    email: 'juan@test.com',
    phone: '1234567890',
    birthDate: DateTime(1990, 1, 15),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testUser2 = UserEntity(
    id: 2,
    firstName: 'María',
    lastName: 'González',
    email: 'maria@test.com',
    phone: '0987654321',
    birthDate: DateTime(1985, 5, 20),
    createdAt: DateTime(2024, 1, 2),
    updatedAt: DateTime(2024, 1, 2),
  );

  final testUser3 = UserEntity(
    id: 3,
    firstName: 'Pedro',
    lastName: 'Martínez',
    email: 'pedro@test.com',
    phone: '5555555555',
    birthDate: DateTime(1995, 8, 10),
    createdAt: DateTime(2024, 1, 3),
    updatedAt: DateTime(2024, 1, 3),
  );

  group('UserDataSourceImpl', () {
    group('getAllUsers', () {
      test('should return list of users sorted by createdAt desc', () async {
        // Arrange
        await dataSource.createUser(testUser1);
        await dataSource.createUser(testUser2);
        await dataSource.createUser(testUser3);

        // Act
        final result = await dataSource.getAllUsers();

        // Assert
        expect(result, hasLength(3));
        expect(result[0].id, 3); // Most recent
        expect(result[1].id, 2);
        expect(result[2].id, 1); // Oldest
      });

      test('should return empty list when no users exist', () async {
        // Act
        final result = await dataSource.getAllUsers();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getUserById', () {
      test('should return user when found', () async {
        // Arrange
        await dataSource.createUser(testUser1);

        // Act
        final result = await dataSource.getUserById(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.firstName, 'Juan');
      });

      test('should return null when user not found', () async {
        // Act
        final result = await dataSource.getUserById(999);

        // Assert
        expect(result, isNull);
      });
    });

    group('createUser', () {
      test('should save user and return it', () async {
        // Act
        final result = await dataSource.createUser(testUser1);

        // Assert
        expect(result, equals(testUser1));

        final saved = await dataSource.getUserById(1);
        expect(saved, isNotNull);
        expect(saved!.firstName, 'Juan');
      });
    });

    group('updateUser', () {
      test('should update user when exists', () async {
        // Arrange
        await dataSource.createUser(testUser1);
        final updated = UserEntity(
          id: testUser1.id,
          firstName: 'Carlos',
          lastName: testUser1.lastName,
          email: testUser1.email,
          phone: testUser1.phone,
          birthDate: testUser1.birthDate,
          createdAt: testUser1.createdAt,
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await dataSource.updateUser(updated);

        // Assert
        expect(result.firstName, 'Carlos');

        final saved = await dataSource.getUserById(1);
        expect(saved!.firstName, 'Carlos');
      });

      test('should throw NotFoundException when user does not exist', () async {
        // Arrange
        final nonExistentUser = UserEntity(
          id: 999,
          firstName: testUser1.firstName,
          lastName: testUser1.lastName,
          email: testUser1.email,
          phone: testUser1.phone,
          birthDate: testUser1.birthDate,
          createdAt: testUser1.createdAt,
        );

        // Act & Assert
        expect(
          () => dataSource.updateUser(nonExistentUser),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('deleteUser', () {
      test('should delete user when exists', () async {
        // Arrange
        await dataSource.createUser(testUser1);

        // Act
        await dataSource.deleteUser(1);

        // Assert
        final result = await dataSource.getUserById(1);
        expect(result, isNull);
      });

      test('should throw NotFoundException when user does not exist', () async {
        // Act & Assert
        expect(
          () => dataSource.deleteUser(999),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('searchUsers', () {
      setUp(() async {
        await dataSource.createUser(testUser1);
        await dataSource.createUser(testUser2);
        await dataSource.createUser(testUser3);
      });

      test('should find users by first name', () async {
        // Act
        final result = await dataSource.searchUsers('Juan');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].firstName, 'Juan');
      });

      test('should find users by last name', () async {
        // Act
        final result = await dataSource.searchUsers('Pérez');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].lastName, 'Pérez');
      });

      test('should find users by email', () async {
        // Act
        final result = await dataSource.searchUsers('maria@test.com');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].email, 'maria@test.com');
      });

      test('should return empty list when no match', () async {
        // Act
        final result = await dataSource.searchUsers('NoExiste');

        // Assert
        expect(result, isEmpty);
      });

      test('should sort results with exact matches first', () async {
        // Act
        final result = await dataSource.searchUsers('Ma');

        // Assert
        expect(result, isNotEmpty);
        // María starts with Ma, should come first
        expect(result.any((u) => u.firstName == 'María'), isTrue);
      });
    });

    group('emailExists', () {
      test('should return true when email exists', () async {
        // Arrange
        await dataSource.createUser(testUser1);

        // Act
        final result = await dataSource.emailExists('juan@test.com');

        // Assert
        expect(result, isTrue);
      });

      test('should return true when email exists (case insensitive)', () async {
        // Arrange
        await dataSource.createUser(testUser1);

        // Act
        final result = await dataSource.emailExists('JUAN@TEST.COM');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when email does not exist', () async {
        // Act
        final result = await dataSource.emailExists('noexiste@test.com');

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
