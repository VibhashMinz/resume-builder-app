import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class GetUserProfile {
  final AuthRepository repository;

  GetUserProfile(this.repository);

  Future<User> call(String uid) async {
    return await repository.getUserProfile(uid);
  }
}
