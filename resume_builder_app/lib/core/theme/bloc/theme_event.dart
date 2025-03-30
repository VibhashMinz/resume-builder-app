abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final bool isDarkMode;
  SetThemeEvent(this.isDarkMode);
}
