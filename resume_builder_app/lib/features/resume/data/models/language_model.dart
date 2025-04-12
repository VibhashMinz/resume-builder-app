import 'package:resume_builder_app/features/resume/domain/entities/language.dart';

class LanguageModel {
  final String name;
  final LanguageLevel level;
  final String? certification;

  const LanguageModel({
    required this.name,
    required this.level,
    this.certification,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      name: json['name'] as String,
      level: LanguageLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['level'] as String,
        orElse: () => LanguageLevel.beginner,
      ),
      certification: json['certification'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level.toString().split('.').last,
      'certification': certification,
    };
  }

  factory LanguageModel.fromEntity(Language entity) {
    return LanguageModel(
      name: entity.name,
      level: entity.level,
      certification: entity.certification,
    );
  }

  Language toEntity() {
    return Language(
      name: name,
      level: level,
      certification: certification,
    );
  }

  LanguageModel copyWith({
    String? name,
    LanguageLevel? level,
    String? certification,
  }) {
    return LanguageModel(
      name: name ?? this.name,
      level: level ?? this.level,
      certification: certification ?? this.certification,
    );
  }
}
