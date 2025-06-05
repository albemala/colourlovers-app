import 'package:colourlovers_app/analytics.dart';
import 'package:colourlovers_app/app/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/color/data-controller.dart';
import 'package:colourlovers_app/filters/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/palette/data-controller.dart';
import 'package:colourlovers_app/filters/pattern/data-controller.dart';
import 'package:colourlovers_app/filters/user/data-controller.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  await SentryFlutter.init(
    configureSentry,
    appRunner: () {
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => FavoritesDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => PreferencesDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => ColorFiltersDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => PaletteFiltersDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => PatternFiltersDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => UserFiltersDataController(),
              lazy: false, //
            ),
            BlocProvider(
              create: (_) => FavoritesFiltersDataController(),
              lazy: false, //
            ),
          ],
          child: const AppViewCreator(),
        ),
      );
    },
  );
}
