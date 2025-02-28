import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_event.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_state.dart';
import 'package:resume_builder_app/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences preferences;
  static const String _themeKey = 'isDarkMode';

  ThemeBloc({required this.preferences}) : super(ThemeInitial(preferences.getBool(_themeKey) ?? false ? AppTheme.darkTheme : AppTheme.lightTheme, preferences.getBool(_themeKey) ?? false)) {
    on<ToggleThemeEvent>((event, emit) async {
      final isDarkMode = !state.isDarkMode;
      await preferences.setBool(_themeKey, isDarkMode);
      emit(ThemeChanged(
        isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        isDarkMode,
      ));
    });

    on<SetThemeEvent>((event, emit) async {
      await preferences.setBool(_themeKey, event.isDarkMode);
      emit(ThemeChanged(
        event.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        event.isDarkMode,
      ));
    });
  }
}
