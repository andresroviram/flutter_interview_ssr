import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/error/failures.dart';

void main() {
  group('NetworkFailure', () {
    test('should have default message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Error de conexión. Verifica tu internet.');
      expect(failure.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const failure = NetworkFailure(
        message: 'Custom network error',
        statusCode: 503,
      );
      expect(failure.message, 'Custom network error');
      expect(failure.statusCode, 503);
    });

    test('toString should return formatted string', () {
      const failure = NetworkFailure();
      expect(failure.toString(), contains('NetworkFailure'));
    });
  });

  group('ServerFailure', () {
    test('should have default message and status code', () {
      const failure = ServerFailure();
      expect(failure.message, 'Error del servidor. Intenta más tarde.');
      expect(failure.statusCode, 500);
    });

    test('should allow custom message', () {
      const failure = ServerFailure(message: 'Internal server error');
      expect(failure.message, 'Internal server error');
      expect(failure.statusCode, 500);
    });
  });

  group('TimeoutFailure', () {
    test('should have default message and status code', () {
      const failure = TimeoutFailure();
      expect(
        failure.message,
        'La solicitud tardó demasiado. Intenta de nuevo.',
      );
      expect(failure.statusCode, 408);
    });
  });

  group('CacheFailure', () {
    test('should have default message', () {
      const failure = CacheFailure();
      expect(failure.message, 'Error al acceder a los datos locales.');
      expect(failure.statusCode, isNull);
    });
  });

  group('ValidationFailure', () {
    test('should have default message', () {
      const failure = ValidationFailure();
      expect(failure.message, 'Los datos ingresados no son válidos.');
      expect(failure.statusCode, isNull);
    });

    test('should allow errors map', () {
      const errors = {'email': 'Email inválido', 'password': 'Muy corta'};
      const failure = ValidationFailure(errors: errors);
      expect(failure.message, 'Los datos ingresados no son válidos.');
      expect(failure.errors, errors);
    });

    test('props should include errors', () {
      const errors = {'email': 'Email inválido'};
      const failure = ValidationFailure(errors: errors);
      expect(failure.props, contains(errors));
    });
  });

  group('NotFoundFailure', () {
    test('should have default message and status code', () {
      const failure = NotFoundFailure();
      expect(failure.message, 'No se encontró el recurso solicitado.');
      expect(failure.statusCode, 404);
    });

    test('should allow custom message', () {
      const failure = NotFoundFailure(message: 'Usuario no encontrado');
      expect(failure.message, 'Usuario no encontrado');
      expect(failure.statusCode, 404);
    });
  });

  group('AuthFailure', () {
    test('should have default message and status code', () {
      const failure = AuthFailure();
      expect(failure.message, 'Error de autenticación.');
      expect(failure.statusCode, 401);
    });
  });

  group('UnauthorizedFailure', () {
    test('should have default message and status code', () {
      const failure = UnauthorizedFailure();
      expect(failure.message, 'No tienes permiso para realizar esta acción.');
      expect(failure.statusCode, 403);
    });
  });

  group('InputFailure', () {
    test('should have default message', () {
      const failure = InputFailure();
      expect(failure.message, 'Entrada inválida.');
      expect(failure.statusCode, isNull);
    });

    test('should allow custom message and status code', () {
      const failure = InputFailure(
        message: 'Invalid input format',
        statusCode: 400,
      );
      expect(failure.message, 'Invalid input format');
      expect(failure.statusCode, 400);
    });
  });

  group('DuplicateFailure', () {
    test('should have default message and status code', () {
      const failure = DuplicateFailure();
      expect(failure.message, 'El recurso ya existe.');
      expect(failure.statusCode, 409);
    });
  });

  group('StorageFailure', () {
    test('should have default message', () {
      const failure = StorageFailure();
      expect(failure.message, 'Error al guardar los datos.');
      expect(failure.statusCode, isNull);
    });
  });

  group('StorageReadFailure', () {
    test('should have default message', () {
      const failure = StorageReadFailure();
      expect(failure.message, 'Error al leer los datos almacenados.');
      expect(failure.statusCode, isNull);
    });
  });

  group('UnknownFailure', () {
    test('should have default message', () {
      const failure = UnknownFailure();
      expect(failure.message, 'Ocurrió un error inesperado.');
      expect(failure.statusCode, isNull);
    });
  });

  group('Failures equality', () {
    test('same Failures with same values should be equal', () {
      const failure1 = NetworkFailure();
      const failure2 = NetworkFailure();
      expect(failure1, equals(failure2));
    });

    test('same Failures with different values should not be equal', () {
      const failure1 = NetworkFailure(message: 'Error 1');
      const failure2 = NetworkFailure(message: 'Error 2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('different Failure types should not be equal', () {
      const failure1 = NetworkFailure();
      const failure2 = ServerFailure();
      expect(failure1, isNot(equals(failure2)));
    });

    test('ValidationFailure with same errors should be equal', () {
      const errors = {'email': 'Invalid'};
      const failure1 = ValidationFailure(errors: errors);
      const failure2 = ValidationFailure(errors: errors);
      expect(failure1, equals(failure2));
    });
  });

  group('Failures toString', () {
    test('should include runtime type and properties', () {
      const failure = ServerFailure(message: 'Test error', statusCode: 500);
      final str = failure.toString();
      expect(str, contains('ServerFailure'));
      expect(str, contains('Test error'));
      expect(str, contains('500'));
    });
  });
}
