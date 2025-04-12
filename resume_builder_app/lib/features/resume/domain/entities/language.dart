import 'package:equatable/equatable.dart';

enum LanguageLevel { beginner, intermediate, advanced, native }

class Language extends Equatable {
  final String name;
  final LanguageLevel level;
  final String? certification;

  const Language({
    required this.name,
    required this.level,
    this.certification,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level.toString().split('.').last,
      'certification': certification,
    };
  }

  @override
  List<Object?> get props => [
        name,
        level,
        certification,
      ];
}
