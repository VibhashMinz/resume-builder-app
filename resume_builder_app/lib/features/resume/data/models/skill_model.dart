import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';

class SkillModel extends Skill {
  const SkillModel({
    required super.name,
    required super.level,
    required super.category,
    super.endorsements,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      level: SkillLevel.values.firstWhere(
        (e) => e.toString() == 'SkillLevel.${json['level']}',
        orElse: () => SkillLevel.beginner,
      ),
      category: json['category'] as String,
      endorsements: json['endorsements'] != null ? List<String>.from(json['endorsements'] as List) : null,
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
