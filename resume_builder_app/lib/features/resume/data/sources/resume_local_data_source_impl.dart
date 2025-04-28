import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_model.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'resume_local_data_source.dart';

class ResumeLocalDataSourceImpl implements ResumeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _resumesKey = 'resumes';

  ResumeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ResumeModel>> getResumes() async {
    final resumesJson = sharedPreferences.getStringList(_resumesKey) ?? [];
    return resumesJson.map((json) => ResumeModel.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<ResumeModel?> getResumeById(String resumeId) async {
    final resumes = await getResumes();
    try {
      return resumes.firstWhere((resume) => resume.id == resumeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheResume(ResumeModel resume) async {
    final resumes = await getResumes();
    final index = resumes.indexWhere((r) => r.id == resume.id);

    if (index != -1) {
      resumes[index] = resume;
    } else {
      resumes.add(resume);
    }

    await cacheResumes(resumes);
  }

  @override
  Future<void> cacheResumes(List<ResumeModel> resumes) async {
    final resumesJson = resumes.map((resume) => jsonEncode(resume.toJson())).toList();
    await sharedPreferences.setStringList(_resumesKey, resumesJson);
  }

  @override
  Future<void> deleteResume(String resumeId) async {
    final resumes = await getResumes();
    resumes.removeWhere((resume) => resume.id == resumeId);
    await cacheResumes(resumes);
  }
}
