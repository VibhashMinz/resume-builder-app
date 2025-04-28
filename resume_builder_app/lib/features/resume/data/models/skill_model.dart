import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';

class SkillModel {
  final String id;
  final String name;
  final SkillLevel level;
  final String category;
  final List<String>? endorsements;

  const SkillModel({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    this.endorsements,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      level: SkillLevel.values.firstWhere(
        (e) => e.toString() == 'SkillLevel.${json['level']}',
      ),
      category: json['category'] as String,
      endorsements: (json['endorsements'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level.toString().split('.').last,
      'category': category,
      if (endorsements != null) 'endorsements': endorsements,
    };
  }

  factory SkillModel.fromEntity(Skill skill) {
    return SkillModel(
      id: skill.id,
      name: skill.name,
      level: skill.level,
      category: skill.category,
      endorsements: skill.endorsements,
    );
  }

  Skill toEntity() {
    return Skill(
      id: id,
      name: name,
      level: level,
      category: category,
      endorsements: endorsements,
    );
  }

  SkillModel copyWith({
    String? id,
    String? name,
    SkillLevel? level,
    String? category,
    List<String>? endorsements,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
      endorsements: endorsements ?? this.endorsements,
    );
  }
}
