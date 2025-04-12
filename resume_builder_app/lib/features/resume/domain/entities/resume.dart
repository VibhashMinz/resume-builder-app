import 'package:equatable/equatable.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';

class Resume<P extends PersonalInfo, E extends Education, W extends WorkExperience, PR extends Project, S extends Skill, L extends Language, C extends Certificate> extends Equatable {
  final String id;
  final String userId;
  final String title;
  final ResumeTemplate template;
  final P personalInfo;
  final List<E> education;
  final List<W> workExperience;
  final List<PR> projects;
  final List<S> skills;
  final List<L> languages;
  final List<C> certificates;
  final String summary;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Resume({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        template,
        personalInfo,
        education,
        workExperience,
        projects,
        skills,
        languages,
        certificates,
        summary,
        isPublic,
        createdAt,
        updatedAt,
      ];

  Resume<P, E, W, PR, S, L, C> copyWith({
    String? id,
    String? userId,
    String? title,
    ResumeTemplate? template,
    P? personalInfo,
    List<E>? education,
    List<W>? workExperience,
    List<PR>? projects,
    List<S>? skills,
    List<L>? languages,
    List<C>? certificates,
    String? summary,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Resume<P, E, W, PR, S, L, C>(
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
