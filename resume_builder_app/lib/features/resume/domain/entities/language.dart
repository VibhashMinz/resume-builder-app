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

  @override
  List<Object?> get props => [
        name,
        level,
        certification,
      ];
}
