import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final List<String> responsibilities;
  final List<String> achievements;

  const WorkExperience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.responsibilities,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        company,
        position,
        startDate,
        endDate,
        location,
        responsibilities,
        achievements,
      ];
}
