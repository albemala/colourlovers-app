import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// const _defaultScheme = FlexScheme.purpleM3;
// const _surfaceMode = FlexSurfaceMode.levelSurfacesLowScaffold;
const _surfaceMode = FlexSurfaceMode.highScaffoldLowSurfaces;
// const _radius = 0.0;
const _visualDensity = VisualDensity.compact;
// const _visualDensity = VisualDensity.comfortablePlatformDensity;
final _fontFamily = GoogleFonts.archivo().fontFamily;

ThemeData getLightTheme(
  FlexScheme flexScheme,
) {
  return _applyThemeDefaults(
    FlexThemeData.light(
      // tones: FlexTones.soft(Brightness.light),
      // keyColors: const FlexKeyColors(),
      useMaterial3: true,
      scheme: flexScheme,
      surfaceMode: _surfaceMode,
      // blendLevel: 2,
      // blendLevel: 7,
      subThemesData: const FlexSubThemesData(
          // blendOnLevel: 10,
          // defaultRadius: _radius,
          ),
      visualDensity: _visualDensity,
      fontFamily: _fontFamily,
    ),
  );
}

ThemeData getDarkTheme(
  FlexScheme flexScheme,
) {
  return _applyThemeDefaults(
    FlexThemeData.dark(
      // tones: FlexTones.soft(Brightness.dark),
      // keyColors: const FlexKeyColors(),
      useMaterial3: true,
      scheme: flexScheme,
      surfaceMode: _surfaceMode,
      // blendLevel: 8,
      // blendLevel: 13,
      subThemesData: const FlexSubThemesData(
          // blendOnLevel: 20,
          // defaultRadius: _radius,
          ),
      visualDensity: _visualDensity,
      fontFamily: _fontFamily,
    ),
  );
}

ThemeData _applyThemeDefaults(ThemeData themeData) {
  return themeData.copyWith(
    iconTheme: themeData.iconTheme.copyWith(
        // size: 18, // TODO
        ),
  );
}
