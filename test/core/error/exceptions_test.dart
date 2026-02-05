import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/error/exceptions.dart';

void main() {
  group('AppException', () {
    test('should create exception with message and status code', () {
      const exception = AppException(message: 'Test error', statusCode: 400);
      expect(exception.message, 'Test error');
      expect(exception.statusCode, 400);
    });

    test('should create exception without status code', () {
      const exception = AppException(message: 'Test error');
      expect(exception.message, 'Test error');
      expect(exception.statusCode, isNull);
    });

    test('toString should return formatted string', () {
      const exception = AppException(message: 'Test error', statusCode: 400);
      expect(exception.toString(), 'AppException: Test error (code: 400)');
    });

    test('toString should handle null status code', () {
      const exception = AppException(message: 'Test error');
      expect(exception.toString(), 'AppException: Test error (code: null)');
    });
  });

  group('ServerException', () {
    test('should have default message and status code', () {
      const exception = ServerException();
      expect(exception.message, 'Server error');
      expect(exception.statusCode, 500);
    });

    test('should allow custom message', () {
      const exception = ServerException(message: 'Custom server error');
      expect(exception.message, 'Custom server error');
      expect(exception.statusCode, 500);
    });

    test('should allow custom status code', () {
      const exception = ServerException(statusCode: 503);
      expect(exception.message, 'Server error');
      expect(exception.statusCode, 503);
    });
  });

  group('CacheException', () {
    test('should have default message', () {
      const exception = CacheException();
      expect(exception.message, 'Cache error');
      expect(exception.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const exception = CacheException(
        message: 'Custom cache error',
        statusCode: 500,
      );
      expect(exception.message, 'Custom cache error');
      expect(exception.statusCode, 500);
    });
  });

  group('NetworkException', () {
    test('should have default message', () {
      const exception = NetworkException();
      expect(exception.message, 'Network error');
      expect(exception.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const exception = NetworkException(
        message: 'No internet connection',
        statusCode: 503,
      );
      expect(exception.message, 'No internet connection');
      expect(exception.statusCode, 503);
    });
  });

  group('TimeoutException', () {
    test('should have default message and status code', () {
      const exception = TimeoutException();
      expect(exception.message, 'Request timeout');
      expect(exception.statusCode, 408);
    });

    test('should allow custom message', () {
      const exception = TimeoutException(message: 'Connection timed out');
      expect(exception.message, 'Connection timed out');
      expect(exception.statusCode, 408);
    });
  });

  group('FormatException', () {
    test('should have default message', () {
      const exception = FormatException();
      expect(exception.message, 'Format error');
      expect(exception.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const exception = FormatException(
        message: 'Invalid JSON format',
        statusCode: 400,
      );
      expect(exception.message, 'Invalid JSON format');
      expect(exception.statusCode, 400);
    });
  });

  group('ValidationException', () {
    test('should have default message', () {
      const exception = ValidationException();
      expect(exception.message, 'Validation error');
      expect(exception.errors, isNull);
      expect(exception.statusCode, isNull);
    });

    test('should allow errors map', () {
      const errors = {'email': 'Invalid email', 'password': 'Too short'};
      const exception = ValidationException(errors: errors);
      expect(exception.message, 'Validation error');
      expect(exception.errors, errors);
    });

    test('toString should include errors', () {
      const errors = {'email': 'Invalid email'};
      const exception = ValidationException(
        message: 'Form validation failed',
        errors: errors,
      );
      expect(
        exception.toString(),
        'ValidationException: Form validation failed, errors: {email: Invalid email}',
      );
    });
  });

  group('StorageException', () {
    test('should have default message', () {
      const exception = StorageException();
      expect(exception.message, 'Storage error');
      expect(exception.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const exception = StorageException(
        message: 'Database write failed',
        statusCode: 500,
      );
      expect(exception.message, 'Database write failed');
      expect(exception.statusCode, 500);
    });
  });

  group('NotFoundException', () {
    test('should have default message and status code', () {
      const exception = NotFoundException();
      expect(exception.message, 'Not found');
      expect(exception.statusCode, 404);
    });

    test('should allow custom message', () {
      const exception = NotFoundException(message: 'User not found');
      expect(exception.message, 'User not found');
      expect(exception.statusCode, 404);
    });

    test('should allow custom status code', () {
      const exception = NotFoundException(statusCode: 410);
      expect(exception.message, 'Not found');
      expect(exception.statusCode, 410);
    });
  });
}
