import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.title,
    required super.description,
    required super.startDate,
    super.endDate,
    required super.technologies,
    super.url,
    required super.achievements,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      technologies: List<String>.from(json['technologies'] as List),
      url: json['url'] as String?,
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'technologies': technologies,
      'url': url,
      'achievements': achievements,
    };
  }

  ProjectModel copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? technologies,
    String? url,
    List<String>? achievements,
  }) {
    return ProjectModel(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      technologies: technologies ?? this.technologies,
      url: url ?? this.url,
      achievements: achievements ?? this.achievements,
    );
  }
}
