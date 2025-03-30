import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class SendEmailVerification {
  final AuthRepository repository;

  SendEmailVerification(this.repository);

  Future<void> call() async {
    await repository.sendEmailVerification();
  }
}
