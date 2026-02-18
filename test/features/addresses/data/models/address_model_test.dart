import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/addresses/data/models/address_model.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';

void main() {
  group('AddressModel', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30);

    final testJson = {
      'id': 123,
      'user_id': 123,
      'street': 'Calle Principal 123',
      'neighborhood': 'Centro',
      'city': 'Ciudad de México',
      'state': 'CDMX',
      'postal_code': '12345',
      'label': 'home',
      'is_primary': true,
      'created_at': testDateTime.toIso8601String(),
      'updated_at': null,
    };

    final testModel = AddressModel(
      id: 123,
      userId: 123,
      street: 'Calle Principal 123',
      neighborhood: 'Centro',
      city: 'Ciudad de México',
      state: 'CDMX',
      postalCode: '12345',
      labelString: 'home',
      isPrimary: true,
      createdAt: testDateTime,
      updatedAt: null,
    );

    group('fromJson', () {
      test('should create AddressModel from valid JSON', () {
        final result = AddressModel.fromJson(testJson);

        expect(result.id, 123);
        expect(result.userId, 123);
        expect(result.street, 'Calle Principal 123');
        expect(result.neighborhood, 'Centro');
        expect(result.city, 'Ciudad de México');
        expect(result.state, 'CDMX');
        expect(result.postalCode, '12345');
        expect(result.labelString, 'home');
        expect(result.isPrimary, true);
        expect(result.createdAt, testDateTime);
        expect(result.updatedAt, null);
      });

      test('should handle updatedAt when present', () {
        final updatedDateTime = DateTime(2024, 2, 10);
        final jsonWithUpdate = {
          ...testJson,
          'updated_at': updatedDateTime.toIso8601String(),
        };

        final result = AddressModel.fromJson(jsonWithUpdate);

        expect(result.updatedAt, updatedDateTime);
      });

      test('should handle work label', () {
        final jsonWithWork = {...testJson, 'label': 'work'};

        final result = AddressModel.fromJson(jsonWithWork);

        expect(result.labelString, 'work');
      });

      test('should handle other label', () {
        final jsonWithOther = {...testJson, 'label': 'other'};

        final result = AddressModel.fromJson(jsonWithOther);

        expect(result.labelString, 'other');
      });

      test('should handle non-primary address', () {
        final jsonNonPrimary = {...testJson, 'is_primary': false};

        final result = AddressModel.fromJson(jsonNonPrimary);

        expect(result.isPrimary, false);
      });
    });

    group('toJson', () {
      test('should convert AddressModel to JSON', () {
        final result = testModel.toJson();

        expect(result['id'], 123);
        expect(result['user_id'], 123);
        expect(result['street'], 'Calle Principal 123');
        expect(result['neighborhood'], 'Centro');
        expect(result['city'], 'Ciudad de México');
        expect(result['state'], 'CDMX');
        expect(result['postal_code'], '12345');
        expect(result['label'], 'home');
        expect(result['is_primary'], true);
        expect(result['created_at'], testDateTime.toIso8601String());
        expect(result['updated_at'], null);
      });

      test('should include updatedAt in JSON when present', () {
        final updatedDateTime = DateTime(2024, 2, 10);
        final modelWithUpdate = AddressModel(
          id: 123,
          userId: 123,
          street: 'Calle Principal 123',
          neighborhood: 'Centro',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '12345',
          labelString: 'home',
          isPrimary: true,
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
        final resultModel = AddressModel.fromJson(json);

        expect(resultModel.id, testModel.id);
        expect(resultModel.userId, testModel.userId);
        expect(resultModel.street, testModel.street);
        expect(resultModel.neighborhood, testModel.neighborhood);
        expect(resultModel.city, testModel.city);
        expect(resultModel.state, testModel.state);
        expect(resultModel.postalCode, testModel.postalCode);
        expect(resultModel.labelString, testModel.labelString);
        expect(resultModel.isPrimary, testModel.isPrimary);
        expect(resultModel.createdAt, testModel.createdAt);
        expect(resultModel.updatedAt, testModel.updatedAt);
      });
    });

    group('toEntity', () {
      test('should convert AddressModel to AddressEntity with home label', () {
        final entity = testModel.toEntity();

        expect(entity, isA<AddressEntity>());
        expect(entity.id, testModel.id);
        expect(entity.userId, testModel.userId);
        expect(entity.street, testModel.street);
        expect(entity.neighborhood, testModel.neighborhood);
        expect(entity.city, testModel.city);
        expect(entity.state, testModel.state);
        expect(entity.postalCode, testModel.postalCode);
        expect(entity.label, AddressLabel.home);
        expect(entity.isPrimary, testModel.isPrimary);
        expect(entity.createdAt, testModel.createdAt);
        expect(entity.updatedAt, testModel.updatedAt);
      });

      test('should convert work label correctly', () {
        final workModel = AddressModel(
          id: 123,
          userId: 123,
          street: 'Calle Principal 123',
          neighborhood: 'Centro',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '12345',
          labelString: 'work',
          isPrimary: false,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final entity = workModel.toEntity();

        expect(entity.label, AddressLabel.work);
      });

      test('should convert other label correctly', () {
        final otherModel = AddressModel(
          id: 123,
          userId: 123,
          street: 'Calle Principal 123',
          neighborhood: 'Centro',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '12345',
          labelString: 'other',
          isPrimary: false,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final entity = otherModel.toEntity();

        expect(entity.label, AddressLabel.other);
      });

      test('should default to other label for unknown label strings', () {
        final unknownLabelModel = AddressModel(
          id: 123,
          userId: 123,
          street: 'Calle Principal 123',
          neighborhood: 'Centro',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '12345',
          labelString: 'unknown',
          isPrimary: false,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final entity = unknownLabelModel.toEntity();

        expect(entity.label, AddressLabel.other);
      });
    });

    group('fromEntity', () {
      test('should convert AddressEntity to AddressModel', () {
        final entity = AddressEntity(
          id: 456,
          userId: 456,
          street: 'Av. Reforma 456',
          neighborhood: 'Polanco',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '54321',
          label: AddressLabel.work,
          isPrimary: false,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final model = entity.toModel();

        expect(model, isA<AddressModel>());
        expect(model.id, entity.id);
        expect(model.userId, entity.userId);
        expect(model.street, entity.street);
        expect(model.neighborhood, entity.neighborhood);
        expect(model.city, entity.city);
        expect(model.state, entity.state);
        expect(model.postalCode, entity.postalCode);
        expect(model.labelString, 'work');
        expect(model.isPrimary, entity.isPrimary);
        expect(model.createdAt, entity.createdAt);
        expect(model.updatedAt, entity.updatedAt);
      });

      test('should convert home label correctly', () {
        final entity = AddressEntity(
          id: 456,
          userId: 456,
          street: 'Av. Reforma 456',
          neighborhood: 'Polanco',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '54321',
          label: AddressLabel.home,
          isPrimary: true,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final model = entity.toModel();

        expect(model.labelString, 'home');
      });

      test('should convert other label correctly', () {
        final entity = AddressEntity(
          id: 456,
          userId: 456,
          street: 'Av. Reforma 456',
          neighborhood: 'Polanco',
          city: 'Ciudad de México',
          state: 'CDMX',
          postalCode: '54321',
          label: AddressLabel.other,
          isPrimary: false,
          createdAt: testDateTime,
          updatedAt: null,
        );

        final model = entity.toModel();

        expect(model.labelString, 'other');
      });
    });

    group('Model-Entity roundtrip', () {
      test(
        'should maintain data integrity through Model-Entity conversion',
        () {
          final entity = testModel.toEntity();
          final resultModel = entity.toModel();

          expect(resultModel.id, testModel.id);
          expect(resultModel.userId, testModel.userId);
          expect(resultModel.street, testModel.street);
          expect(resultModel.neighborhood, testModel.neighborhood);
          expect(resultModel.city, testModel.city);
          expect(resultModel.state, testModel.state);
          expect(resultModel.postalCode, testModel.postalCode);
          expect(resultModel.labelString, testModel.labelString);
          expect(resultModel.isPrimary, testModel.isPrimary);
          expect(resultModel.createdAt, testModel.createdAt);
          expect(resultModel.updatedAt, testModel.updatedAt);
        },
      );

      test('should maintain all label types through roundtrip', () {
        for (final label in AddressLabel.values) {
          final model = AddressModel(
            id: 1,
            userId: 1,
            street: 'Test Street',
            neighborhood: 'Test Neighborhood',
            city: 'Test City',
            state: 'Test State',
            postalCode: '12345',
            labelString: label.name,
            isPrimary: false,
            createdAt: testDateTime,
            updatedAt: null,
          );

          final entity = model.toEntity();
          final resultModel = entity.toModel();

          expect(resultModel.labelString, model.labelString);
          expect(entity.label, label);
        }
      });
    });
  });
}
