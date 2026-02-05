class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error',
    super.statusCode = 500,
  });
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error', super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Network error', super.statusCode});
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.statusCode = 408,
  });
}

class FormatException extends AppException {
  const FormatException({super.message = 'Format error', super.statusCode});
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException({
    super.message = 'Validation error',
    this.errors,
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException: $message, errors: $errors';
}

class StorageException extends AppException {
  const StorageException({super.message = 'Storage error', super.statusCode});
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Not found',
    super.statusCode = 404,
  });
}
