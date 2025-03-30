import 'package:resume_builder_app/features/resume/domain/entities/language.dart';

class LanguageModel extends Language {
  const LanguageModel({
    required super.name,
    required super.level,
    super.certification,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      name: json['name'] as String,
      level: LanguageLevel.values.firstWhere(
        (e) => e.toString() == 'LanguageLevel.${json['level']}',
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
