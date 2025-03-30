import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';

class EducationModel extends Education {
  const EducationModel({
    required super.institution,
    required super.degree,
    required super.field,
    required super.startDate,
    super.endDate,
    super.gpa,
    required super.achievements,
    required super.location,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      field: json['field'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
      achievements: List<String>.from(json['achievements'] as List),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  EducationModel copyWith({
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
