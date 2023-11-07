import 'package:colourlovers_app/blocs/preferences.dart';
import 'package:colourlovers_app/views/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false; // TODO restore

  runApp(
    const BlocProvider(
      create: PreferencesBloc.fromContext,
      child: AppView(),
    ),
  );
}
