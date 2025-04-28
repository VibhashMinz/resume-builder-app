abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure() : super('User is not authenticated');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('User is not authorized to perform this action');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('Resource not found');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}
