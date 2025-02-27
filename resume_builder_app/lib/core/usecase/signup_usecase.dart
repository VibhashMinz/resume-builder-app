import 'package:resume_builder_app/core/usecase/usecase.dart';
import 'package:resume_builder_app/fetaures/auth/domain/entities/user.dart';
import 'package:resume_builder_app/fetaures/auth/domain/repositories/auth_repository.dart';

class Signup extends UseCase<User, SignupParams> {
  final AuthRepository repository;
  Signup(this.repository);

  @override
  Future<User> call(SignupParams params) {
    return repository.signup(params.email, params.password);
  }
}

class SignupParams {
  final String email;
  final String password;
  SignupParams(this.email, this.password);
}
