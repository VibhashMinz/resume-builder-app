import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

abstract class ResumeRepository {
  // CRUD operations
  Future<List<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>>> getResumes();
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> createResume(
      Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume);
  Future<void> updateResume(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume);
  Future<void> deleteResume(String resumeId);

  // Template operations
  Future<List<ResumeTemplate>> getAvailableTemplates();
  Future<String> generatePDF(String resumeId);
  Future<String> downloadResume(String resumeId, String format);

  // Sharing and visibility
  Future<void> setResumeVisibility(String id, bool isPublic);
  Future<String> shareResume(String id);
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> duplicateResume(String id);

  // Import/Export
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> importFromLinkedIn(String linkedInUrl);
  Future<String> exportToJson(String id);
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> importFromJson(String jsonString);

  // Analytics
  Future<Map<String, dynamic>> getResumeAnalytics(String id);
  Future<List<String>> getSuggestedSkills(String category);
  Future<List<String>> getSuggestedJobTitles();

  // Additional operations
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> getResumeById(String resumeId);
}
