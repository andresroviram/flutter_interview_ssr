import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_interview_ssr/features/addresses/data/datasources/address_datasource_impl.dart';

class MockBox extends Mock implements Box<Map> {}

void main() {
  late AddressDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = AddressDataSourceImpl(box: mockBox);
  });

  final testAddress1 = AddressEntity(
    id: '1',
    userId: 'user1',
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
    id: '2',
    userId: 'user1',
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
    id: '3',
    userId: 'user2',
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

  Map<String, dynamic> addressToJson(AddressEntity address) => {
    'id': address.id,
    'user_id': address.userId,
    'street': address.street,
    'neighborhood': address.neighborhood,
    'city': address.city,
    'state': address.state,
    'postal_code': address.postalCode,
    'is_primary': address.isPrimary,
    'label': address.label.name,
    'created_at': address.createdAt.toIso8601String(),
    if (address.updatedAt != null)
      'updated_at': address.updatedAt!.toIso8601String(),
  };

  group('AddressDataSourceImpl', () {
    group('getAddressesByUserId', () {
      test(
        'should return list of addresses for user sorted by isPrimary and createdAt',
        () async {
          // Arrange
          final values = [
            addressToJson(testAddress1), // user1, isPrimary=true, date=1
            addressToJson(testAddress2), // user1, isPrimary=false, date=2
            addressToJson(testAddress3), // user2, isPrimary=true, date=3
          ];
          when(() => mockBox.values).thenReturn(values);

          // Act
          final result = await dataSource.getAddressesByUserId('user1');

          // Assert
          expect(result, hasLength(2));
          expect(result[0].id, '1'); // Primary first
          expect(result[0].isPrimary, isTrue);
          expect(result[1].id, '2'); // Secondary second
          expect(result[1].isPrimary, isFalse);
          verify(() => mockBox.values).called(1);
        },
      );

      test('should return empty list when user has no addresses', () async {
        // Arrange
        final values = [
          addressToJson(testAddress1),
          addressToJson(testAddress2),
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.getAddressesByUserId('user999');

        // Assert
        expect(result, isEmpty);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Hive error'));

        // Act & Assert
        expect(
          () => dataSource.getAddressesByUserId('user1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('getAddressById', () {
      test('should return address when found', () async {
        // Arrange
        when(() => mockBox.get('1')).thenReturn(addressToJson(testAddress1));

        // Act
        final result = await dataSource.getAddressById('1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, '1');
        expect(result.street, 'Calle Principal');
        verify(() => mockBox.get('1')).called(1);
      });

      test('should return null when address not found', () async {
        // Arrange
        when(() => mockBox.get('999')).thenReturn(null);

        // Act
        final result = await dataSource.getAddressById('999');

        // Assert
        expect(result, isNull);
        verify(() => mockBox.get('999')).called(1);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.get('1')).thenThrow(Exception('Hive error'));

        // Act & Assert
        expect(
          () => dataSource.getAddressById('1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('getPrimaryAddress', () {
      test('should return primary address for user', () async {
        // Arrange
        final values = [
          addressToJson(testAddress1), // user1, isPrimary=true
          addressToJson(testAddress2), // user1, isPrimary=false
        ];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.getPrimaryAddress('user1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, '1');
        expect(result.isPrimary, isTrue);
      });

      test('should return null when user has no primary address', () async {
        // Arrange
        final address = testAddress2.copyWith(isPrimary: false);
        final values = [addressToJson(address)];
        when(() => mockBox.values).thenReturn(values);

        // Act
        final result = await dataSource.getPrimaryAddress('user1');

        // Assert
        expect(result, isNull);
      });

      test('should return null when user has no addresses', () async {
        // Arrange
        when(() => mockBox.values).thenReturn([]);

        // Act
        final result = await dataSource.getPrimaryAddress('user999');

        // Assert
        expect(result, isNull);
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Error'));

        // Act & Assert
        expect(
          () => dataSource.getPrimaryAddress('user1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('createAddress', () {
      test('should save address to box and return it', () async {
        // Arrange
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        final result = await dataSource.createAddress(testAddress1);

        // Assert
        expect(result, equals(testAddress1));
        verify(() => mockBox.put('1', any())).called(1);
      });

      test('should throw StorageException on save error', () async {
        // Arrange
        when(
          () => mockBox.put(any(), any()),
        ).thenThrow(Exception('Save failed'));

        // Act & Assert
        expect(
          () => dataSource.createAddress(testAddress1),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('updateAddress', () {
      test('should update address when exists', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        final result = await dataSource.updateAddress(testAddress1);

        // Assert
        expect(result, equals(testAddress1));
        verify(() => mockBox.containsKey('1')).called(1);
        verify(() => mockBox.put('1', any())).called(1);
      });

      test(
        'should throw NotFoundException when address does not exist',
        () async {
          // Arrange
          when(() => mockBox.containsKey('999')).thenReturn(false);

          // Act & Assert
          expect(
            () => dataSource.updateAddress(testAddress1.copyWith(id: '999')),
            throwsA(isA<NotFoundException>()),
          );
        },
      );

      test('should throw StorageException on update error', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(
          () => mockBox.put(any(), any()),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => dataSource.updateAddress(testAddress1),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('deleteAddress', () {
      test('should delete address when exists', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.delete('1')).thenAnswer((_) async {});

        // Act
        await dataSource.deleteAddress('1');

        // Assert
        verify(() => mockBox.containsKey('1')).called(1);
        verify(() => mockBox.delete('1')).called(1);
      });

      test(
        'should throw NotFoundException when address does not exist',
        () async {
          // Arrange
          when(() => mockBox.containsKey('999')).thenReturn(false);

          // Act & Assert
          expect(
            () => dataSource.deleteAddress('999'),
            throwsA(isA<NotFoundException>()),
          );
        },
      );

      test('should throw StorageException on delete error', () async {
        // Arrange
        when(() => mockBox.containsKey('1')).thenReturn(true);
        when(() => mockBox.delete('1')).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => dataSource.deleteAddress('1'),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('setPrimaryAddress', () {
      test('should update all user addresses and set one as primary', () async {
        // Arrange
        final values = [
          addressToJson(
            testAddress1.copyWith(isPrimary: false),
          ), // Will be set to true
          addressToJson(
            testAddress2.copyWith(isPrimary: true),
          ), // Will be set to false
        ];
        when(() => mockBox.values).thenReturn(values);
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        await dataSource.setPrimaryAddress('user1', '1');

        // Assert
        verify(() => mockBox.values).called(1);
        verify(() => mockBox.put('1', any())).called(1); // Set as primary
        verify(() => mockBox.put('2', any())).called(1); // Unset as primary
      });

      test('should handle when no addresses exist for user', () async {
        // Arrange
        when(() => mockBox.values).thenReturn([]);

        // Act
        await dataSource.setPrimaryAddress('user999', '1');

        // Assert
        verify(() => mockBox.values).called(1);
        verifyNever(() => mockBox.put(any(), any()));
      });

      test('should throw StorageException on error', () async {
        // Arrange
        when(() => mockBox.values).thenThrow(Exception('Error'));

        // Act & Assert
        expect(
          () => dataSource.setPrimaryAddress('user1', '1'),
          throwsA(isA<StorageException>()),
        );
      });

      test('should update only addresses for specified user', () async {
        // Arrange
        final values = [
          addressToJson(testAddress1), // user1
          addressToJson(testAddress2), // user1
          addressToJson(testAddress3), // user2 - should not be updated
        ];
        when(() => mockBox.values).thenReturn(values);
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // Act
        await dataSource.setPrimaryAddress('user1', '2');

        // Assert
        verify(() => mockBox.put('1', any())).called(1);
        verify(() => mockBox.put('2', any())).called(1);
        verifyNever(
          () => mockBox.put('3', any()),
        ); // user2's address not touched
      });
    });
  });
}
