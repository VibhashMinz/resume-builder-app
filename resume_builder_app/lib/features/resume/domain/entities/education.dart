import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;
  final List<String> achievements;
  final String location;

  const Education({
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
    required this.achievements,
    required this.location,
  });

  @override
  List<Object?> get props => [
        institution,
        degree,
        field,
        startDate,
        endDate,
        gpa,
        achievements,
        location,
      ];
}
