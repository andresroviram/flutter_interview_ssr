import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';
import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/repositories/address_repository.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/usecases/address_usecases.dart';

class MockAddressRepository extends Mock implements IAddressRepository {}

void main() {
  late AddressUseCases useCases;
  late MockAddressRepository mockRepository;

  setUp(() {
    mockRepository = MockAddressRepository();
    useCases = AddressUseCases(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      AddressEntity(
        id: 1,
        userId: 1,
        street: 'test',
        neighborhood: 'test',
        city: 'test',
        state: 'test',
        postalCode: '12345',
        label: AddressLabel.home,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      ),
    );
  });

  final testAddress = AddressEntity(
    id: 123,
    userId: 123,
    street: 'Calle Principal 123',
    neighborhood: 'Centro',
    city: 'Ciudad de México',
    state: 'CDMX',
    postalCode: '12345',
    label: AddressLabel.home,
    isPrimary: true,
    createdAt: DateTime(2024, 1, 15),
    updatedAt: null,
  );

  final testAddresses = [
    testAddress,
    AddressEntity(
      id: 456,
      userId: 123,
      street: 'Av. Reforma 456',
      neighborhood: 'Polanco',
      city: 'Ciudad de México',
      state: 'CDMX',
      postalCode: '54321',
      label: AddressLabel.work,
      isPrimary: false,
      createdAt: DateTime(2024, 1, 16),
      updatedAt: null,
    ),
  ];

  group('AddressUseCases.getAddressesByUserId', () {
    test('should return list of addresses from repository', () async {
      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => Success(testAddresses));

      final result = await useCases.getAddressesByUserId(123);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testAddresses);
      verify(() => mockRepository.getAddressesByUserId(123)).called(1);
    });

    test('should return failure when repository fails', () async {
      final failure = StorageFailure(message: 'Storage error');
      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.getAddressesByUserId(123);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('AddressUseCases.getAddressById', () {
    test('should return address when found', () async {
      when(
        () => mockRepository.getAddressById(123),
      ).thenAnswer((_) async => Success(testAddress));

      final result = await useCases.getAddressById(123);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testAddress);
      verify(() => mockRepository.getAddressById(123)).called(1);
    });

    test('should return failure when address not found', () async {
      final failure = NotFoundFailure(message: 'Address not found');
      when(
        () => mockRepository.getAddressById(999),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.getAddressById(999);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('AddressUseCases.getPrimaryAddress', () {
    test('should return primary address when exists', () async {
      when(
        () => mockRepository.getPrimaryAddress(123),
      ).thenAnswer((_) async => Success(testAddress));

      final result = await useCases.getPrimaryAddress(123);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, testAddress);
      verify(() => mockRepository.getPrimaryAddress(123)).called(1);
    });

    test('should return null when no primary address', () async {
      when(
        () => mockRepository.getPrimaryAddress(123),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCases.getPrimaryAddress(123);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, null);
    });
  });

  group('AddressUseCases.createAddress', () {
    test('should mark first address as primary automatically', () async {
      final newAddress = AddressEntity(
        id: 789,
        userId: 123,
        street: 'Nueva Calle',
        neighborhood: 'Nuevo Barrio',
        city: 'Ciudad',
        state: 'Estado',
        postalCode: '12345',
        label: AddressLabel.home,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => const Success([]));
      when(
        () => mockRepository.createAddress(any()),
      ).thenAnswer((_) async => Success(newAddress));

      final result = await useCases.createAddress(newAddress);

      expect(result.isSuccess, true);
      verify(() => mockRepository.getAddressesByUserId(123)).called(1);
      verify(() => mockRepository.createAddress(any())).called(1);
    });

    test('should create non-primary address when addresses exist', () async {
      final newAddress = AddressEntity(
        id: 789,
        userId: 123,
        street: 'Nueva Calle',
        neighborhood: 'Nuevo Barrio',
        city: 'Ciudad',
        state: 'Estado',
        postalCode: '12345',
        label: AddressLabel.home,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => Success(testAddresses));
      when(
        () => mockRepository.createAddress(any()),
      ).thenAnswer((_) async => Success(newAddress));

      final result = await useCases.createAddress(newAddress);

      expect(result.isSuccess, true);
      verify(() => mockRepository.createAddress(any())).called(1);
      verifyNever(() => mockRepository.setPrimaryAddress(any(), any()));
    });

    test(
      'should set new address as primary when explicitly requested',
      () async {
        final newAddress = AddressEntity(
          id: 789,
          userId: 123,
          street: 'Nueva Calle',
          neighborhood: 'Nuevo Barrio',
          city: 'Ciudad',
          state: 'Estado',
          postalCode: '12345',
          label: AddressLabel.home,
          isPrimary: true,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        when(
          () => mockRepository.getAddressesByUserId(123),
        ).thenAnswer((_) async => Success(testAddresses));
        when(
          () => mockRepository.createAddress(any()),
        ).thenAnswer((_) async => Success(newAddress));
        when(
          () => mockRepository.setPrimaryAddress(123, 789),
        ).thenAnswer((_) async => const Success(null));

        final result = await useCases.createAddress(newAddress);

        expect(result.isSuccess, true);
        verify(() => mockRepository.createAddress(any())).called(1);
        verify(() => mockRepository.setPrimaryAddress(123, 789)).called(1);
      },
    );

    test('should return failure when repository fails', () async {
      final failure = StorageFailure(message: 'Create failed');
      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.createAddress(testAddress);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('AddressUseCases.updateAddress', () {
    test('should update address when not primary', () async {
      final address = AddressEntity(
        id: 456,
        userId: 123,
        street: 'Updated Street',
        neighborhood: 'Updated Neighborhood',
        city: 'Updated City',
        state: 'Updated State',
        postalCode: '54321',
        label: AddressLabel.work,
        isPrimary: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAddress(any()),
      ).thenAnswer((_) async => Success(address));

      final result = await useCases.updateAddress(address);

      expect(result.isSuccess, true);
      verify(() => mockRepository.updateAddress(any())).called(1);
      verifyNever(() => mockRepository.setPrimaryAddress(any(), any()));
    });

    test('should call setPrimaryAddress when address is primary', () async {
      when(
        () => mockRepository.setPrimaryAddress(123, 123),
      ).thenAnswer((_) async => const Success(null));
      when(
        () => mockRepository.updateAddress(any()),
      ).thenAnswer((_) async => Success(testAddress));

      final result = await useCases.updateAddress(testAddress);

      expect(result.isSuccess, true);
      verify(() => mockRepository.setPrimaryAddress(123, 123)).called(1);
      verify(() => mockRepository.updateAddress(any())).called(1);
    });

    test('should return failure when setPrimaryAddress fails', () async {
      final failure = StorageFailure(message: 'Set primary failed');
      when(
        () => mockRepository.setPrimaryAddress(123, 123),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.updateAddress(testAddress);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
      verifyNever(() => mockRepository.updateAddress(any()));
    });
  });

  group('AddressUseCases.deleteAddress', () {
    test('should delete non-primary address without promoting', () async {
      final nonPrimaryAddress = AddressEntity(
        id: 456,
        userId: 123,
        street: 'Test Street',
        neighborhood: 'Test Neighborhood',
        city: 'Test City',
        state: 'Test State',
        postalCode: '54321',
        label: AddressLabel.work,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      when(
        () => mockRepository.getAddressById(456),
      ).thenAnswer((_) async => Success(nonPrimaryAddress));
      when(
        () => mockRepository.deleteAddress(456),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCases.deleteAddress(456);

      expect(result.isSuccess, true);
      verify(() => mockRepository.getAddressById(456)).called(1);
      verify(() => mockRepository.deleteAddress(456)).called(1);
      verifyNever(() => mockRepository.getAddressesByUserId(any()));
      verifyNever(() => mockRepository.setPrimaryAddress(any(), any()));
    });

    test('should delete last primary address without promoting', () async {
      when(
        () => mockRepository.getAddressById(123),
      ).thenAnswer((_) async => Success(testAddress));
      when(
        () => mockRepository.getAddressesByUserId(123),
      ).thenAnswer((_) async => Success([testAddress]));
      when(
        () => mockRepository.deleteAddress(123),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCases.deleteAddress(123);

      expect(result.isSuccess, true);
      verify(() => mockRepository.deleteAddress(123)).called(1);
      verifyNever(() => mockRepository.setPrimaryAddress(any(), any()));
    });

    test(
      'should promote next address when deleting primary with multiple addresses',
      () async {
        when(
          () => mockRepository.getAddressById(123),
        ).thenAnswer((_) async => Success(testAddress));
        when(
          () => mockRepository.getAddressesByUserId(123),
        ).thenAnswer((_) async => Success(testAddresses));
        when(
          () => mockRepository.deleteAddress(123),
        ).thenAnswer((_) async => const Success(null));
        when(
          () => mockRepository.setPrimaryAddress(123, 456),
        ).thenAnswer((_) async => const Success(null));

        final result = await useCases.deleteAddress(123);

        expect(result.isSuccess, true);
        verify(() => mockRepository.getAddressById(123)).called(1);
        verify(() => mockRepository.getAddressesByUserId(123)).called(1);
        verify(() => mockRepository.deleteAddress(123)).called(1);
        verify(() => mockRepository.setPrimaryAddress(123, 456)).called(1);
      },
    );

    test('should return failure when address not found', () async {
      final failure = NotFoundFailure(message: 'Address not found');
      when(
        () => mockRepository.getAddressById(999),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.deleteAddress(999);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });

    test('should return failure when delete fails', () async {
      final nonPrimaryAddress = AddressEntity(
        id: 456,
        userId: 123,
        street: 'Test Street',
        neighborhood: 'Test Neighborhood',
        city: 'Test City',
        state: 'Test State',
        postalCode: '54321',
        label: AddressLabel.work,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      final failure = StorageFailure(message: 'Delete failed');
      when(
        () => mockRepository.getAddressById(456),
      ).thenAnswer((_) async => Success(nonPrimaryAddress));
      when(
        () => mockRepository.deleteAddress(456),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.deleteAddress(456);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });

  group('AddressUseCases.setPrimaryAddress', () {
    test('should set address as primary', () async {
      when(
        () => mockRepository.setPrimaryAddress(123, 456),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCases.setPrimaryAddress(123, 456);

      expect(result.isSuccess, true);
      verify(() => mockRepository.setPrimaryAddress(123, 456)).called(1);
    });

    test('should return failure when set primary fails', () async {
      final failure = StorageFailure(message: 'Set primary failed');
      when(
        () => mockRepository.setPrimaryAddress(123, 456),
      ).thenAnswer((_) async => Failure(failure));

      final result = await useCases.setPrimaryAddress(123, 456);

      expect(result.isFailure, true);
      expect(result.errorOrNull, failure);
    });
  });
}
