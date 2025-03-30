import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateEmail {
  final AuthRepository repository;

  UpdateEmail(this.repository);

  Future<User> call(String newEmail) async {
    return await repository.updateEmail(newEmail);
  }
}
