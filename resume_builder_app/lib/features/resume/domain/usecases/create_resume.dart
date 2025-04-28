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

class CreateResume
    implements UseCase<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>, Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> {
  final ResumeRepository repository;

  CreateResume(this.repository);

  @override
  Future<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> call(
      Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> params) async {
    return await repository.createResume(params);
  }
}
