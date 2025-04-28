import 'package:resume_builder_app/core/usecase/usecase.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/domain/repositories/resume_repository.dart';

class GetResume implements UseCase<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>, String> {
  final ResumeRepository repository;

  GetResume(this.repository);

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> call(String params) async {
    return await repository.getResumeById(params);
  }
}
