import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';

abstract class ResumeRepository {
  // CRUD operations
  Future<Resume> createResume(Resume resume);
  Future<Resume> getResume(String id);
  Future<List<Resume>> getUserResumes(String userId);
  Future<Resume> updateResume(Resume resume);
  Future<void> deleteResume(String id);

  // Template operations
  Future<List<ResumeTemplate>> getAvailableTemplates();
  Future<String> generatePDF(String resumeId);
  Future<String> downloadResume(String resumeId, String format);

  // Sharing and visibility
  Future<void> setResumeVisibility(String id, bool isPublic);
  Future<String> shareResume(String id);
  Future<Resume> duplicateResume(String id);

  // Import/Export
  Future<Resume> importFromLinkedIn(String linkedInUrl);
  Future<String> exportToJson(String id);
  Future<Resume> importFromJson(String jsonString);

  // Analytics
  Future<Map<String, dynamic>> getResumeAnalytics(String id);
  Future<List<String>> getSuggestedSkills(String category);
  Future<List<String>> getSuggestedJobTitles();
}
