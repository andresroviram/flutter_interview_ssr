import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/result.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';

void main() {
  group('Success', () {
    test('should create Success with value', () {
      const success = Success(42);
      expect(success.value, 42);
    });

    test('should be equal when values are equal', () {
      const success1 = Success(42);
      const success2 = Success(42);
      expect(success1, equals(success2));
    });

    test('should not be equal when values differ', () {
      const success1 = Success(42);
      const success2 = Success(43);
      expect(success1, isNot(equals(success2)));
    });

    test('should have same hashCode when values are equal', () {
      const success1 = Success(42);
      const success2 = Success(42);
      expect(success1.hashCode, equals(success2.hashCode));
    });

    test('toString should return formatted string', () {
      const success = Success(42);
      expect(success.toString(), 'Success(value: 42)');
    });

    test('should work with complex objects', () {
      const success = Success<String>('test data');
      expect(success.value, 'test data');
    });
  });

  group('Failure', () {
    const testFailure = ServerFailure(message: 'Test error');

    test('should create Failure with error', () {
      const failure = Failure(testFailure);
      expect(failure.error, testFailure);
    });

    test('should be equal when errors are equal', () {
      const failure1 = Failure(testFailure);
      const failure2 = Failure(testFailure);
      expect(failure1, equals(failure2));
    });

    test('should not be equal when errors differ', () {
      const failure1 = Failure(ServerFailure(message: 'Error 1'));
      const failure2 = Failure(ServerFailure(message: 'Error 2'));
      expect(failure1, isNot(equals(failure2)));
    });

    test('should have same hashCode when errors are equal', () {
      const failure1 = Failure(testFailure);
      const failure2 = Failure(testFailure);
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('toString should return formatted string', () {
      const failure = Failure(testFailure);
      expect(failure.toString(), contains('Failure'));
      expect(failure.toString(), contains('error:'));
    });
  });

  group('ResultExtensions - map', () {
    test('should transform Success value', () {
      const result = Success(5);
      final transformed = result.map((v) => v * 2);

      expect(transformed, isA<Success<int>>());
      expect((transformed as Success).value, 10);
    });

    test('should preserve Failure', () {
      const failure = ServerFailure();
      const result = Failure<int>(failure);
      final transformed = result.map((v) => v * 2);

      expect(transformed, isA<Failure<int>>());
      expect((transformed as Failure).error, failure);
    });

    test('should change value type', () {
      const result = Success(42);
      final transformed = result.map((v) => 'Number: $v');

      expect(transformed, isA<Success<String>>());
      expect((transformed as Success).value, 'Number: 42');
    });
  });

  group('ResultExtensions - flatMap', () {
    test('should chain Success results', () {
      const result = Success(5);
      final transformed = result.flatMap((v) => Success(v * 2));

      expect(transformed, isA<Success<int>>());
      expect((transformed as Success).value, 10);
    });

    test('should return Failure from transform', () {
      const result = Success(5);
      const failure = ValidationFailure();
      final transformed = result.flatMap<int>((v) => Failure(failure));

      expect(transformed, isA<Failure<int>>());
      expect((transformed as Failure).error, failure);
    });

    test('should preserve original Failure', () {
      const originalFailure = ServerFailure();
      const result = Failure<int>(originalFailure);
      final transformed = result.flatMap((v) => Success(v * 2));

      expect(transformed, isA<Failure<int>>());
      expect((transformed as Failure).error, originalFailure);
    });

    test('should work with chained operations', () {
      const result = Success(10);
      final transformed = result
          .flatMap((v) => Success(v + 5))
          .flatMap((v) => Success(v * 2));

      expect(transformed, isA<Success<int>>());
      expect((transformed as Success).value, 30); // (10 + 5) * 2
    });
  });

  group('ResultExtensions - fold', () {
    test('should call onSuccess for Success', () {
      const result = Success(42);
      final output = result.fold(
        onSuccess: (v) => 'Success: $v',
        onFailure: (e) => 'Failure: $e',
      );

      expect(output, 'Success: 42');
    });

    test('should call onFailure for Failure', () {
      const failure = NetworkFailure(message: 'No connection');
      const result = Failure<int>(failure);
      final output = result.fold(
        onSuccess: (v) => 'Success: $v',
        onFailure: (e) => 'Failure: ${e.message}',
      );

      expect(output, 'Failure: No connection');
    });

    test('should return different types from fold', () {
      const result = Success('test');
      final intOutput = result.fold<int>(
        onSuccess: (v) => v.length,
        onFailure: (e) => 0,
      );

      expect(intOutput, 4);
    });
  });

  group('ResultExtensions - isSuccess', () {
    test('should return true for Success', () {
      const result = Success(42);
      expect(result.isSuccess, true);
    });

    test('should return false for Failure', () {
      const result = Failure<int>(ServerFailure());
      expect(result.isSuccess, false);
    });
  });

  group('ResultExtensions - isFailure', () {
    test('should return true for Failure', () {
      const result = Failure<int>(ServerFailure());
      expect(result.isFailure, true);
    });

    test('should return false for Success', () {
      const result = Success(42);
      expect(result.isFailure, false);
    });
  });

  group('ResultExtensions - valueOrNull', () {
    test('should return value for Success', () {
      const result = Success(42);
      expect(result.valueOrNull, 42);
    });

    test('should return null for Failure', () {
      const result = Failure<int>(ServerFailure());
      expect(result.valueOrNull, null);
    });

    test('should work with nullable values', () {
      const result = Success<String?>('test');
      expect(result.valueOrNull, 'test');
    });
  });

  group('ResultExtensions - errorOrNull', () {
    test('should return error for Failure', () {
      const failure = ServerFailure();
      const result = Failure<int>(failure);
      expect(result.errorOrNull, failure);
    });

    test('should return null for Success', () {
      const result = Success(42);
      expect(result.errorOrNull, null);
    });
  });

  group('Result complex scenarios', () {
    test('should handle chain of operations ending in Success', () {
      const result = Success(10);
      final output = result
          .map((v) => v + 5)
          .map((v) => v * 2)
          .fold(
            onSuccess: (v) => 'Result: $v',
            onFailure: (e) => 'Error: ${e.message}',
          );

      expect(output, 'Result: 30');
    });

    test('should handle chain of operations ending in Failure', () {
      const failure = ValidationFailure(message: 'Invalid input');
      const result = Failure<int>(failure);
      final output = result
          .map((v) => v + 5)
          .map((v) => v * 2)
          .fold(
            onSuccess: (v) => 'Result: $v',
            onFailure: (e) => 'Error: ${e.message}',
          );

      expect(output, 'Error: Invalid input');
    });

    test('should short-circuit on first Failure in flatMap chain', () {
      const failure = ServerFailure();
      const result = Success(10);
      final output = result
          .flatMap((v) => Success(v + 5))
          .flatMap<int>((v) => Failure(failure))
          .flatMap((v) => Success(v * 2)); // Should not execute

      expect(output, isA<Failure<int>>());
      expect((output as Failure).error, failure);
    });
  });
}
