import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';

class EducationModel {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;
  final List<String> achievements;
  final String location;

  const EducationModel({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
    required this.achievements,
    required this.location,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      field: json['field'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      gpa: json['gpa'] as double?,
      achievements: List<String>.from(json['achievements'] as List),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field': field,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'gpa': gpa,
      'achievements': achievements,
      'location': location,
    };
  }

  factory EducationModel.fromEntity(Education entity) {
    return EducationModel(
      id: entity.id,
      institution: entity.institution,
      degree: entity.degree,
      field: entity.field,
      startDate: entity.startDate,
      endDate: entity.endDate,
      gpa: entity.gpa,
      achievements: entity.achievements,
      location: entity.location,
    );
  }

  Education toEntity() {
    return Education(
      id: id,
      institution: institution,
      degree: degree,
      field: field,
      startDate: startDate,
      endDate: endDate,
      gpa: gpa,
      achievements: achievements,
      location: location,
    );
  }

  EducationModel copyWith({
    String? id,
    String? institution,
    String? degree,
    String? field,
    DateTime? startDate,
    DateTime? endDate,
    double? gpa,
    List<String>? achievements,
    String? location,
  }) {
    return EducationModel(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gpa: gpa ?? this.gpa,
      achievements: achievements ?? this.achievements,
      location: location ?? this.location,
    );
  }
}
