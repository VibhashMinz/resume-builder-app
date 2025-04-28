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

class UpdateUserProfileEvent extends AuthEvent {
  final String displayName;
  final String? photoURL;

  const UpdateUserProfileEvent({
    required this.displayName,
    this.photoURL,
  });

  @override
  List<Object?> get props => [displayName, photoURL];
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;

  const UpdatePasswordEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

class SendEmailVerificationEvent extends AuthEvent {
  const SendEmailVerificationEvent();
}
