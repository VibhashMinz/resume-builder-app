import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;
  Signup(this.repository);

  Future<User> call(SignupParams params) {
    return repository.signup(params.email, params.password);
  }
}

class SignupParams {
  final String email;
  final String password;
  SignupParams(this.email, this.password);
}
