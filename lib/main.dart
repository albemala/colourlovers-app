import 'package:colourlovers_app/app/view.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
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
      ],
      child: const AppViewCreator(),
    ),
  );
}
