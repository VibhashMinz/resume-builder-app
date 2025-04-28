import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/create_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/update_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/delete_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resumes.dart';
part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final CreateResume createResume;
  final GetResume getResume;
  final GetResumes getResumes;
  final UpdateResume updateResume;
  final DeleteResume deleteResume;

  ResumeBloc({
    required this.createResume,
    required this.getResume,
    required this.getResumes,
    required this.updateResume,
    required this.deleteResume,
  }) : super(ResumeInitial()) {
    on<CreateResumeEvent>(_onCreateResume);
    on<GetResumeEvent>(_onGetResume);
    on<GetResumesEvent>(_onGetResumes);
    on<UpdateResumeEvent>(_onUpdateResume);
    on<DeleteResumeEvent>(_onDeleteResume);
  }

  Future<void> _onCreateResume(
    CreateResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoading());
    try {
      final resume = await createResume(event.resume);
      emit(ResumeLoaded(resume));
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }

  Future<void> _onGetResume(
    GetResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoading());
    try {
      final resume = await getResume(event.id);
      emit(ResumeLoaded(resume));
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }

  Future<void> _onGetResumes(
    GetResumesEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoading());
    try {
      final resumes = await getResumes(event.userId);
      emit(ResumesLoaded(resumes));
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }

  Future<void> _onUpdateResume(
    UpdateResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoading());
    try {
      await updateResume(event.resume);
      emit(ResumeLoaded(event.resume));
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }

  Future<void> _onDeleteResume(
    DeleteResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(ResumeLoading());
    try {
      await deleteResume(event.id);
      emit(ResumeInitial());
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }
}
