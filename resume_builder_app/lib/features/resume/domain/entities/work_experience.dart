import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final List<String> responsibilities;
  final List<String> achievements;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.responsibilities,
    required this.achievements,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'responsibilities': responsibilities,
      'achievements': achievements,
    };
  }

  @override
  List<Object?> get props => [
        id,
        company,
        position,
        startDate,
        endDate,
        location,
        responsibilities,
        achievements,
      ];
}
