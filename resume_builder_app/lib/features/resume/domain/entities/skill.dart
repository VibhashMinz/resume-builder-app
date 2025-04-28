import 'package:equatable/equatable.dart';

enum SkillLevel { beginner, intermediate, advanced, expert }

class Skill extends Equatable {
  final String id;
  final String name;
  final SkillLevel level;
  final String category;
  final List<String>? endorsements;

  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    this.endorsements,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        level,
        category,
        endorsements,
      ];
}
