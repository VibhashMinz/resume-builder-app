import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';

class ProjectModel {
  final String name;
  final String description;
  final List<String> technologies;
  final String? link;
  final DateTime? startDate;
  final DateTime? endDate;

  const ProjectModel({
    required this.name,
    required this.description,
    required this.technologies,
    this.link,
    this.startDate,
    this.endDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      link: json['link'] as String?,
      startDate: json['startDate'] != null ? (json['startDate'] as Timestamp).toDate() : null,
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'link': link,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    };
  }

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel(
      name: entity.name,
      description: entity.description,
      technologies: entity.technologies,
      link: entity.link,
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }

  Project toEntity() {
    return Project(
      name: name,
      description: description,
      technologies: technologies,
      link: link,
      startDate: startDate,
      endDate: endDate,
    );
  }

  ProjectModel copyWith({
    String? name,
    String? description,
    List<String>? technologies,
    String? link,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ProjectModel(
      name: name ?? this.name,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      link: link ?? this.link,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
