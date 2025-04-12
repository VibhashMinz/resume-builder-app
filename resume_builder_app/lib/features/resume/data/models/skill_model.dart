import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';

class SkillModel {
  final String name;
  final SkillLevel level;
  final String category;
  final List<String>? endorsements;

  const SkillModel({
    required this.name,
    required this.level,
    required this.category,
    this.endorsements,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      level: SkillLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['level'] as String,
        orElse: () => SkillLevel.beginner,
      ),
      category: json['category'] as String,
      endorsements: List<String>.from(json['endorsements'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level.toString().split('.').last,
      'category': category,
      'endorsements': endorsements,
    };
  }

  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(
      name: entity.name,
      level: entity.level,
      category: entity.category,
      endorsements: entity.endorsements,
    );
  }

  Skill toEntity() {
    return Skill(
      name: name,
      level: level,
      category: category,
      endorsements: endorsements,
    );
  }

  SkillModel copyWith({
    String? name,
    SkillLevel? level,
    String? category,
    List<String>? endorsements,
  }) {
    return SkillModel(
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
      endorsements: endorsements ?? this.endorsements,
    );
  }
}
