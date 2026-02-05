import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_interview_ssr/features/users/data/datasources/user_datasource_impl.dart';

class MockBox extends Mock implements Box<Map> {}

void main() {
  late UserDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = UserDataSourceImpl(box: mockBox);
  });

  final testUser1 = UserEntity(
    id: '1',
    firstName: 'Juan',
    lastName: 'Pérez',
    email: 'juan@test.com',
    phone: '1234567890',
    birthDate: DateTime(1990, 1, 15),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testUser2 = UserEntity(
    id: '2',
    firstName: 'María',
    lastName: 'González',
    email: 'maria@test.com',
    phone: '0987654321',
    birthDate: DateTime(1985, 5, 20),
    createdAt: DateTime(2024, 1, 2),
    updatedAt: DateTime(2024, 1, 2),
  );

  final testUser3 = UserEntity(
    id: '3',
    firstName: 'Pedro',
    lastName: 'Martínez',
    email: 'pedro@test.com',
    phone: '5555555555',
    birthDate: DateTime(1995, 8, 10),
    createdAt: DateTime(2024, 1, 3),
    updatedAt: DateTime(2024, 1, 3),
  );

  Map<String, dynamic> userToJson(UserEntity user) => {
    'id': user.id,
    'first_name': user.firstName,
    'last_name': user.lastName,
    'email': user.email,
    'phone': user.phone,
    'birth_date': user.birthDate.toIso8601String(),
    'created_at': user.createdAt.toIso8601String(),
    if (user.updatedAt != null) 'updated_at': user.updatedAt!.toIso8601String(),
  };

  group('UserDataSourceImpl', () {
    group('getAllUsers', () {
      test('should return list of users sorted by createdAt desc', () async {
        // Arrange
        final values = [
          userToJson(testUser1),
          userToJson(testUser2),
          userToJson(testUser3),
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.getAllUsers();

        // Assert
        expect(result, hasLength(3));
        expect(result[0].id, '3'); // Most recent
        expect(result[1].id, '2');
        expect(result[2].id, '1'); // Oldest
        verify(() => mockBox.values).called(1);
      });

      test('should return empty list when no users exist', () async {
        // Arrange
        when(() => mockBox.values).thenReturn([]);

        // Act
        final result = await dataSource.getAllUsers();

        // Assert
        expect(result, isEmpty);
        verify(() => mockBox.values).called(1);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Hive error'));

        // Act & Assert
        expect(
          () => dataSource.getAllUsers(),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('getUserById', () {
      test('should return user when found', () async {
        // Arrange
        when(() => mockBox.get('1')).thenReturn(userToJson(testUser1));

        // Act
        final result = await dataSource.getUserById('1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, '1');
        expect(result.firstName, 'Juan');
        verify(() => mockBox.get('1')).called(1);
      });

      test('should return null when user not found', () async {
        // Arrange
        when(() => mockBox.get('999')).thenReturn(null);

        // Act
        final result = await dataSource.getUserById('999');

        // Assert
        expect(result, isNull);
        verify(() => mockBox.get('999')).called(1);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.get('1')).thenThrow(Exception('Hive error'));

        // Act & Assert
        expect(
          () => dataSource.getUserById('1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('createUser', () {
      test('should save user to box and return it', () async {
        // Arrange
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        final result = await dataSource.createUser(testUser1);

        // Assert
        expect(result, equals(testUser1));
        verify(() => mockBox.put('1', any())).called(1);
      });

      test('should throw StorageException on save error', () async {
        // Arrange
        when(
          () => mockBox.put(any(), any()),
        ).thenThrow(Exception('Save failed'));

        // Act & Assert
        expect(
          () => dataSource.createUser(testUser1),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('updateUser', () {
      test('should update user when exists', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        final result = await dataSource.updateUser(testUser1);

        // Assert
        expect(result, equals(testUser1));
        verify(() => mockBox.containsKey('1')).called(1);
        verify(() => mockBox.put('1', any())).called(1);
      });

      test('should throw NotFoundException when user does not exist', () async {
        // Arrange
        when(() => mockBox.containsKey('999')).thenReturn(false);
        final nonExistentUser = UserEntity(
          id: '999',
          firstName: testUser1.firstName,
          lastName: testUser1.lastName,
          email: testUser1.email,
          phone: testUser1.phone,
          birthDate: testUser1.birthDate,
          createdAt: testUser1.createdAt,
          updatedAt: testUser1.updatedAt,
        );

        // Act & Assert
        expect(
          () => dataSource.updateUser(nonExistentUser),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('should throw StorageException on update error', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(
          () => mockBox.put(any(), any()),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => dataSource.updateUser(testUser1),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('deleteUser', () {
      test('should delete user when exists', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.delete('1')).thenAnswer((_) async {});

        // Act
        await dataSource.deleteUser('1');

        // Assert
        verify(() => mockBox.containsKey('1')).called(1);
        verify(() => mockBox.delete('1')).called(1);
      });

      test('should throw NotFoundException when user does not exist', () async {
        // Arrange
        when(() => mockBox.containsKey('999')).thenReturn(false);

        // Act & Assert
        expect(
          () => dataSource.deleteUser('999'),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('should throw StorageException on delete error', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.delete('1')).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => dataSource.deleteUser('1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('searchUsers', () {
      test('should return users matching firstName', () async {
        // Arrange
        final values = [
          userToJson(testUser1), // Juan
          userToJson(testUser2), // María
          userToJson(testUser3), // Pedro
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('juan');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].firstName, 'Juan');
      });

      test('should return users matching lastName', () async {
        // Arrange
        final values = [
          userToJson(testUser1), // Pérez
          userToJson(testUser2), // González
          userToJson(testUser3), // Martínez
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('gonzález');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].lastName, 'González');
      });

      test('should return users matching email', () async {
        // Arrange
        final values = [
          userToJson(testUser1), // juan@test.com
          userToJson(testUser2), // maria@test.com
          userToJson(testUser3), // pedro@test.com
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('maria@');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].email, 'maria@test.com');
      });

      test('should return users matching fullName', () async {
        // Arrange
        final values = [
          userToJson(testUser1), // Juan Pérez
          userToJson(testUser2), // María González
          userToJson(testUser3), // Pedro Martínez
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('pérez');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].fullName, 'Juan Pérez');
      });

      test('should return empty list when no users match', () async {
        // Arrange
        final values = [
          userToJson(testUser1),
          userToJson(testUser2),
          userToJson(testUser3),
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('nonexistent');

        // Assert
        expect(result, isEmpty);
      });

      test('should sort results with exact matches first', () async {
        // Arrange
        final user4 = UserEntity(
          id: '4',
          firstName: 'Juana',
          lastName: testUser1.lastName,
          email: 'juana@test.com',
          phone: testUser1.phone,
          birthDate: testUser1.birthDate,
          createdAt: DateTime(2024, 1, 4),
          updatedAt: testUser1.updatedAt,
        );
        final values = [
          userToJson(testUser1), // Juan Pérez
          userToJson(user4), // Juana Pérez
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('juan');

        // Assert
        expect(result, hasLength(2));
        expect(result[0].firstName, 'Juan'); // Exact match first
        expect(result[1].firstName, 'Juana'); // Partial match second
      });

      test('should search case-insensitively', () async {
        // Arrange
        final values = [userToJson(testUser1)];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.searchUsers('JUAN');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].firstName, 'Juan');
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Search error'));

        // Act & Assert
        expect(
          () => dataSource.searchUsers('juan'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('emailExists', () {
      test('should return true when email exists', () async {
        // Arrange
        final values = [userToJson(testUser1), userToJson(testUser2)];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.emailExists('juan@test.com');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when email does not exist', () async {
        // Arrange
        final values = [userToJson(testUser1), userToJson(testUser2)];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.emailExists('nonexistent@test.com');

        // Assert
        expect(result, isFalse);
      });

      test('should check email case-insensitively', () async {
        // Arrange
        final values = [userToJson(testUser1)];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.emailExists('JUAN@TEST.COM');

        // Assert
        expect(result, isTrue);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Check error'));

        // Act & Assert
        expect(
          () => dataSource.emailExists('test@test.com'),
          throwsA(isA<StorageException>()),
        );
      });
    });
  });
}
