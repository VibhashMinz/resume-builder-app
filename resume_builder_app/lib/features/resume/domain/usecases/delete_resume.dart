import 'package:resume_builder_app/core/usecase/usecase.dart';
import 'package:resume_builder_app/features/resume/domain/repositories/resume_repository.dart';

class DeleteResume implements UseCase<void, String> {
  final ResumeRepository repository;

  DeleteResume(this.repository);

  @override
  Future<void> call(String params) async {
    return await repository.deleteResume(params);
  }
}
