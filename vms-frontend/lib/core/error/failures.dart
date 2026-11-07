import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed. Please check your backend server at http://localhost:8081.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.statusCode]);
}

class DuplicateVehicleFailure extends Failure {
  const DuplicateVehicleFailure(super.message, [super.statusCode = 409]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.statusCode = 400]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred.']);
}
