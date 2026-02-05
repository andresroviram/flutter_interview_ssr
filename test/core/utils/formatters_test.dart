import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/utils/formatters.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es', null);
  });

  group('Formatters.formatDate', () {
    test('should format date in dd/MM/yyyy format', () {
      final date = DateTime(2024, 2, 15);
      final result = Formatters.formatDate(date);
      expect(result, '15/02/2024');
    });

    test('should handle single digit day and month', () {
      final date = DateTime(2024, 1, 5);
      final result = Formatters.formatDate(date);
      expect(result, '05/01/2024');
    });
  });

  group('Formatters.formatDateLong', () {
    test('should format date in long format', () {
      final date = DateTime(2024, 2, 15);
      final result = Formatters.formatDateLong(date);
      expect(result, '15 de febrero de 2024');
    });
  });

  group('Formatters.formatDateShort', () {
    test('should format date in short format', () {
      final date = DateTime(2024, 2, 15);
      final result = Formatters.formatDateShort(date);
      expect(result, '15 feb 2024');
    });
  });

  group('Formatters.formatDateTime', () {
    test('should format date with time', () {
      final dateTime = DateTime(2024, 2, 15, 14, 30);
      final result = Formatters.formatDateTime(dateTime);
      expect(result, '15/02/2024 14:30');
    });

    test('should pad single digit hours and minutes', () {
      final dateTime = DateTime(2024, 2, 15, 9, 5);
      final result = Formatters.formatDateTime(dateTime);
      expect(result, '15/02/2024 09:05');
    });
  });

  group('Formatters.formatTime', () {
    test('should format only time', () {
      final dateTime = DateTime(2024, 2, 15, 14, 30);
      final result = Formatters.formatTime(dateTime);
      expect(result, '14:30');
    });

    test('should pad single digit time', () {
      final dateTime = DateTime(2024, 2, 15, 9, 5);
      final result = Formatters.formatTime(dateTime);
      expect(result, '09:05');
    });
  });

  group('Formatters.formatPhone', () {
    test('should format 10 digit phone number', () {
      final result = Formatters.formatPhone('1234567890');
      expect(result, '(123) 456-7890');
    });

    test('should handle already formatted phone', () {
      final result = Formatters.formatPhone('(123) 456-7890');
      expect(result, '(123) 456-7890');
    });

    test('should return original when not 10 digits', () {
      final result = Formatters.formatPhone('12345');
      expect(result, '12345');
    });

    test('should remove non-numeric characters before formatting', () {
      final result = Formatters.formatPhone('123-456-7890');
      expect(result, '(123) 456-7890');
    });
  });

  group('Formatters.formatPostalCode', () {
    test('should format 5 digit postal code', () {
      final result = Formatters.formatPostalCode('12345');
      expect(result, '12345');
    });

    test('should remove non-numeric characters', () {
      final result = Formatters.formatPostalCode('123-45');
      expect(result, '12345');
    });

    test('should return original when not 5 digits', () {
      final result = Formatters.formatPostalCode('1234');
      expect(result, '1234');
    });
  });

  group('Formatters.capitalizeWords', () {
    test('should capitalize first letter of each word', () {
      final result = Formatters.capitalizeWords('hello world');
      expect(result, 'Hello World');
    });

    test('should handle already capitalized words', () {
      final result = Formatters.capitalizeWords('Hello World');
      expect(result, 'Hello World');
    });

    test('should handle mixed case', () {
      final result = Formatters.capitalizeWords('hELLO wORLD');
      expect(result, 'Hello World');
    });

    test('should handle empty string', () {
      final result = Formatters.capitalizeWords('');
      expect(result, '');
    });

    test('should handle multiple spaces', () {
      final result = Formatters.capitalizeWords('hello  world');
      expect(result, 'Hello  World');
    });
  });

  group('Formatters.capitalize', () {
    test('should capitalize only first letter', () {
      final result = Formatters.capitalize('hello world');
      expect(result, 'Hello world');
    });

    test('should handle already capitalized', () {
      final result = Formatters.capitalize('Hello world');
      expect(result, 'Hello world');
    });

    test('should handle empty string', () {
      final result = Formatters.capitalize('');
      expect(result, '');
    });
  });

  group('Formatters.truncate', () {
    test('should truncate text longer than maxLength', () {
      final result = Formatters.truncate('This is a long text', 10);
      expect(result, 'This is a ...');
    });

    test('should not truncate text shorter than maxLength', () {
      final result = Formatters.truncate('Short', 10);
      expect(result, 'Short');
    });

    test('should not truncate text equal to maxLength', () {
      final result = Formatters.truncate('1234567890', 10);
      expect(result, '1234567890');
    });
  });

  group('Formatters.formatNumber', () {
    test('should format number with thousands separator', () {
      final result = Formatters.formatNumber(1234567);
      expect(result, '1.234.567');
    });

    test('should handle small numbers', () {
      final result = Formatters.formatNumber(100);
      expect(result, '100');
    });

    test('should handle zero', () {
      final result = Formatters.formatNumber(0);
      expect(result, '0');
    });

    test('should handle decimal numbers', () {
      final result = Formatters.formatNumber(1234.56);
      expect(result, '1.235');
    });
  });

  group('Formatters.formatCurrency', () {
    test('should format currency with symbol at end', () {
      final result = Formatters.formatCurrency(1234567);
      expect(result, '1.234.567\u00A0\$');
    });

    test('should handle small amounts', () {
      final result = Formatters.formatCurrency(100);
      expect(result, '100\u00A0\$');
    });

    test('should handle zero', () {
      final result = Formatters.formatCurrency(0);
      expect(result, '0\u00A0\$');
    });

    test('should not include decimals', () {
      final result = Formatters.formatCurrency(1234.56);
      expect(result, '1.235\u00A0\$');
    });
  });

  group('Formatters.calculateAge', () {
    test('should calculate age correctly', () {
      final birthDate = DateTime(1990, 5, 20);
      final age = Formatters.calculateAge(birthDate);
      // Age depends on current date, so we verify it's positive and reasonable
      expect(age, greaterThan(30));
      expect(age, lessThan(100));
    });

    test('should handle birthday not yet occurred this year', () {
      final now = DateTime.now();
      // Birthday in December of birth year (likely not occurred yet if run before December)
      final birthDate = DateTime(now.year - 25, 12, 31);
      final age = Formatters.calculateAge(birthDate);
      // Age should be either 24 or 25 depending on current date
      expect(age, greaterThanOrEqualTo(24));
      expect(age, lessThanOrEqualTo(25));
    });

    test('should handle birthday already occurred this year', () {
      final now = DateTime.now();
      // Birthday in January (likely already occurred)
      final birthDate = DateTime(now.year - 25, 1, 1);
      final age = Formatters.calculateAge(birthDate);
      // Age should be either 24 or 25 depending on current date
      expect(age, greaterThanOrEqualTo(24));
      expect(age, lessThanOrEqualTo(25));
    });

    test('should return 0 for birth date this year', () {
      final now = DateTime.now();
      final birthDate = DateTime(now.year, 1, 1);
      final age = Formatters.calculateAge(birthDate);
      expect(age, equals(0));
    });
  });

  group('Formatters.getInitials', () {
    test('should get initials from two words', () {
      final result = Formatters.getInitials('John Doe');
      expect(result, 'JD');
    });

    test('should get initials from three words', () {
      final result = Formatters.getInitials('John Michael Doe');
      expect(result, 'JM'); // Default maxLength is 2
    });

    test('should respect maxLength parameter', () {
      final result = Formatters.getInitials('John Michael Doe', maxLength: 3);
      expect(result, 'JMD');
    });

    test('should handle single word', () {
      final result = Formatters.getInitials('John');
      expect(result, 'J');
    });

    test('should handle empty string', () {
      final result = Formatters.getInitials('');
      expect(result, '');
    });

    test('should handle multiple spaces', () {
      final result = Formatters.getInitials('John  Doe');
      expect(result, 'JD');
    });

    test('should uppercase initials', () {
      final result = Formatters.getInitials('john doe');
      expect(result, 'JD');
    });
  });

  group('Formatters.cleanString', () {
    test('should remove leading and trailing spaces', () {
      final result = Formatters.cleanString('  hello  ');
      expect(result, 'hello');
    });

    test('should replace multiple spaces with single space', () {
      final result = Formatters.cleanString('hello    world');
      expect(result, 'hello world');
    });

    test('should handle both trimming and space replacement', () {
      final result = Formatters.cleanString('  hello    world  ');
      expect(result, 'hello world');
    });

    test('should handle string with no extra spaces', () {
      final result = Formatters.cleanString('hello world');
      expect(result, 'hello world');
    });
  });

  group('Formatters.toProperCase', () {
    test('should convert to proper case', () {
      final result = Formatters.toProperCase('hello world');
      expect(result, 'Hello World');
    });

    test('should handle all uppercase', () {
      final result = Formatters.toProperCase('HELLO WORLD');
      expect(result, 'Hello World');
    });

    test('should handle mixed case', () {
      final result = Formatters.toProperCase('hELLO wORLD');
      expect(result, 'Hello World');
    });

    test('should handle single word', () {
      final result = Formatters.toProperCase('hello');
      expect(result, 'Hello');
    });
  });
}
