import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Formatea una fecha en formato dd/MM/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatea una fecha en formato largo (ej: 15 de febrero de 2026)
  static String formatDateLong(DateTime date) {
    return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);
  }

  /// Formatea una fecha en formato corto (ej: 15 feb 2026)
  static String formatDateShort(DateTime date) {
    return DateFormat('d MMM yyyy', 'es').format(date);
  }

  /// Formatea una fecha con hora (ej: 15/02/2026 14:30)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formatea solo la hora (ej: 14:30)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Formatea un teléfono en formato (XXX) XXX-XXXX
  static String formatPhone(String phone) {
    // Remover caracteres no numéricos
    final numbers = phone.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 10) return phone;

    return '(${numbers.substring(0, 3)}) ${numbers.substring(3, 6)}-${numbers.substring(6)}';
  }

  /// Formatea un código postal
  static String formatPostalCode(String postalCode) {
    final numbers = postalCode.replaceAll(RegExp(r'\D'), '');
    return numbers.length == 5 ? numbers : postalCode;
  }

  /// Capitaliza la primera letra de cada palabra
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Capitaliza solo la primera letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Trunca texto con ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formatea un número con separadores de miles
  static String formatNumber(num number) {
    return NumberFormat('#,##0', 'es').format(number);
  }

  /// Formatea moneda (peso colombiano)
  static String formatCurrency(num amount) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Calcula la edad a partir de una fecha de nacimiento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Convierte texto a initials (ej: "Juan Pérez" -> "JP")
  static String getInitials(String name, {int maxLength = 2}) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    final initials = words
        .where((word) => word.isNotEmpty)
        .take(maxLength)
        .map((word) => word[0].toUpperCase())
        .join();

    return initials;
  }

  /// Limpia un string removiendo espacios extras
  static String cleanString(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Convierte a formato de nombre propio
  static String toProperCase(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
