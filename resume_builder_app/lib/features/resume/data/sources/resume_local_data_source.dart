import 'package:resume_builder_app/features/resume/data/models/resume_model.dart';

abstract class ResumeLocalDataSource {
  Future<List<ResumeModel>> getResumes();
  Future<ResumeModel?> getResumeById(String resumeId);
  Future<void> cacheResume(ResumeModel resume);
  Future<void> cacheResumes(List<ResumeModel> resumes);
  Future<void> deleteResume(String resumeId);
}
