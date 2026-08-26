import 'package:flutter/material.dart';

import 'colors.dart';

final appInputDecorationTheme = InputDecorationTheme(
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
  labelStyle: TextStyle(color: AppColors.secondary),
  fillColor: AppColors.surface,
  suffixIconColor: AppColors.secondary,
);
