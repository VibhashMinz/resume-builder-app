import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String name;
  final String description;
  final List<String> technologies;
  final String? link;
  final DateTime? startDate;
  final DateTime? endDate;

  const Project({
    required this.name,
    required this.description,
    required this.technologies,
    this.link,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'link': link,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        name,
        description,
        technologies,
        link,
        startDate,
        endDate,
      ];
}
