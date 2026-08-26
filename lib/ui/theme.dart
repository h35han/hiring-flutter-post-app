import 'package:flutter/material.dart';

import 'tokens/checkbox_theme.dart';
import 'tokens/colors.dart';
import 'tokens/input_theme.dart';

final appThemeData = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary1,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    error: AppColors.critical,
    onError: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
  ),
  scaffoldBackgroundColor: AppColors.white,
  inputDecorationTheme: appInputDecorationTheme,
  checkboxTheme: appCheckboxThemeData,
);
