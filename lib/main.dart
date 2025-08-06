import 'package:colourlovers_app/app/view.dart';
import 'package:colourlovers_app/app_usage/data-controller.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/color/data-controller.dart';
import 'package:colourlovers_app/filters/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/palette/data-controller.dart';
import 'package:colourlovers_app/filters/pattern/data-controller.dart';
import 'package:colourlovers_app/filters/user/data-controller.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/sentry.dart';
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
          providers: const [
            BlocProvider(
              create: PreferencesDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: AppUsageDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: FavoritesDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: ColorFiltersDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: PaletteFiltersDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: PatternFiltersDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: UserFiltersDataController.fromContext,
              lazy: false, //
            ),
            BlocProvider(
              create: FavoritesFiltersDataController.fromContext,
              lazy: false, //
            ),
          ],
          child: const AppViewCreator(),
        ),
      );
    },
  );
}
