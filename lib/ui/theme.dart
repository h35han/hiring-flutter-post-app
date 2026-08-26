import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens/checkbox_theme.dart';
import 'tokens/colors.dart';
import 'tokens/input_theme.dart';

final appThemeData = ThemeData(
  textTheme: GoogleFonts.lexendDecaTextTheme(),
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
