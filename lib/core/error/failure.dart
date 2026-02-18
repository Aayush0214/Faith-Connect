import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;     // Human-readable message
  final int? code;       // Optional error code (like HTTP code or custom tag)
  final dynamic cause;      // Optional raw exception
  final StackTrace? stack;  // Stack trace for debugging

  const Failure({
    required this.message,
    this.code,
    this.cause,
    this.stack,
  });

  @override
  List<Object?> get props => [message, code, cause, stack];

  @override
  String toString() => 'Failure(message: $message, code: $code, cause: $cause)';
}

/// No internet / timeout / DNS issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// Authentication or invalid credentials
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// UnAuthorization Failure
class UnAuthorizationFailure extends Failure {
  const UnAuthorizationFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// Permission Failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}


class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// Unknown / unhandled / fallback failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// Server-side or API failure
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}

/// Local cache / database / SharedPrefs failure
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.cause,
    super.stack,
  });
}
