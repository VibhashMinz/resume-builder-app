import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;

  const SignupEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}
