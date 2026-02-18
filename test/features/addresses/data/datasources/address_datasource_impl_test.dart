import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_interview_ssr/core/database/app_database.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_interview_ssr/features/addresses/data/datasources/address_datasource_impl.dart';

void main() {
  late AppDatabase database;
  late AddressDataSourceImpl dataSource;

  setUp(() {
    // Crear base de datos en memoria para tests
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = AddressDataSourceImpl(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  final testAddress1 = AddressEntity(
    id: 1,
    userId: 1,
    street: 'Calle Principal',
    neighborhood: 'Centro',
    city: 'Madrid',
    state: 'Madrid',
    postalCode: '28001',
    isPrimary: true,
    label: AddressLabel.home,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testAddress2 = AddressEntity(
    id: 2,
    userId: 1,
    street: 'Avenida Secundaria',
    neighborhood: 'Norte',
    city: 'Barcelona',
    state: 'Barcelona',
    postalCode: '08001',
    isPrimary: false,
    label: AddressLabel.work,
    createdAt: DateTime(2024, 1, 2),
    updatedAt: DateTime(2024, 1, 2),
  );

  final testAddress3 = AddressEntity(
    id: 3,
    userId: 2,
    street: 'Plaza Mayor',
    neighborhood: 'Sur',
    city: 'Valencia',
    state: 'Valencia',
    postalCode: '46001',
    isPrimary: true,
    label: AddressLabel.home,
    createdAt: DateTime(2024, 1, 3),
    updatedAt: DateTime(2024, 1, 3),
  );

  group('AddressDataSourceImpl', () {
    group('getAddressesByUserId', () {
      test(
        'should return list of addresses for user sorted by isPrimary and createdAt',
        () async {
          // Arrange
          await dataSource.createAddress(testAddress1);
          await dataSource.createAddress(testAddress2);
          await dataSource.createAddress(testAddress3);

          // Act
          final result = await dataSource.getAddressesByUserId(1);

          // Assert
          expect(result, hasLength(2));
          expect(result[0].id, 1); // Primary first
          expect(result[0].isPrimary, isTrue);
          expect(result[1].id, 2); // Secondary second
          expect(result[1].isPrimary, isFalse);
        },
      );

      test('should return empty list when no addresses for user', () async {
        // Act
        final result = await dataSource.getAddressesByUserId(999);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getAddressById', () {
      test('should return address when found', () async {
        // Arrange
        await dataSource.createAddress(testAddress1);

        // Act
        final result = await dataSource.getAddressById(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.street, 'Calle Principal');
      });

      test('should return null when address not found', () async {
        // Act
        final result = await dataSource.getAddressById(999);

        // Assert
        expect(result, isNull);
      });
    });

    group('getPrimaryAddress', () {
      test('should return primary address for user', () async {
        // Arrange
        await dataSource.createAddress(testAddress1);
        await dataSource.createAddress(testAddress2);

        // Act
        final result = await dataSource.getPrimaryAddress(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.isPrimary, isTrue);
      });

      test('should return null when user has no primary address', () async {
        // Arrange
        final noPrimary = AddressEntity(
          id: testAddress2.id,
          userId: testAddress2.userId,
          street: testAddress2.street,
          neighborhood: testAddress2.neighborhood,
          city: testAddress2.city,
          state: testAddress2.state,
          postalCode: testAddress2.postalCode,
          label: testAddress2.label,
          isPrimary: false,
          createdAt: testAddress2.createdAt,
          updatedAt: testAddress2.updatedAt,
        );
        await dataSource.createAddress(noPrimary);

        // Act
        final result = await dataSource.getPrimaryAddress(1);

        // Assert
        expect(result, isNull);
      });

      test('should return null when user has no addresses', () async {
        // Act
        final result = await dataSource.getPrimaryAddress(999);

        // Assert
        expect(result, isNull);
      });
    });

    group('createAddress', () {
      test('should save address and return it', () async {
        // Act
        final result = await dataSource.createAddress(testAddress1);

        // Assert
        expect(result, equals(testAddress1));

        final saved = await dataSource.getAddressById(1);
        expect(saved, isNotNull);
        expect(saved!.street, 'Calle Principal');
      });
    });

    group('updateAddress', () {
      test('should update address when exists', () async {
        // Arrange
        await dataSource.createAddress(testAddress1);
        final updated = AddressEntity(
          id: testAddress1.id,
          userId: testAddress1.userId,
          street: 'Calle Actualizada',
          neighborhood: testAddress1.neighborhood,
          city: testAddress1.city,
          state: testAddress1.state,
          postalCode: testAddress1.postalCode,
          label: testAddress1.label,
          isPrimary: testAddress1.isPrimary,
          createdAt: testAddress1.createdAt,
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await dataSource.updateAddress(updated);

        // Assert
        expect(result.street, 'Calle Actualizada');

        final saved = await dataSource.getAddressById(1);
        expect(saved!.street, 'Calle Actualizada');
      });

      test(
        'should throw NotFoundException when address does not exist',
        () async {
          // Arrange
          final nonExistentAddress = AddressEntity(
            id: 999,
            userId: testAddress1.userId,
            street: testAddress1.street,
            neighborhood: testAddress1.neighborhood,
            city: testAddress1.city,
            state: testAddress1.state,
            postalCode: testAddress1.postalCode,
            isPrimary: testAddress1.isPrimary,
            label: testAddress1.label,
            createdAt: testAddress1.createdAt,
          );

          // Act & Assert
          expect(
            () => dataSource.updateAddress(nonExistentAddress),
            throwsA(isA<NotFoundException>()),
          );
        },
      );
    });

    group('deleteAddress', () {
      test('should delete address when exists', () async {
        // Arrange
        await dataSource.createAddress(testAddress1);

        // Act
        await dataSource.deleteAddress(1);

        // Assert
        final result = await dataSource.getAddressById(1);
        expect(result, isNull);
      });

      test(
        'should throw NotFoundException when address does not exist',
        () async {
          // Act & Assert
          expect(
            () => dataSource.deleteAddress(999),
            throwsA(isA<NotFoundException>()),
          );
        },
      );
    });

    group('setPrimaryAddress', () {
      test('should set primary address and unset others', () async {
        // Arrange
        await dataSource.createAddress(testAddress1); // primary
        await dataSource.createAddress(testAddress2); // not primary

        // Act
        await dataSource.setPrimaryAddress(1, 2);

        // Assert
        final address1 = await dataSource.getAddressById(1);
        final address2 = await dataSource.getAddressById(2);

        expect(address1!.isPrimary, isFalse);
        expect(address2!.isPrimary, isTrue);
      });

      test('should handle when setting already primary address', () async {
        // Arrange
        await dataSource.createAddress(testAddress1); // already primary

        // Act
        await dataSource.setPrimaryAddress(1, 1);

        // Assert
        final address = await dataSource.getAddressById(1);
        expect(address!.isPrimary, isTrue);
      });
    });
  });
}
