import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';

void main() {
  group('AddressLabel', () {
    test('should have correct label values', () {
      expect(AddressLabel.home.label, 'Casa');
      expect(AddressLabel.work.label, 'Trabajo');
      expect(AddressLabel.other.label, 'Otro');
    });

    test('should have all enum values', () {
      expect(AddressLabel.values.length, 3);
      expect(AddressLabel.values, contains(AddressLabel.home));
      expect(AddressLabel.values, contains(AddressLabel.work));
      expect(AddressLabel.values, contains(AddressLabel.other));
    });
  });

  group('AddressEntity', () {
    final testAddress = AddressEntity(
      id: 1,
      userId: 1,
      street: '123 Main St',
      neighborhood: 'Downtown',
      city: 'Springfield',
      state: 'IL',
      postalCode: '62701',
      label: AddressLabel.home,
      isPrimary: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 10),
    );

    test('should create AddressEntity with all required fields', () {
      expect(testAddress.id, 1);
      expect(testAddress.userId, 1);
      expect(testAddress.street, '123 Main St');
      expect(testAddress.neighborhood, 'Downtown');
      expect(testAddress.city, 'Springfield');
      expect(testAddress.state, 'IL');
      expect(testAddress.postalCode, '62701');
      expect(testAddress.label, AddressLabel.home);
      expect(testAddress.isPrimary, true);
    });

    test('should create AddressEntity with default isPrimary false', () {
      final address = AddressEntity(
        id: 1,
        userId: 1,
        street: '123 Main St',
        neighborhood: 'Downtown',
        city: 'Springfield',
        state: 'IL',
        postalCode: '62701',
        label: AddressLabel.home,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(address.isPrimary, false);
      expect(address.updatedAt, isNull);
    });

    group('fullAddress', () {
      test('should return full formatted address', () {
        expect(
          testAddress.fullAddress,
          '123 Main St, Downtown, Springfield, IL, CP 62701',
        );
      });

      test('should format complete address components', () {
        final address = AddressEntity(
          id: 2,
          userId: 1,
          street: 'Av. Principal 456',
          neighborhood: 'Centro',
          city: 'Bogotá',
          state: 'Cundinamarca',
          postalCode: '110111',
          label: AddressLabel.work,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(
          address.fullAddress,
          'Av. Principal 456, Centro, Bogotá, Cundinamarca, CP 110111',
        );
      });
    });

    group('shortAddress', () {
      test('should return short formatted address', () {
        expect(testAddress.shortAddress, '123 Main St, Downtown');
      });

      test('should format only street and neighborhood', () {
        final address = AddressEntity(
          id: 2,
          userId: 1,
          street: 'Calle 72 #10-34',
          neighborhood: 'Chapinero',
          city: 'Bogotá',
          state: 'Cundinamarca',
          postalCode: '110221',
          label: AddressLabel.home,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(address.shortAddress, 'Calle 72 #10-34, Chapinero');
      });
    });

    group('copyWith', () {
      test('should copy with new id', () {
        final copied = testAddress.copyWith(id: 2);
        expect(copied.id, 2);
        expect(copied.street, testAddress.street);
        expect(copied.city, testAddress.city);
      });

      test('should copy with new isPrimary', () {
        final copied = testAddress.copyWith(isPrimary: false);
        expect(copied.isPrimary, false);
        expect(copied.id, testAddress.id);
      });

      test('should copy with new label', () {
        final copied = testAddress.copyWith(label: AddressLabel.work);
        expect(copied.label, AddressLabel.work);
        expect(copied.id, testAddress.id);
      });

      test('should copy with multiple changes', () {
        final copied = testAddress.copyWith(
          street: '456 Elm St',
          neighborhood: 'Uptown',
          isPrimary: false,
        );

        expect(copied.street, '456 Elm St');
        expect(copied.neighborhood, 'Uptown');
        expect(copied.isPrimary, false);
        expect(copied.city, testAddress.city);
        expect(copied.postalCode, testAddress.postalCode);
      });

      test('should copy with no changes', () {
        final copied = testAddress.copyWith();
        expect(copied.id, testAddress.id);
        expect(copied.street, testAddress.street);
        expect(copied.city, testAddress.city);
        expect(copied.isPrimary, testAddress.isPrimary);
      });

      test('should copy all fields', () {
        final copied = testAddress.copyWith(
          id: 2,
          userId: 2,
          street: 'New Street',
          neighborhood: 'New Hood',
          city: 'New City',
          state: 'NC',
          postalCode: '12345',
          label: AddressLabel.other,
          isPrimary: false,
          updatedAt: DateTime(2024, 2, 1),
        );

        expect(copied.id, 2);
        expect(copied.userId, 2);
        expect(copied.street, 'New Street');
        expect(copied.neighborhood, 'New Hood');
        expect(copied.city, 'New City');
        expect(copied.state, 'NC');
        expect(copied.postalCode, '12345');
        expect(copied.label, AddressLabel.other);
        expect(copied.isPrimary, false);
        expect(copied.updatedAt, DateTime(2024, 2, 1));
      });
    });

    group('equality', () {
      test('should be equal when all properties match', () {
        final address1 = AddressEntity(
          id: 1,
          userId: 1,
          street: '123 Main St',
          neighborhood: 'Downtown',
          city: 'Springfield',
          state: 'IL',
          postalCode: '62701',
          label: AddressLabel.home,
          isPrimary: true,
          createdAt: DateTime(2024, 1, 1),
        );

        final address2 = AddressEntity(
          id: 1,
          userId: 1,
          street: '123 Main St',
          neighborhood: 'Downtown',
          city: 'Springfield',
          state: 'IL',
          postalCode: '62701',
          label: AddressLabel.home,
          isPrimary: true,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(address1, equals(address2));
      });

      test('should not be equal when id differs', () {
        final address1 = testAddress;
        final address2 = testAddress.copyWith(id: 2);

        expect(address1, isNot(equals(address2)));
      });

      test('should not be equal when isPrimary differs', () {
        final address1 = testAddress;
        final address2 = testAddress.copyWith(isPrimary: false);

        expect(address1, isNot(equals(address2)));
      });

      test('should not be equal when street differs', () {
        final address1 = testAddress;
        final address2 = testAddress.copyWith(street: 'Different St');

        expect(address1, isNot(equals(address2)));
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final result = testAddress.toString();
        expect(result, contains('AddressEntity'));
        expect(result, contains('id: 1'));
        expect(result, contains('label: Casa'));
        expect(result, contains('isPrimary: true'));
      });

      test('should include correct label text', () {
        final workAddress = testAddress.copyWith(label: AddressLabel.work);
        final result = workAddress.toString();
        expect(result, contains('label: Trabajo'));
      });
    });

    group('props', () {
      test('should include all properties in props list', () {
        expect(testAddress.props.length, 11);
        expect(testAddress.props[0], 1); // id
        expect(testAddress.props[1], 1); // userId
        expect(testAddress.props[2], '123 Main St'); // street
        expect(testAddress.props[3], 'Downtown'); // neighborhood
        expect(testAddress.props[4], 'Springfield'); // city
        expect(testAddress.props[5], 'IL'); // state
        expect(testAddress.props[6], '62701'); // postalCode
        expect(testAddress.props[7], AddressLabel.home); // label
        expect(testAddress.props[8], true); // isPrimary
      });
    });
  });
}
