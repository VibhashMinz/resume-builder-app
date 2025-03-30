import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/data/models/personal_info_model.dart';
import 'package:resume_builder_app/features/resume/data/models/education_model.dart';
import 'package:resume_builder_app/features/resume/data/models/work_experience_model.dart';
import 'package:resume_builder_app/features/resume/data/models/project_model.dart';
import 'package:resume_builder_app/features/resume/data/models/skill_model.dart';
import 'package:resume_builder_app/features/resume/data/models/language_model.dart';
import 'package:resume_builder_app/features/resume/data/models/certificate_model.dart';

class ResumeModel extends Resume<PersonalInfoModel, EducationModel, WorkExperienceModel, ProjectModel, SkillModel, LanguageModel, CertificateModel> {
  const ResumeModel({
    required String id,
    required String userId,
    required String title,
    required PersonalInfoModel personalInfo,
    required List<EducationModel> education,
    required List<WorkExperienceModel> workExperience,
    required List<ProjectModel> projects,
    required List<SkillModel> skills,
    required List<LanguageModel> languages,
    required List<CertificateModel> certificates,
    required String summary,
    required bool isPublic,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          userId: userId,
          title: title,
          personalInfo: personalInfo,
          education: education,
          workExperience: workExperience,
          projects: projects,
          skills: skills,
          languages: languages,
          certificates: certificates,
          summary: summary,
          isPublic: isPublic,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      personalInfo: PersonalInfoModel.fromJson(json['personalInfo'] as Map<String, dynamic>),
      education: (json['education'] as List<dynamic>).map((e) => EducationModel.fromJson(e as Map<String, dynamic>)).toList(),
      workExperience: (json['workExperience'] as List<dynamic>).map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>)).toList(),
      projects: (json['projects'] as List<dynamic>).map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList(),
      skills: (json['skills'] as List<dynamic>).map((e) => SkillModel.fromJson(e as Map<String, dynamic>)).toList(),
      languages: (json['languages'] as List<dynamic>).map((e) => LanguageModel.fromJson(e as Map<String, dynamic>)).toList(),
      certificates: (json['certificates'] as List<dynamic>).map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList(),
      summary: json['summary'] as String,
      isPublic: json['isPublic'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'personalInfo': personalInfo.toJson(),
      'education': education.map((e) => e.toJson()).toList(),
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'certificates': certificates.map((e) => e.toJson()).toList(),
      'summary': summary,
      'isPublic': isPublic,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ResumeModel copyWith({
    String? id,
    String? userId,
    String? title,
    PersonalInfoModel? personalInfo,
    List<EducationModel>? education,
    List<WorkExperienceModel>? workExperience,
    List<ProjectModel>? projects,
    List<SkillModel>? skills,
    List<LanguageModel>? languages,
    List<CertificateModel>? certificates,
    String? summary,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      certificates: certificates ?? this.certificates,
      summary: summary ?? this.summary,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
