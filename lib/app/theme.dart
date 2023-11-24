import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = _setupTheme(
  FlexThemeData.light(
    scheme: FlexScheme.purpleM3,
    // tones: FlexTones.vivid(Brightness.light),
    // keyColors: const FlexKeyColors(
    //   useSecondary: true,
    //   useTertiary: true,
    // ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useM2StyleDividerInM3: true,
    ),
    swapLegacyOnMaterial3: true,
    useMaterial3: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // visualDensity: VisualDensity.compact,
    fontFamily: GoogleFonts.archivo().fontFamily,
  ),
);

final darkTheme = _setupTheme(
  FlexThemeData.dark(
    scheme: FlexScheme.purpleM3,
    // tones: FlexTones.vivid(Brightness.dark),
    // keyColors: const FlexKeyColors(
    //   useSecondary: true,
    //   useTertiary: true,
    // ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useM2StyleDividerInM3: true,
    ),
    swapLegacyOnMaterial3: true,
    useMaterial3: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // visualDensity: VisualDensity.compact,
    fontFamily: GoogleFonts.archivo().fontFamily,
  ),
);

ThemeData _setupTheme(ThemeData theme) {
  return theme.copyWith();
}
