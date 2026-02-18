import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    final testUser = UserEntity(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      birthDate: DateTime(1990, 5, 15),
      email: 'john.doe@example.com',
      phone: '1234567890',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 10),
    );

    test('should create UserEntity with all required fields', () {
      expect(testUser.id, 1);
      expect(testUser.firstName, 'John');
      expect(testUser.lastName, 'Doe');
      expect(testUser.email, 'john.doe@example.com');
      expect(testUser.phone, '1234567890');
    });

    test('should create UserEntity without updatedAt', () {
      final user = UserEntity(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        birthDate: DateTime(1990, 5, 15),
        email: 'john.doe@example.com',
        phone: '1234567890',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(user.updatedAt, isNull);
    });

    group('fullName', () {
      test('should return full name correctly', () {
        expect(testUser.fullName, 'John Doe');
      });

      test('should handle single name', () {
        final user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: '',
          birthDate: DateTime(1990, 5, 15),
          email: 'john@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.fullName, 'John ');
      });
    });

    group('initials', () {
      test('should return correct initials', () {
        expect(testUser.initials, 'JD');
      });

      test('should handle lowercase names', () {
        final user = UserEntity(
          id: 1,
          firstName: 'john',
          lastName: 'doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.initials, 'JD');
      });

      test('should handle empty firstName', () {
        final user = UserEntity(
          id: 1,
          firstName: '',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.initials, 'D');
      });

      test('should handle empty lastName', () {
        final user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: '',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.initials, 'J');
      });

      test('should handle both empty names', () {
        final user = UserEntity(
          id: 1,
          firstName: '',
          lastName: '',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.initials, '');
      });
    });

    group('age', () {
      test('should calculate age correctly', () {
        final birthDate = DateTime(1990, 5, 15);
        final user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: birthDate,
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        final expectedAge =
            DateTime.now().year -
            1990 -
            (DateTime.now().month < 5 ||
                    (DateTime.now().month == 5 && DateTime.now().day < 15)
                ? 1
                : 0);

        expect(user.age, expectedAge);
      });

      test('should return 0 for birth date this year', () {
        final user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(DateTime.now().year, 1, 1),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user.age, 0);
      });
    });

    group('equality', () {
      test('should be equal when all properties match', () {
        final user1 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 10),
        );

        final user2 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 10),
        );

        expect(user1, equals(user2));
      });

      test('should not be equal when id differs', () {
        final user1 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        final user2 = UserEntity(
          id: 2,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when email differs', () {
        final user1 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        final user2 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: DateTime(1990, 5, 15),
          email: 'different@example.com',
          phone: '1234567890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final result = testUser.toString();
        expect(result, contains('UserEntity'));
        expect(result, contains('id: 1'));
        expect(result, contains('fullName: John Doe'));
        expect(result, contains('email: john.doe@example.com'));
      });
    });

    group('props', () {
      test('should include all properties in props list', () {
        expect(testUser.props.length, 8);
        expect(testUser.props[0], 1); // id
        expect(testUser.props[1], 'John'); // firstName
        expect(testUser.props[2], 'Doe'); // lastName
        expect(testUser.props[4], 'john.doe@example.com'); // email
        expect(testUser.props[5], '1234567890'); // phone
      });
    });
  });
}
