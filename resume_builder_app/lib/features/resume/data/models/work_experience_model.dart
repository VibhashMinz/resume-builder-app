import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';

class WorkExperienceModel extends WorkExperience {
  const WorkExperienceModel({
    required super.company,
    required super.position,
    required super.startDate,
    super.endDate,
    required super.location,
    required super.responsibilities,
    required super.achievements,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      company: json['company'] as String,
      position: json['position'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      location: json['location'] as String,
      responsibilities: List<String>.from(json['responsibilities'] as List),
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'location': location,
      'responsibilities': responsibilities,
      'achievements': achievements,
    };
  }

  WorkExperienceModel copyWith({
    String? company,
    String? position,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    List<String>? responsibilities,
    List<String>? achievements,
  }) {
    return WorkExperienceModel(
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      responsibilities: responsibilities ?? this.responsibilities,
      achievements: achievements ?? this.achievements,
    );
  }
}
