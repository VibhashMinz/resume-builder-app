import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/domain/repositories/resume_repository.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_model.dart';
import 'package:resume_builder_app/features/resume/data/sources/resume_remote_data_source.dart';
import 'package:resume_builder_app/features/resume/data/sources/resume_local_data_source.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ResumeRemoteDataSource _remoteDataSource;
  final ResumeLocalDataSource _localDataSource;

  ResumeRepositoryImpl({
    required this.firestore,
    required this.auth,
    required ResumeRemoteDataSource remoteDataSource,
    required ResumeLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>>> getResumes() async {
    try {
      final remoteResumes = await _remoteDataSource.getResumes();
      await _localDataSource.cacheResumes(remoteResumes);
      return remoteResumes.map((model) => model.toEntity()).toList();
    } catch (e) {
      final localResumes = await _localDataSource.getResumes();
      return localResumes.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> createResume(
      Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume) async {
    final resumeModel = ResumeModel.fromEntity(resume);
    await _remoteDataSource.createResume(resumeModel);
    return resume;
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> updateResume(
      Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume) async {
    final resumeModel = ResumeModel.fromEntity(resume);
    await _remoteDataSource.updateResume(resumeModel);
    return resume;
  }

  @override
  Future<void> deleteResume(String resumeId) async {
    await _remoteDataSource.deleteResume(resumeId);
    // Note: We don't delete from local cache as it will be updated on next fetch
  }

  @override
  Future<List<ResumeTemplate>> getAvailableTemplates() async {
    try {
      return await _remoteDataSource.getAvailableTemplates();
    } catch (e) {
      throw Exception('Failed to get available templates: $e');
    }
  }

  @override
  Future<String> generatePDF(String resumeId) async {
    try {
      return await _remoteDataSource.generatePDF(resumeId);
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  @override
  Future<String> downloadResume(String resumeId, String format) async {
    try {
      return await _remoteDataSource.downloadResume(resumeId, format);
    } catch (e) {
      throw Exception('Failed to download resume: $e');
    }
  }

  @override
  Future<void> setResumeVisibility(String id, bool isPublic) async {
    await _remoteDataSource.setResumeVisibility(id, isPublic);
  }

  @override
  Future<String> shareResume(String id) async {
    return await _remoteDataSource.shareResume(id);
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> duplicateResume(String id) async {
    final model = await _remoteDataSource.duplicateResume(id);
    final resumeModel = ResumeModel.fromEntity(model);
    await _localDataSource.cacheResume(resumeModel);
    return resumeModel.toEntity();
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> importFromLinkedIn(String linkedInUrl) async {
    final model = await _remoteDataSource.importFromLinkedIn(linkedInUrl);
    final resumeModel = ResumeModel.fromEntity(model);
    await _localDataSource.cacheResume(resumeModel);
    return resumeModel.toEntity();
  }

  @override
  Future<String> exportToJson(String id) async {
    return await _remoteDataSource.exportToJson(id);
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> importFromJson(String jsonString) async {
    final model = await _remoteDataSource.importFromJson(jsonString);
    await _localDataSource.cacheResume(model);
    return model.toEntity();
  }

  @override
  Future<Map<String, dynamic>> getResumeAnalytics(String id) async {
    try {
      return await _remoteDataSource.getResumeAnalytics(id);
    } catch (e) {
      throw Exception('Failed to get resume analytics: $e');
    }
  }

  @override
  Future<List<String>> getSuggestedSkills(String category) async {
    try {
      return await _remoteDataSource.getSuggestedSkills(category);
    } catch (e) {
      throw Exception('Failed to get suggested skills: $e');
    }
  }

  @override
  Future<List<String>> getSuggestedJobTitles() async {
    try {
      return await _remoteDataSource.getSuggestedJobTitles();
    } catch (e) {
      throw Exception('Failed to get suggested job titles: $e');
    }
  }

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> getResumeById(String resumeId) async {
    try {
      final model = await _remoteDataSource.getResumeById(resumeId);
      await _localDataSource.cacheResume(model);
      return model.toEntity();
    } catch (e) {
      final localModel = await _localDataSource.getResumeById(resumeId);
      if (localModel != null) {
        return localModel.toEntity();
      }
      rethrow;
    }
  }
}
