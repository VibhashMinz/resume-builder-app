part of 'resume_bloc.dart';

abstract class ResumeState {}

class ResumeInitial extends ResumeState {}

class ResumeLoading extends ResumeState {}

class ResumeLoaded extends ResumeState {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  ResumeLoaded(this.resume);
}

class ResumesLoaded extends ResumeState {
  final List<Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>> resumes;

  ResumesLoaded(this.resumes);
}

class ResumeError extends ResumeState {
  final String message;

  ResumeError(this.message);
}
