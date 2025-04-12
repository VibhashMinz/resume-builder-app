import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/data/models/personal_info_model.dart';
import 'package:resume_builder_app/features/resume/data/models/education_model.dart';
import 'package:resume_builder_app/features/resume/data/models/work_experience_model.dart';
import 'package:resume_builder_app/features/resume/data/models/project_model.dart';
import 'package:resume_builder_app/features/resume/data/models/skill_model.dart';
import 'package:resume_builder_app/features/resume/data/models/language_model.dart';
import 'package:resume_builder_app/features/resume/data/models/certificate_model.dart';

class ResumeModel {
  final String id;
  final String userId;
  final String title;
  final ResumeTemplate template;
  final PersonalInfoModel personalInfo;
  final List<EducationModel> education;
  final List<WorkExperienceModel> workExperience;
  final List<ProjectModel> projects;
  final List<SkillModel> skills;
  final List<LanguageModel> languages;
  final List<CertificateModel> certificates;
  final String summary;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResumeModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.template,
    required this.personalInfo,
    required this.education,
    required this.workExperience,
    required this.projects,
    required this.skills,
    required this.languages,
    required this.certificates,
    required this.summary,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      template: ResumeTemplate.values[json['template'] as int],
      personalInfo: PersonalInfoModel.fromJson(json['personalInfo'] as Map<String, dynamic>),
      education: (json['education'] as List<dynamic>).map((e) => EducationModel.fromJson(e as Map<String, dynamic>)).toList(),
      workExperience: (json['workExperience'] as List<dynamic>).map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>)).toList(),
      projects: (json['projects'] as List<dynamic>).map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList(),
      skills: (json['skills'] as List<dynamic>).map((e) => SkillModel.fromJson(e as Map<String, dynamic>)).toList(),
      languages: (json['languages'] as List<dynamic>).map((e) => LanguageModel.fromJson(e as Map<String, dynamic>)).toList(),
      certificates: (json['certificates'] as List<dynamic>).map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList(),
      summary: json['summary'] as String,
      isPublic: json['isPublic'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'template': template.index,
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

  factory ResumeModel.fromEntity(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume) {
    return ResumeModel(
      id: resume.id,
      userId: resume.userId,
      title: resume.title,
      template: resume.template,
      personalInfo: PersonalInfoModel.fromEntity(resume.personalInfo),
      education: resume.education.map((e) => EducationModel.fromEntity(e)).toList(),
      workExperience: resume.workExperience.map((e) => WorkExperienceModel.fromEntity(e)).toList(),
      projects: resume.projects.map((e) => ProjectModel.fromEntity(e)).toList(),
      skills: resume.skills.map((e) => SkillModel.fromEntity(e)).toList(),
      languages: resume.languages.map((e) => LanguageModel.fromEntity(e)).toList(),
      certificates: resume.certificates.map((e) => CertificateModel.fromEntity(e)).toList(),
      summary: resume.summary,
      isPublic: resume.isPublic,
      createdAt: resume.createdAt,
      updatedAt: resume.updatedAt,
    );
  }

  Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> toEntity() {
    return Resume(
      id: id,
      userId: userId,
      title: title,
      template: template,
      personalInfo: personalInfo.toEntity(),
      education: education.map((e) => e.toEntity()).toList(),
      workExperience: workExperience.map((e) => e.toEntity()).toList(),
      projects: projects.map((e) => e.toEntity()).toList(),
      skills: skills.map((e) => e.toEntity()).toList(),
      languages: languages.map((e) => e.toEntity()).toList(),
      certificates: certificates.map((e) => e.toEntity()).toList(),
      summary: summary,
      isPublic: isPublic,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ResumeModel copyWith({
    String? id,
    String? userId,
    String? title,
    ResumeTemplate? template,
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
      template: template ?? this.template,
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
