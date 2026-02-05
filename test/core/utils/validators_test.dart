import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('should return error when value is null', () {
      final result = Validators.required(null);
      expect(result, 'Este campo es requerido');
    });

    test('should return error when value is empty', () {
      final result = Validators.required('');
      expect(result, 'Este campo es requerido');
    });

    test('should return error when value is only whitespace', () {
      final result = Validators.required('   ');
      expect(result, 'Este campo es requerido');
    });

    test('should return null when value is valid', () {
      final result = Validators.required('valid value');
      expect(result, null);
    });

    test('should use custom field name in error message', () {
      final result = Validators.required(null, fieldName: 'Nombre');
      expect(result, 'Nombre es requerido');
    });
  });

  group('Validators.minLength', () {
    test('should return null when value is null', () {
      final result = Validators.minLength(null, 5);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.minLength('', 5);
      expect(result, null);
    });

    test('should return error when value is too short', () {
      final result = Validators.minLength('abc', 5);
      expect(result, 'Este campo debe tener al menos 5 caracteres');
    });

    test('should return null when value meets minimum length', () {
      final result = Validators.minLength('abcde', 5);
      expect(result, null);
    });

    test('should return null when value exceeds minimum length', () {
      final result = Validators.minLength('abcdef', 5);
      expect(result, null);
    });
  });

  group('Validators.maxLength', () {
    test('should return null when value is null', () {
      final result = Validators.maxLength(null, 10);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.maxLength('', 10);
      expect(result, null);
    });

    test('should return error when value is too long', () {
      final result = Validators.maxLength('12345678901', 10);
      expect(result, 'Este campo no puede exceder 10 caracteres');
    });

    test('should return null when value meets maximum length', () {
      final result = Validators.maxLength('1234567890', 10);
      expect(result, null);
    });

    test('should return null when value is below maximum length', () {
      final result = Validators.maxLength('123', 10);
      expect(result, null);
    });
  });

  group('Validators.email', () {
    test('should return null when value is null', () {
      final result = Validators.email(null);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.email('');
      expect(result, null);
    });

    test('should return error for invalid email format - no @', () {
      final result = Validators.email('invalidemail.com');
      expect(result, 'Ingresa un email válido');
    });

    test('should return error for invalid email format - no domain', () {
      final result = Validators.email('user@');
      expect(result, 'Ingresa un email válido');
    });

    test('should return error for invalid email format - no extension', () {
      final result = Validators.email('user@domain');
      expect(result, 'Ingresa un email válido');
    });

    test('should return null for valid email', () {
      final result = Validators.email('user@example.com');
      expect(result, null);
    });

    test('should return null for valid email with subdomain', () {
      final result = Validators.email('user@mail.example.com');
      expect(result, null);
    });

    test('should return null for valid email with numbers', () {
      final result = Validators.email('user123@example.com');
      expect(result, null);
    });
  });

  group('Validators.phone', () {
    test('should return null when value is null', () {
      final result = Validators.phone(null);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.phone('');
      expect(result, null);
    });

    test('should return error for invalid phone - too short', () {
      final result = Validators.phone('123456');
      expect(result, 'Ingresa un teléfono válido (10 dígitos)');
    });

    test('should return null for valid phone - 10 digits', () {
      final result = Validators.phone('1234567890');
      expect(result, null);
    });

    test('should return null for valid phone with dashes', () {
      final result = Validators.phone('123-456-7890');
      expect(result, null);
    });

    test('should return null for valid phone with parentheses', () {
      final result = Validators.phone('(123) 456-7890');
      expect(result, null);
    });
  });

  group('Validators.postalCode', () {
    test('should return null when value is null', () {
      final result = Validators.postalCode(null);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.postalCode('');
      expect(result, null);
    });

    test('should return error for invalid postal code - too short', () {
      final result = Validators.postalCode('1234');
      expect(result, 'Ingresa un código postal válido (5 dígitos)');
    });

    test('should return error for invalid postal code - too long', () {
      final result = Validators.postalCode('123456');
      expect(result, 'Ingresa un código postal válido (5 dígitos)');
    });

    test('should return error for postal code with letters', () {
      final result = Validators.postalCode('1234A');
      expect(result, 'Ingresa un código postal válido (5 dígitos)');
    });

    test('should return null for valid postal code', () {
      final result = Validators.postalCode('12345');
      expect(result, null);
    });
  });

  group('Validators.age', () {
    test('should return error when date is null', () {
      final result = Validators.age(null);
      expect(result, 'Selecciona tu fecha de nacimiento');
    });

    test('should return error when age is less than minimum', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 17));
      final result = Validators.age(birthDate);
      expect(result, 'Debes tener al menos 18 años');
    });

    test('should return null when age is exactly minimum', () {
      // Crear fecha de nacimiento hace exactamente 18 años
      final now = DateTime.now();
      final birthDate = DateTime(now.year - 18, now.month, now.day);
      final result = Validators.age(birthDate);
      expect(result, null);
    });

    test('should return null when age is within valid range', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 30));
      final result = Validators.age(birthDate);
      expect(result, null);
    });

    test('should return error when age exceeds maximum', () {
      // Crear fecha de nacimiento hace más de 100 años
      final now = DateTime.now();
      final birthDate = DateTime(now.year - 101, now.month, now.day);
      final result = Validators.age(birthDate);
      expect(result, 'Edad no válida');
    });

    test('should use custom min and max values', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 15));
      final result = Validators.age(birthDate, min: 21);
      expect(result, 'Debes tener al menos 21 años');
    });
  });

  group('Validators.notFutureDate', () {
    test('should return null when date is null', () {
      final result = Validators.notFutureDate(null);
      expect(result, null);
    });

    test('should return null when date is in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final result = Validators.notFutureDate(pastDate);
      expect(result, null);
    });

    test('should return null when date is today', () {
      final today = DateTime.now();
      final result = Validators.notFutureDate(today);
      expect(result, null);
    });

    test('should return error when date is in the future', () {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final result = Validators.notFutureDate(futureDate);
      expect(result, 'La fecha no puede ser futura');
    });
  });

  group('Validators.onlyLetters', () {
    test('should return null when value is null', () {
      final result = Validators.onlyLetters(null);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.onlyLetters('');
      expect(result, null);
    });

    test('should return error when value contains numbers', () {
      final result = Validators.onlyLetters('John123');
      expect(result, 'Este campo solo debe contener letras');
    });

    test('should return error when value contains special characters', () {
      final result = Validators.onlyLetters('John@Doe');
      expect(result, 'Este campo solo debe contener letras');
    });

    test('should return null for valid letters', () {
      final result = Validators.onlyLetters('John Doe');
      expect(result, null);
    });

    test('should return null for letters with accents', () {
      final result = Validators.onlyLetters('José María');
      expect(result, null);
    });
  });

  group('Validators.onlyNumbers', () {
    test('should return null when value is null', () {
      final result = Validators.onlyNumbers(null);
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.onlyNumbers('');
      expect(result, null);
    });

    test('should return error when value contains letters', () {
      final result = Validators.onlyNumbers('123abc');
      expect(result, 'Este campo solo debe contener números');
    });

    test('should return error when value contains special characters', () {
      final result = Validators.onlyNumbers('123-456');
      expect(result, 'Este campo solo debe contener números');
    });

    test('should return null for valid numbers', () {
      final result = Validators.onlyNumbers('1234567890');
      expect(result, null);
    });
  });

  group('Validators.fullName', () {
    test('should return error when value is null', () {
      final result = Validators.fullName(null);
      expect(result, 'El nombre es requerido');
    });

    test('should return error when value is empty', () {
      final result = Validators.fullName('');
      expect(result, 'El nombre es requerido');
    });

    test('should return error when only one name part', () {
      final result = Validators.fullName('John');
      expect(result, 'Ingresa nombre y apellido');
    });

    test('should return error when name part is too short', () {
      final result = Validators.fullName('A B');
      expect(result, 'Cada parte del nombre debe tener al menos 2 caracteres');
    });

    test('should return null for valid full name', () {
      final result = Validators.fullName('John Doe');
      expect(result, null);
    });

    test('should return null for full name with multiple parts', () {
      final result = Validators.fullName('John Michael Doe');
      expect(result, null);
    });
  });

  group('Validators.combine', () {
    test('should return null when all validators pass', () {
      final validator = Validators.combine([
        (value) => Validators.required(value),
        (value) => Validators.minLength(value, 3),
        (value) => Validators.maxLength(value, 10),
      ]);

      final result = validator('valid');
      expect(result, null);
    });

    test('should return first error when validators fail', () {
      final validator = Validators.combine([
        (value) => Validators.required(value),
        (value) => Validators.minLength(value, 10),
      ]);

      final result = validator('short');
      expect(result, 'Este campo debe tener al menos 10 caracteres');
    });

    test('should return required error before other errors', () {
      final validator = Validators.combine([
        (value) => Validators.required(value),
        (value) => Validators.minLength(value, 5),
      ]);

      final result = validator('');
      expect(result, 'Este campo es requerido');
    });
  });

  group('Validators.pattern', () {
    test('should return null when value is null', () {
      final result = Validators.pattern(null, RegExp(r'^\d+$'), 'Solo números');
      expect(result, null);
    });

    test('should return null when value is empty', () {
      final result = Validators.pattern('', RegExp(r'^\d+$'), 'Solo números');
      expect(result, null);
    });

    test('should return error when pattern does not match', () {
      final result = Validators.pattern(
        'abc',
        RegExp(r'^\d+$'),
        'Solo números permitidos',
      );
      expect(result, 'Solo números permitidos');
    });

    test('should return null when pattern matches', () {
      final result = Validators.pattern(
        '12345',
        RegExp(r'^\d+$'),
        'Solo números',
      );
      expect(result, null);
    });
  });
}
