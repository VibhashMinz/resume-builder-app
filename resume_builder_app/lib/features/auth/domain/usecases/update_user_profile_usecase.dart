import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserProfile {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  Future<User> call({
    required String displayName,
    String? photoURL,
  }) async {
    return await repository.updateUserProfile(
      displayName: displayName,
      photoURL: photoURL,
    );
  }
}
