import 'package:resume_builder_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> signup(String email, String password);
}
