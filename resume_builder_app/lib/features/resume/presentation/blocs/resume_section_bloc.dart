import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_section_model.dart';
import 'package:resume_builder_app/features/resume/data/repositories/resume_section_repository.dart';

// Events
abstract class ResumeSectionEvent extends Equatable {
  const ResumeSectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadResumeSections extends ResumeSectionEvent {
  final String resumeId;

  const LoadResumeSections(this.resumeId);

  @override
  List<Object?> get props => [resumeId];
}

class CreateResumeSection extends ResumeSectionEvent {
  final ResumeSectionModel section;

  const CreateResumeSection(this.section);

  @override
  List<Object?> get props => [section];
}

class UpdateResumeSection extends ResumeSectionEvent {
  final ResumeSectionModel section;

  const UpdateResumeSection(this.section);

  @override
  List<Object?> get props => [section];
}

class DeleteResumeSection extends ResumeSectionEvent {
  final String sectionId;

  const DeleteResumeSection(this.sectionId);

  @override
  List<Object?> get props => [sectionId];
}

// States
abstract class ResumeSectionState extends Equatable {
  const ResumeSectionState();

  @override
  List<Object?> get props => [];
}

class ResumeSectionInitial extends ResumeSectionState {}

class ResumeSectionLoading extends ResumeSectionState {}

class ResumeSectionLoaded extends ResumeSectionState {
  final List<ResumeSectionModel> sections;

  const ResumeSectionLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

class ResumeSectionError extends ResumeSectionState {
  final String message;

  const ResumeSectionError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ResumeSectionBloc extends Bloc<ResumeSectionEvent, ResumeSectionState> {
  final ResumeSectionRepository _repository;

  ResumeSectionBloc({required ResumeSectionRepository repository})
      : _repository = repository,
        super(ResumeSectionInitial()) {
    on<LoadResumeSections>(_onLoadResumeSections);
    on<CreateResumeSection>(_onCreateResumeSection);
    on<UpdateResumeSection>(_onUpdateResumeSection);
    on<DeleteResumeSection>(_onDeleteResumeSection);
  }

  Future<void> _onLoadResumeSections(
    LoadResumeSections event,
    Emitter<ResumeSectionState> emit,
  ) async {
    try {
      emit(ResumeSectionLoading());
      final sections = await _repository.getSectionsByResumeId(event.resumeId);
      emit(ResumeSectionLoaded(sections));
    } catch (e) {
      emit(ResumeSectionError(e.toString()));
    }
  }

  Future<void> _onCreateResumeSection(
    CreateResumeSection event,
    Emitter<ResumeSectionState> emit,
  ) async {
    try {
      await _repository.createSection(event.section);
      final sections = await _repository.getSectionsByResumeId(event.section.resumeId);
      emit(ResumeSectionLoaded(sections));
    } catch (e) {
      emit(ResumeSectionError(e.toString()));
    }
  }

  Future<void> _onUpdateResumeSection(
    UpdateResumeSection event,
    Emitter<ResumeSectionState> emit,
  ) async {
    try {
      await _repository.updateSection(event.section);
      final sections = await _repository.getSectionsByResumeId(event.section.resumeId);
      emit(ResumeSectionLoaded(sections));
    } catch (e) {
      emit(ResumeSectionError(e.toString()));
    }
  }

  Future<void> _onDeleteResumeSection(
    DeleteResumeSection event,
    Emitter<ResumeSectionState> emit,
  ) async {
    try {
      await _repository.deleteSection(event.sectionId);
      if (state is ResumeSectionLoaded) {
        final currentState = state as ResumeSectionLoaded;
        final updatedSections = currentState.sections.where((section) => section.id != event.sectionId).toList();
        emit(ResumeSectionLoaded(updatedSections));
      }
    } catch (e) {
      emit(ResumeSectionError(e.toString()));
    }
  }
}
