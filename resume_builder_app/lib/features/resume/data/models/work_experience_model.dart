import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';

class WorkExperienceModel {
  final String company;
  final String position;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> responsibilities;
  final List<String> achievements;

  const WorkExperienceModel({
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.responsibilities,
    required this.achievements,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      responsibilities: List<String>.from(json['responsibilities'] as List? ?? []),
      achievements: List<String>.from(json['achievements'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'location': location,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'responsibilities': responsibilities,
      'achievements': achievements,
    };
  }

  factory WorkExperienceModel.fromEntity(WorkExperience entity) {
    return WorkExperienceModel(
      company: entity.company,
      position: entity.position,
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      responsibilities: entity.responsibilities,
      achievements: entity.achievements,
    );
  }

  WorkExperience toEntity() {
    return WorkExperience(
      company: company,
      position: position,
      location: location,
      startDate: startDate,
      endDate: endDate,
      responsibilities: responsibilities,
      achievements: achievements,
    );
  }

  WorkExperienceModel copyWith({
    String? company,
    String? position,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? responsibilities,
    List<String>? achievements,
  }) {
    return WorkExperienceModel(
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      responsibilities: responsibilities ?? this.responsibilities,
      achievements: achievements ?? this.achievements,
    );
  }
}
