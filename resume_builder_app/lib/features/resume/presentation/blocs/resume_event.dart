part of 'resume_bloc.dart';

abstract class ResumeEvent {}

class CreateResumeEvent extends ResumeEvent {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  CreateResumeEvent(this.resume);
}

class UpdateResumeEvent extends ResumeEvent {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  UpdateResumeEvent(this.resume);
}

class DeleteResumeEvent extends ResumeEvent {
  final String id;

  DeleteResumeEvent(this.id);
}

class GetResumeEvent extends ResumeEvent {
  final String id;

  GetResumeEvent(this.id);
}

class GetResumesEvent extends ResumeEvent {
  final String userId;

  GetResumesEvent(this.userId);
}
