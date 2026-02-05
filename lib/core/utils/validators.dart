class Validators {
  Validators._();

  /// Valida que un campo no esté vacío
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }

  /// Valida longitud mínima
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < min) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $min caracteres';
    }
    return null;
  }

  /// Valida longitud máxima
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length > max) {
      return '${fieldName ?? 'Este campo'} no puede exceder $max caracteres';
    }
    return null;
  }

  /// Valida formato de email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  /// Valida formato de teléfono (México)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    // Acepta formatos: 1234567890, 123-456-7890, (123) 456-7890
    final phoneRegex = RegExp(r'^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Ingresa un teléfono válido (10 dígitos)';
    }
    return null;
  }

  /// Valida formato de código postal (México)
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) return null;
    final postalCodeRegex = RegExp(r'^\d{5}$');
    if (!postalCodeRegex.hasMatch(value)) {
      return 'Ingresa un código postal válido (5 dígitos)';
    }
    return null;
  }

  /// Valida edad (entre min y max años)
  static String? age(DateTime? birthDate, {int min = 18, int max = 100}) {
    if (birthDate == null) return 'Selecciona tu fecha de nacimiento';

    final now = DateTime.now();
    var age = now.year - birthDate.year;

    // Ajustar si aún no ha cumplido años este año
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age < min) {
      return 'Debes tener al menos $min años';
    }
    if (age > max) {
      return 'Edad no válida';
    }
    return null;
  }

  /// Valida que la fecha no sea futura
  static String? notFutureDate(DateTime? date, {String? fieldName}) {
    if (date == null) return null;
    if (date.isAfter(DateTime.now())) {
      return '${fieldName ?? 'La fecha'} no puede ser futura';
    }
    return null;
  }

  /// Combina múltiples validadores
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Validador personalizado con expresión regular
  static String? pattern(String? value, RegExp regex, String errorMessage) {
    if (value == null || value.isEmpty) return null;
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Valida que solo contenga letras y espacios
  static String? onlyLetters(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    final lettersRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!lettersRegex.hasMatch(value)) {
      return '${fieldName ?? 'Este campo'} solo debe contener letras';
    }
    return null;
  }

  /// Valida que solo contenga números
  static String? onlyNumbers(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    final numbersRegex = RegExp(r'^\d+$');
    if (!numbersRegex.hasMatch(value)) {
      return '${fieldName ?? 'Este campo'} solo debe contener números';
    }
    return null;
  }

  /// Validador de nombre completo (nombre + apellido)
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }

    final nameParts = value.trim().split(' ');
    if (nameParts.length < 2) {
      return 'Ingresa nombre y apellido';
    }

    for (final part in nameParts) {
      if (part.length < 2) {
        return 'Cada parte del nombre debe tener al menos 2 caracteres';
      }
    }

    return null;
  }
}
