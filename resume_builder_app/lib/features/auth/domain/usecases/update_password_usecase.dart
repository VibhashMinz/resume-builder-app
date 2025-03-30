import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class UpdatePassword {
  final AuthRepository repository;

  UpdatePassword(this.repository);

  Future<User> call(String newPassword) async {
    return await repository.updatePassword(newPassword);
  }
}
