import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ====== App Bar styles ======

TextStyle getAppBarTitleTextStyle(BuildContext context) {
  return GoogleFonts.archivoNarrow(
    textStyle: Theme.of(context).textTheme.bodyLarge,
    letterSpacing: 0.6,
  );
}

// ====== Header styles ======

TextStyle getH1TextStyle(BuildContext context) {
  return GoogleFonts.archivoNarrow(
    textStyle: Theme.of(context).textTheme.headlineMedium,
    letterSpacing: 0.6,
  );
}

TextStyle getH2TextStyle(BuildContext context) {
  return GoogleFonts.archivoNarrow(
    textStyle: Theme.of(context).textTheme.bodyMedium,
    letterSpacing: 0.6,
  );
}

// ====== Tile styles ======

TextStyle getExploreTileTextStyle(BuildContext context) {
  return GoogleFonts.archivoNarrow(
    textStyle: Theme.of(context).textTheme.bodyLarge,
    color: Theme.of(context).colorScheme.surface,
    letterSpacing: 0.6,
  );
}

TextStyle getItemTileTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: Theme.of(context).colorScheme.surface,
  );
}

// ====== Details styles ======

TextStyle getDetailsHeaderTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleLarge!;
}

TextStyle getUserNameTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleLarge!;
}

// ====== Label Value styles ======

TextStyle getValueTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineMedium!.copyWith(
    color: Theme.of(context).colorScheme.tertiary,
  );
}

// ====== Color values styles ======

TextStyle getColorChannelTextStyle(BuildContext context) {
  return GoogleFonts.archivoNarrow(
    textStyle: Theme.of(context).textTheme.bodyMedium,
    letterSpacing: 0.6,
  );
}

TextStyle getColorValueTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium!;
}

// ====== Pill styles ======

TextStyle getPillTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: Theme.of(context).colorScheme.surface,
  );
}

// ====== Link styles ======

TextStyle getLinkTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: Theme.of(context).colorScheme.primary,
    decoration: TextDecoration.underline,
    decorationColor: Theme.of(context).colorScheme.primary,
    decorationThickness: 2,
  );
}
