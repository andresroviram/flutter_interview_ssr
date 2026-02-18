import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';
import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/features/addresses/data/datasources/address_datasource.dart';
import 'package:flutter_interview_ssr/features/addresses/data/repositories/address_repository_impl.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';

class MockAddressDataSource extends Mock implements IAddressDataSource {}

void main() {
  late AddressRepositoryImpl repository;
  late MockAddressDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAddressDataSource();
    repository = AddressRepositoryImpl(mockDataSource);
  });

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
  );

  group('getAddressesByUserId', () {
    test('should return Success with addresses list', () async {
      when(
        () => mockDataSource.getAddressesByUserId(1),
      ).thenAnswer((_) async => [testAddress]);

      final result = await repository.getAddressesByUserId(1);

      expect(result, isA<Success<List<AddressEntity>>>());
      expect((result as Success).value, [testAddress]);
      verify(() => mockDataSource.getAddressesByUserId(1)).called(1);
    });

    test('should return empty list when user has no addresses', () async {
      when(
        () => mockDataSource.getAddressesByUserId(1),
      ).thenAnswer((_) async => []);

      final result = await repository.getAddressesByUserId(1);

      expect(result, isA<Success<List<AddressEntity>>>());
      expect((result as Success).value, isEmpty);
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.getAddressesByUserId(1),
      ).thenThrow(const StorageException(message: 'Read error'));

      final result = await repository.getAddressesByUserId(1);

      expect(result, isA<Failure<List<AddressEntity>>>());
      final failure = (result as Failure).error;
      expect(failure, isA<StorageReadFailure>());
      expect(failure.message, 'Read error');
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.getAddressesByUserId(1),
      ).thenThrow(Exception('Boom'));

      final result = await repository.getAddressesByUserId(1);

      expect(result, isA<Failure<List<AddressEntity>>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('getAddressById', () {
    test('should return Success with address when found', () async {
      when(
        () => mockDataSource.getAddressById(1),
      ).thenAnswer((_) async => testAddress);

      final result = await repository.getAddressById(1);

      expect(result, isA<Success<AddressEntity>>());
      expect((result as Success).value, testAddress);
      verify(() => mockDataSource.getAddressById(1)).called(1);
    });

    test('should return NotFoundFailure when address is null', () async {
      when(
        () => mockDataSource.getAddressById(1),
      ).thenAnswer((_) async => null);

      final result = await repository.getAddressById(1);

      expect(result, isA<Failure<AddressEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'Dirección no encontrada');
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.getAddressById(1),
      ).thenThrow(const StorageException(message: 'Read error'));

      final result = await repository.getAddressById(1);

      expect(result, isA<Failure<AddressEntity>>());
      expect((result as Failure).error, isA<StorageReadFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(() => mockDataSource.getAddressById(1)).thenThrow(Exception('Boom'));

      final result = await repository.getAddressById(1);

      expect(result, isA<Failure<AddressEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('getPrimaryAddress', () {
    test('should return Success with primary address when found', () async {
      when(
        () => mockDataSource.getPrimaryAddress(1),
      ).thenAnswer((_) async => testAddress);

      final result = await repository.getPrimaryAddress(1);

      expect(result, isA<Success<AddressEntity?>>());
      expect((result as Success).value, testAddress);
      verify(() => mockDataSource.getPrimaryAddress(1)).called(1);
    });

    test('should return Success with null when no primary address', () async {
      when(
        () => mockDataSource.getPrimaryAddress(1),
      ).thenAnswer((_) async => null);

      final result = await repository.getPrimaryAddress(1);

      expect(result, isA<Success<AddressEntity?>>());
      expect((result as Success).value, isNull);
    });

    test('should return StorageReadFailure on StorageException', () async {
      when(
        () => mockDataSource.getPrimaryAddress(1),
      ).thenThrow(const StorageException(message: 'Read error'));

      final result = await repository.getPrimaryAddress(1);

      expect(result, isA<Failure<AddressEntity?>>());
      expect((result as Failure).error, isA<StorageReadFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.getPrimaryAddress(1),
      ).thenThrow(Exception('Boom'));

      final result = await repository.getPrimaryAddress(1);

      expect(result, isA<Failure<AddressEntity?>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('createAddress', () {
    test('should return Success with created address', () async {
      when(
        () => mockDataSource.createAddress(testAddress),
      ).thenAnswer((_) async => testAddress);

      final result = await repository.createAddress(testAddress);

      expect(result, isA<Success<AddressEntity>>());
      expect((result as Success).value, testAddress);
      verify(() => mockDataSource.createAddress(testAddress)).called(1);
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.createAddress(testAddress),
      ).thenThrow(const StorageException(message: 'Create error'));

      final result = await repository.createAddress(testAddress);

      expect(result, isA<Failure<AddressEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<StorageFailure>());
      expect(failure.message, 'Create error');
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.createAddress(testAddress),
      ).thenThrow(Exception('Boom'));

      final result = await repository.createAddress(testAddress);

      expect(result, isA<Failure<AddressEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('updateAddress', () {
    test('should return Success with updated address', () async {
      when(
        () => mockDataSource.updateAddress(testAddress),
      ).thenAnswer((_) async => testAddress);

      final result = await repository.updateAddress(testAddress);

      expect(result, isA<Success<AddressEntity>>());
      expect((result as Success).value, testAddress);
      verify(() => mockDataSource.updateAddress(testAddress)).called(1);
    });

    test('should return NotFoundFailure on NotFoundException', () async {
      when(
        () => mockDataSource.updateAddress(testAddress),
      ).thenThrow(const NotFoundException(message: 'Address not found'));

      final result = await repository.updateAddress(testAddress);

      expect(result, isA<Failure<AddressEntity>>());
      final failure = (result as Failure).error;
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'Address not found');
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.updateAddress(testAddress),
      ).thenThrow(const StorageException(message: 'Update error'));

      final result = await repository.updateAddress(testAddress);

      expect(result, isA<Failure<AddressEntity>>());
      expect((result as Failure).error, isA<StorageFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.updateAddress(testAddress),
      ).thenThrow(Exception('Boom'));

      final result = await repository.updateAddress(testAddress);

      expect(result, isA<Failure<AddressEntity>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('deleteAddress', () {
    test('should return Success when deletion succeeds', () async {
      when(() => mockDataSource.deleteAddress(1)).thenAnswer((_) async => {});

      final result = await repository.deleteAddress(1);

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.deleteAddress(1)).called(1);
    });

    test('should return NotFoundFailure on NotFoundException', () async {
      when(
        () => mockDataSource.deleteAddress(1),
      ).thenThrow(const NotFoundException(message: 'Address not found'));

      final result = await repository.deleteAddress(1);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<NotFoundFailure>());
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.deleteAddress(1),
      ).thenThrow(const StorageException(message: 'Delete error'));

      final result = await repository.deleteAddress(1);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<StorageFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(() => mockDataSource.deleteAddress(1)).thenThrow(Exception('Boom'));

      final result = await repository.deleteAddress(1);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });

  group('setPrimaryAddress', () {
    test('should return Success when set primary succeeds', () async {
      when(
        () => mockDataSource.setPrimaryAddress(1, 1),
      ).thenAnswer((_) async => {});

      final result = await repository.setPrimaryAddress(1, 1);

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.setPrimaryAddress(1, 1)).called(1);
    });

    test('should return StorageFailure on StorageException', () async {
      when(
        () => mockDataSource.setPrimaryAddress(1, 1),
      ).thenThrow(const StorageException(message: 'Update error'));

      final result = await repository.setPrimaryAddress(1, 1);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<StorageFailure>());
    });

    test('should return UnknownFailure on unexpected exception', () async {
      when(
        () => mockDataSource.setPrimaryAddress(1, 1),
      ).thenThrow(Exception('Boom'));

      final result = await repository.setPrimaryAddress(1, 1);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<UnknownFailure>());
    });
  });
}
