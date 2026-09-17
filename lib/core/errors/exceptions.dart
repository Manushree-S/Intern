/// Base class for all application-level exceptions.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.details});
}

class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.details});
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No active internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'You do not have permission to access this resource.',
    super.code = 'PERMISSION_DENIED',
  });
}

class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

class ValidationException extends AppException {
  const ValidationException({required super.message, super.code});
}
