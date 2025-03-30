import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<void> call(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}
