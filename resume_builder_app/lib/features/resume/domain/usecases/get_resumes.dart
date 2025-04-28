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

class GetResumes implements UseCase<List<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>>, void> {
  final ResumeRepository repository;

  GetResumes(this.repository);

  @override
  Future<List<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>>> call(void params) async {
    return await repository.getResumes();
  }
}
