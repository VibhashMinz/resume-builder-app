import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  final bool isDarkMode;

  const ThemeState(this.themeData, this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(super.themeData, super.isDarkMode);
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(super.themeData, super.isDarkMode);
}
