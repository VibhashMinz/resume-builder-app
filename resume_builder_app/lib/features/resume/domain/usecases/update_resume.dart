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

class UpdateResume implements UseCase<void, Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> {
  final ResumeRepository repository;

  UpdateResume(this.repository);

  @override
  Future<void> call(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> params) async {
    return await repository.updateResume(params);
  }
}
