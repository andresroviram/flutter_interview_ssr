import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/users/data/models/user_model.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30);
    final testBirthDate = DateTime(1990, 5, 20);

    final testJson = {
      'id': 123,
      'first_name': 'John',
      'last_name': 'Doe',
      'birth_date': testBirthDate.toIso8601String(),
      'email': 'john.doe@example.com',
      'phone': '1234567890',
      'created_at': testDateTime.toIso8601String(),
      'updated_at': null,
    };

    final testModel = UserModel(
      id: 123,
      firstName: 'John',
      lastName: 'Doe',
      birthDate: testBirthDate,
      email: 'john.doe@example.com',
      phone: '1234567890',
      createdAt: testDateTime,
      updatedAt: null,
    );

    group('fromJson', () {
      test('should create UserModel from valid JSON', () {
        final result = UserModel.fromJson(testJson);

        expect(result.id, 123);
        expect(result.firstName, 'John');
        expect(result.lastName, 'Doe');
        expect(result.email, 'john.doe@example.com');
        expect(result.phone, '1234567890');
        expect(result.birthDate, testBirthDate);
        expect(result.createdAt, testDateTime);
        expect(result.updatedAt, null);
      });

      test('should handle updatedAt when present', () {
        final updatedDateTime = DateTime(2024, 2, 10);
        final jsonWithUpdate = {
          ...testJson,
          'updated_at': updatedDateTime.toIso8601String(),
        };

        final result = UserModel.fromJson(jsonWithUpdate);

        expect(result.updatedAt, updatedDateTime);
      });
    });

    group('toJson', () {
      test('should convert UserModel to JSON', () {
        final result = testModel.toJson();

        expect(result['id'], 123);
        expect(result['first_name'], 'John');
        expect(result['last_name'], 'Doe');
        expect(result['email'], 'john.doe@example.com');
        expect(result['phone'], '1234567890');
        expect(result['birth_date'], testBirthDate.toIso8601String());
        expect(result['created_at'], testDateTime.toIso8601String());
        expect(result['updated_at'], null);
      });

      test('should include updatedAt in JSON when present', () {
        final updatedDateTime = DateTime(2024, 2, 10);
        final modelWithUpdate = UserModel(
          id: 123,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: testBirthDate,
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: testDateTime,
          updatedAt: updatedDateTime,
        );

        final result = modelWithUpdate.toJson();

        expect(result['updated_at'], updatedDateTime.toIso8601String());
      });
    });

    group('JSON roundtrip', () {
      test('should maintain data integrity through JSON serialization', () {
        final json = testModel.toJson();
        final resultModel = UserModel.fromJson(json);

        expect(resultModel.id, testModel.id);
        expect(resultModel.firstName, testModel.firstName);
        expect(resultModel.lastName, testModel.lastName);
        expect(resultModel.email, testModel.email);
        expect(resultModel.phone, testModel.phone);
        expect(resultModel.birthDate, testModel.birthDate);
        expect(resultModel.createdAt, testModel.createdAt);
        expect(resultModel.updatedAt, testModel.updatedAt);
      });
    });

    group('toEntity', () {
      test('should convert UserModel to UserEntity', () {
        final entity = testModel.toEntity();

        expect(entity, isA<UserEntity>());
        expect(entity.id, testModel.id);
        expect(entity.firstName, testModel.firstName);
        expect(entity.lastName, testModel.lastName);
        expect(entity.email, testModel.email);
        expect(entity.phone, testModel.phone);
        expect(entity.birthDate, testModel.birthDate);
        expect(entity.createdAt, testModel.createdAt);
        expect(entity.updatedAt, testModel.updatedAt);
      });

      test('should preserve all fields during conversion', () {
        final updatedDateTime = DateTime(2024, 2, 10);
        final modelWithUpdate = UserModel(
          id: 123,
          firstName: 'John',
          lastName: 'Doe',
          birthDate: testBirthDate,
          email: 'john.doe@example.com',
          phone: '1234567890',
          createdAt: testDateTime,
          updatedAt: updatedDateTime,
        );

        final entity = modelWithUpdate.toEntity();

        expect(entity.updatedAt, updatedDateTime);
      });
    });

    group('fromEntity', () {
      test('should convert UserEntity to UserModel', () {
        final entity = UserEntity(
          id: 456,
          firstName: 'Jane',
          lastName: 'Smith',
          birthDate: testBirthDate,
          email: 'jane.smith@example.com',
          phone: '9876543210',
          createdAt: testDateTime,
          updatedAt: null,
        );

        final model = entity.toModel();

        expect(model, isA<UserModel>());
        expect(model.id, entity.id);
        expect(model.firstName, entity.firstName);
        expect(model.lastName, entity.lastName);
        expect(model.email, entity.email);
        expect(model.phone, entity.phone);
        expect(model.birthDate, entity.birthDate);
        expect(model.createdAt, entity.createdAt);
        expect(model.updatedAt, entity.updatedAt);
      });
    });

    group('Model-Entity roundtrip', () {
      test(
        'should maintain data integrity through Model-Entity conversion',
        () {
          final entity = testModel.toEntity();
          final resultModel = entity.toModel();

          expect(resultModel.id, testModel.id);
          expect(resultModel.firstName, testModel.firstName);
          expect(resultModel.lastName, testModel.lastName);
          expect(resultModel.email, testModel.email);
          expect(resultModel.phone, testModel.phone);
          expect(resultModel.birthDate, testModel.birthDate);
          expect(resultModel.createdAt, testModel.createdAt);
          expect(resultModel.updatedAt, testModel.updatedAt);
        },
      );
    });
  });
}
