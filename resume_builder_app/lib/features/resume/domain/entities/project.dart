import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> technologies;
  final String? url;
  final List<String> achievements;

  const Project({
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.technologies,
    this.url,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        startDate,
        endDate,
        technologies,
        url,
        achievements,
      ];
}
