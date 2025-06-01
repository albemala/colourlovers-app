import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// Constants
// ============================================================

const _subThemesData = FlexSubThemesData(
  defaultRadius: 8,
  interactionEffects: true,
  tintedDisabledControls: true,
  inputDecoratorIsFilled: true,
  inputDecoratorBorderType: FlexInputBorderType.underline,
  alignedDropdown: true,
);

const _visualDensity = VisualDensity.compact;

final _fontFamily = GoogleFonts.archivo().fontFamily;

// ============================================================
// Theme Generation
// ============================================================

ThemeData getLightTheme(FlexScheme flexScheme) {
  return _applyThemeDefaults(
    FlexThemeData.light(
      scheme: flexScheme,
      subThemesData: _subThemesData,
      visualDensity: _visualDensity,
      fontFamily: _fontFamily,
    ),
  );
}

ThemeData getDarkTheme(FlexScheme flexScheme) {
  return _applyThemeDefaults(
    FlexThemeData.dark(
      scheme: flexScheme,
      subThemesData: _subThemesData,
      visualDensity: _visualDensity,
      fontFamily: _fontFamily,
    ),
  );
}

ThemeData _applyThemeDefaults(ThemeData themeData) {
  return themeData.copyWith();
}
