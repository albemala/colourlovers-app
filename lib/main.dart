import 'package:colourlovers_app/app/view.dart';
import 'package:colourlovers_app/color-filters/data-controller.dart';
import 'package:colourlovers_app/palette-filters/data-controller.dart';
import 'package:colourlovers_app/pattern-filters/data-controller.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/user-filters/data-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PreferencesDataController()),
        BlocProvider(create: (_) => ColorFiltersDataController()),
        BlocProvider(create: (_) => PaletteFiltersDataController()),
        BlocProvider(create: (_) => PatternFiltersDataController()),
        BlocProvider(create: (_) => UserFiltersDataController()),
      ],
      child: const AppViewCreator(),
    ),
  );
}
