import 'package:equatable/equatable.dart';

enum SkillLevel { beginner, intermediate, advanced, expert }

class Skill extends Equatable {
  final String name;
  final SkillLevel level;
  final String category;
  final List<String>? endorsements;

  const Skill({
    required this.name,
    required this.level,
    required this.category,
    this.endorsements,
  });

  @override
  List<Object?> get props => [
        name,
        level,
        category,
        endorsements,
      ];
}
