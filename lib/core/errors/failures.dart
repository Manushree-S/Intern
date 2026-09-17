/// Base class for all domain-level failures handled by Riverpod controllers and UI.
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Unable to connect to the server. Please check your internet connection.',
    super.code = 'NETWORK_FAILURE',
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Access restricted: You do not have authorization to perform this action.',
    super.code = 'PERMISSION_FAILURE',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});
}
