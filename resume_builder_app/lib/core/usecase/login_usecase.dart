import 'package:resume_builder_app/core/usecase/usecase.dart';
import 'package:resume_builder_app/fetaures/auth/domain/entities/user.dart';
import 'package:resume_builder_app/fetaures/auth/domain/repositories/auth_repository.dart';

class Login extends UseCase<User, LoginParams> {
  final AuthRepository repository;
  Login(this.repository);

  @override
  Future<User> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams(this.email, this.password);
}
